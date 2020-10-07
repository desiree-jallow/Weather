//
//  WeatherManager.swift
//  Weather
//
//  Created by Desiree on 8/18/20.
//  Copyright © 2020 Desiree. All rights reserved.
//

import Foundation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?appid=a25ec870afc55645547d55434fe207f1&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    var weather: WeatherModel?
        
   static var instance = WeatherManager()
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) {
           let urlString = "\(weatherURL)&lon=\(longitude)&lat=\(latitude)"
           performRequest(with: urlString)
       }

    func performRequest(with urlString: String) {
        
        //Create a url
        if let url = URL(string: urlString) {
            //create url session
            let session = URLSession(configuration: .default)
            //give session a task
            
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //parse data
                if let safeData = data {
                    if let myDataWeather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: myDataWeather)
                            WeatherManager.instance.weather = myDataWeather
                        }
                    }
                }
                 task.resume()
        }
    }
    
    //parse data and set up weather model
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let i = 0
            let currentTemp = decodedData.current.temp
            let currentWeatherID = decodedData.current.weather[i].id
            let description = decodedData.current.weather[i].description
            var hourlyArray: [HourlyModel] = []
            var dailyArray: [DailyModel] = []
            
            for int in 0...4 {
                let hourlyID = decodedData.hourly[int].weather[i].id
                let hourlyTemp = decodedData.hourly[int].temp
                
                let hourly = HourlyModel(conditionID: hourlyID, temp: hourlyTemp)
                
                    hourlyArray.append(hourly)
                
                let dailyID = decodedData.daily[int].weather[i].id
                let dailyTemp = decodedData.daily[int].temp.day
                
                let daily = DailyModel(conditionID: dailyID, temp: dailyTemp)
                
                dailyArray.append(daily)
            }

            let weather = WeatherModel(conditionID: currentWeatherID, currentTemp: currentTemp, hourlyArray: hourlyArray, dailyArray: dailyArray, description: description)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


    



