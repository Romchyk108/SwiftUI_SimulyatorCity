//
//  DashboardManager.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import Foundation
import SwiftUI

class DashboardManager: ObservableObject {
    enum Weather: String {
        case sunrise = "sunrise.fill";
        case sunset = "sunset.fill";
        case sunny = "sun.max.fill";
        case sunnyAndCloudy = "cloud.sun.fill";
        case cloudy = "cloud.fill";
        case windyNight = "wind";
        case rainy = "cloud.rain.fill";
        case heavyRain = "cloud.heavyrain.fill";
        case thunderstorm = "cloud.bolt.rain.fill";
        case moon = "moon.stars.fill";
        case cloudyMoon = "cloud.moon.fill";
        case rainyMoon = "cloud.moon.rain.fill";
    }
    static var timeInterval = 0.75
    static var currentTime: Double = 1262300000
    
    @Published var dashboard: Dashboard
    
    var energySources = GeneratingEnergyManager.energyManagers
    var houses = HouseManager.houseManagers
    
    private var year: Int = 0
    private var month: Int = 0
    private var day: Int = 0
    private var hour: Int = 0
    
    var weather: Weather = .cloudy
    var workers: Int { self.energySources.map{ $0.totalWorkers }.reduce(0, +) }
    var people: Int { Int(round(Double(workers) * 2.5)) }
    var placesForPeople: Int {
        houses.reduce(0, { partialResult, houseManager in
            partialResult + (houseManager.house.numberCanLiveHere * houseManager.count)
        })
    }
    var consumeEnergy: Double {
        var coefficient: Double
        switch self.hour {
        case 5, 21: coefficient = Double(Array(70...85).randomElement() ?? 80) / 100.0
        case 6, 20: coefficient = Double(Array(85...115).randomElement() ?? 90) / 100.0
        case 7, 18: coefficient = Double(Array(105...130).randomElement() ?? 120) / 100.0
        case 8: coefficient = Double(Array(90...130).randomElement() ?? 110) / 100.0
        case 9, 17: coefficient = Double(Array(75...95).randomElement() ?? 90) / 100.0
        case 10...13: coefficient = Double(Array(50...75).randomElement() ?? 75) / 100.0
        case 14...16, 22: coefficient = Double(Array(40...60).randomElement() ?? 40) / 100.0
        case 19: coefficient = Double(Array(115...135).randomElement() ?? 140) / 100.0
        default:
            coefficient = Double(Array(30...55).randomElement() ?? 35) / 100.0
        }
        return houses.reduce(0, { $0 + $1.consumeElectricity }) * coefficient
    }
    
    var profit: Double {
        let sellElectricity: Bool = UserDefaults.standard.bool(forKey: "sellElectricity")
        let differencesElectricity = sellElectricity ? dashboard.generatedEnergy - (dashboard.consumeEnergy * 0.95) : 0.0
        let profit = differencesElectricity * 0.04
        return profit
    }
    
    private var timer: Timer?
    private var runner: (() -> ())?
    private var isStarted: Bool = false {
        didSet {
            if oldValue != isStarted, isStarted {
                setRunner()
            }
        }
    }
    
    init() {
        self.dashboard = Dashboard(money: 0, workers: 0, people: 0, placesForPeople: 0, date: "", weather: "", energyPrice: 0.0, generatedEnergy: 0.0, consumeEnergy: 0.0, state: .pause)
        self.dashboard = createDashboard()
        
        setRunner()
    }
    
    func setStateButtons() {
        switch dashboard.state {
        case .pause:
            isStarted = false
        case .play:
            isStarted = true
            Self.timeInterval = 0.75
        case .forward:
            isStarted = true
            Self.timeInterval = 0.1
        }
    }
    
    @objc func updateDashboard() {
        Self.currentTime += 3600
        createTimeLine(time: Self.currentTime)
        dashboard.date = "\(year).\(month).\(day) / \(hour)"
        self.weather = setWeather(hour: hour)
        dashboard.money = Money.shared.money
        dashboard.weather = weather.rawValue
        dashboard.generatedEnergy = GeneratingEnergyManager.calculateEnergy(weather: weather)
        dashboard.workers = self.workers
        dashboard.people = self.people
        dashboard.placesForPeople = self.placesForPeople
        dashboard.consumeEnergy = self.consumeEnergy
        energySources.forEach({ $0.checkTime()})
        houses.forEach({ $0.checkTime() })
        setUpPeopleInTheirHouse()
        Money.addProfit(self.profit)
    }
    
    func setUpPeopleInTheirHouse() {
        let places = houses.reduce(0) { partialResult, houseManager in
            partialResult + (houseManager.numberWhoLiveHere)
        }
        guard people != places else { return }
        var peopleWithoutHouse = people - places
        for house in houses {
            peopleWithoutHouse = house.setUpPeopleInTheirHouse(people: &peopleWithoutHouse)
        }
    }
    
    private func setRunner() {
        self.runner = { [weak self] in
            guard let self, self.isStarted else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.timeInterval) { [weak self] in
                if let self, self.isStarted {
                    self.updateDashboard()
                    self.runner?()
                }
            }
        }
        self.runner?()
    }
    
    private func createTimeLine(time: Double) {
        let calendar = Calendar.current
        let time = Date(timeIntervalSince1970: time)
        self.year = calendar.component(.year, from: time)
        self.month = calendar.component(.month, from: time)
        self.day = calendar.component(.day, from: time)
        self.hour = calendar.component(.hour, from: time)
    }
    
    private func setWeather(hour: Int) -> Weather {
        let day: Bool = hour > 6 && hour < 21 ? true : false
        if hour == 6 {
            return .sunrise
        }
        if hour == 21 {
            return .sunset
        }
        if !day, let nightWeather: Weather = [.moon, .moon, .moon, .cloudyMoon, .cloudyMoon, .cloudyMoon, .windyNight, .rainyMoon].randomElement() {
            return nightWeather
        }
        if day, let dayWeather: Weather = [.sunny, .sunny, .sunny, .cloudy, .sunnyAndCloudy, .sunnyAndCloudy, .sunnyAndCloudy, .cloudy, .cloudy, .rainy, .heavyRain, .thunderstorm].randomElement() {
            return dayWeather
        }
        return .windyNight
    }
    
    private func createDashboard() -> Dashboard {
        let dashboard = Dashboard(money: Money.shared.money, workers: self.workers, people: self.people, placesForPeople: placesForPeople, date: "\(year).\(month).\(day) - \(hour)", weather: weather.rawValue, energyPrice: 0.1, generatedEnergy: GeneratingEnergyManager.calculateEnergy(weather: self.weather), consumeEnergy: self.consumeEnergy, state: .pause)
        return dashboard
    }
}
