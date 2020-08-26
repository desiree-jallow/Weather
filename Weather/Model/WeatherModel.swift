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
    let conditionID: Int
    let currentTemp: Double
    let hourlyArray: [HourlyModel]
    let dailyArray: [DailyModel]
    let description: String
    var currentTempString: String {
            String(format: "%.0f°", currentTemp)
        }
    
    var conditionName: String {
        switch conditionID {
           case 200...232:
               return "stormy"
           case 300...321:
               return "drizzle"
           case 500...531:
               return "rain"
           case 600...622:
               return "snow"
           case 701...781:
               return "fog"
           case 800:
               return "sunny"
           default:
               return "cloudy"
           }
        }
    
    }

struct HourlyModel {
    let conditionID: Int
    let temp: Double
    var tempString: String {
        String(format: "%.0f°", temp)
    }
    
    var conditionName: String {
           switch conditionID {
              case 200...232:
                  return "stormy"
              case 300...321:
                  return "drizzle"
              case 500...531:
                  return "rain"
              case 600...622:
                  return "snow"
              case 701...781:
                  return "fog"
              case 800:
                  return "sunny"
              default:
                  return "cloudy"
        }
    }
    
}

struct DailyModel {
    let conditionID: Int
    let temp: Double
    var tempString: String {
        String(format: "%.0f°", temp)
    }
    var conditionName: String {
           switch conditionID {
              case 200...232:
                  return "stormy"
              case 300...321:
                  return "drizzle"
              case 500...531:
                  return "rain"
              case 600...622:
                  return "snow"
              case 701...781:
                  return "fog"
              case 800:
                  return "sunny"
              default:
                  return "cloudy"
        }
    }
}



