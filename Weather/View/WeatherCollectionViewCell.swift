//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by Desiree on 8/25/20.
//  Copyright © 2020 Desiree. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    let dateFormatter = DateFormatter()
    //get hours for hours label
    func getHours() -> [String] {
        var hoursArray = [String]()
        
        for int in 1...5 {
        
        let later = Calendar.current.date(byAdding: .hour, value: int, to: Date()) ?? Date()
            
            dateFormatter.dateStyle = .none
            dateFormatter.dateFormat = "h a"
            
            hoursArray.append(dateFormatter.string(from: later))
        }
        
        return hoursArray
    }
    //get days of the week for label
    func getdayOfTheWeek() -> [Int] {
        var daysArray = [Int]()
        var day = 0
        
        for int in 1...5 {
            var component = DateComponents()
            component.day = int
            
            let nextDate =  Calendar.current.date(byAdding: component, to: Date())
            day = Calendar.current.component(.weekday, from: nextDate ?? Date())
            daysArray.append(day - 1)
        }
           
           return daysArray
       }
    //update views for houly
    func updateHourlyViews(index: Int) {
            if let weather = WeatherManager.instance.weather {
        
                titleLabel.text = getHours()[index]
                tempLabel.text = WeatherManager.instance.weather?.hourlyArray[index].tempString
                conditionImage.image = UIImage(named: weather.hourlyArray[index].conditionName)
        }
}
    
    //update views for daily
    func updateDailyViews(index: Int) {
        
            if let weather = WeatherManager.instance.weather {
                
                titleLabel.text = dateFormatter.shortWeekdaySymbols[getdayOfTheWeek()[index]]
                tempLabel.text = WeatherManager.instance.weather?.dailyArray[index].tempString
                conditionImage.image = UIImage(named: weather.dailyArray[index].conditionName)
          }
    }
}
