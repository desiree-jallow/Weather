//
//  WeatherModel.swift
//  Weather
//
//  Created by Desiree on 8/18/20.
//  Copyright © 2020 Desiree. All rights reserved.
//

import Foundation
//for ui

struct WeatherModel {
    let conditionId: Int
    let currentTemp: Double
    let hourlyArray: [HourlyModel]
    let dailyArray: [DailyModel]
    let description: String
    var currentTempString: String {
            String(format: "%.0f°", currentTemp)
        }
    
    var conditionName: String {
        switch conditionId {
           case 200...232:
               return "cloud.bolt.rain"
           case 300...321:
               return "cloud.drizzle"
           case 500...531:
               return "cloud.rain"
           case 600...622:
               return "snow"
           case 701...781:
               return "cloud.fog"
           case 800:
               return "sun.min"
           default:
               return "cloud"
           }
        }
    
    }

struct HourlyModel {
    let conditionID: Int
    let temp: Double
    
    
}

struct DailyModel{
    let conditionID: Int
    let temp: Double
}



