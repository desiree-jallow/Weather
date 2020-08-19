//
//  WeatherManager.swift
//  Weather
//
//  Created by Desiree on 8/18/20.
//  Copyright © 2020 Desiree. All rights reserved.
//

import Foundation
//fetch data
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
   
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?appid=a25ec870afc55645547d55434fe207f1&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    
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
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            //start task
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let currentTemp = decodedData.current.temp
            let id = decodedData.current.weather[0].id
            let description = decodedData.current.weather[0].description
            
            let firstID = decodedData.hourly[0].weather[0].id
            let firstTemp = decodedData.hourly[0].temp
            
            let secondID = decodedData.hourly[1].weather[0].id
            let secondTemp = decodedData.hourly[1].temp
            
            let thirdID = decodedData.hourly[2].weather[0].id
            let thirdTemp = decodedData.hourly[2].temp
            
            let fourthID = decodedData.hourly[3].weather[0].id
            let fourthTemp = decodedData.hourly[3].temp
            
            let fifthID = decodedData.hourly[4].weather[0].id
            let fifthTemp = decodedData.hourly[4].temp
            
            let firstHourly = HourlyModel(conditionID: firstID, temp: firstTemp)
            let secondHourly = HourlyModel(conditionID: secondID, temp: secondTemp)
            let thirdHourly = HourlyModel(conditionID: thirdID, temp: thirdTemp)
            let fourthHourly = HourlyModel(conditionID: fourthID, temp: fourthTemp)
            let fifthHourly = HourlyModel(conditionID: fifthID, temp: fifthTemp)
            let hourlyArray: [HourlyModel] = [firstHourly, secondHourly, thirdHourly, fourthHourly, fifthHourly]
            
            let firstDayID = decodedData.hourly[0].weather[0].id
            let firstDayTemp = decodedData.hourly[0].temp
            
            let secondDayID = decodedData.hourly[1].weather[0].id
            let secondDayTemp = decodedData.hourly[1].temp
            
            let thirdDayID = decodedData.hourly[2].weather[0].id
            let thirdDayTemp = decodedData.hourly[2].temp
            
            let fourthDayID = decodedData.hourly[3].weather[0].id
            let fourthDayTemp = decodedData.hourly[4].temp
            
            let fifthDayID = decodedData.hourly[3].weather[0].id
            let fifthDayTemp = decodedData.hourly[3].temp
            
            let firstDay = DailyModel(conditionID: firstDayID, temp: firstDayTemp)
            let secondDay = DailyModel(conditionID: secondDayID, temp: secondDayTemp)
            let thirdDay = DailyModel(conditionID: thirdDayID, temp: thirdDayTemp)
            let fourthDay = DailyModel(conditionID: fourthDayID, temp: fourthDayTemp)
            let fifthDay = DailyModel(conditionID: fifthDayID, temp: fifthDayTemp)
            
            let dailyArray: [DailyModel] = [firstDay, secondDay, thirdDay, fourthDay, fifthDay]
            
            let weather = WeatherModel(conditionId: id, currentTemp: currentTemp, hourlyArray: hourlyArray, dailyArray: dailyArray, description: description)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    }


    



