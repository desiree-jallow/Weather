//
//  WeatherData.swift
//  Weather
//
//  Created by Desiree on 8/18/20.
//  Copyright © 2020 Desiree. All rights reserved.
//

import Foundation

//from API

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Current: Codable {
    let temp: Double
    let weather: [Weather]
}


struct Hourly: Codable {
    let temp: Double
    let weather: [Weather]
}

struct Temp: Codable {
    let day: Double
}

struct Daily: Codable {
    let temp: Temp
    let weather: [Weather]
}

struct WeatherData: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}



