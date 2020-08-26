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
    
    
    func getHours() -> [String] {
        var hoursArray = [String]()
        for int in 1...5 {
        
        let later = Calendar.current.date(byAdding: .hour, value: int, to: Date()) ?? Date()
            
        var minComponent = Calendar.current.dateComponents([.minute], from: later)
        minComponent.minute = 0
            
            dateFormatter.dateStyle = .none
            dateFormatter.dateFormat = "h:00"
            
            hoursArray.append(dateFormatter.string(from: later))
            
        }
        return hoursArray
    }
    
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
    
    func updateHourlyViews(index: Int) {
    
            self.titleLabel.text = self.getHours()[index]
            self.tempLabel.text = WeatherManager.instance.weather?.hourlyArray[index].tempString
            self.conditionImage.image = UIImage(systemName: (WeatherManager.instance.weather?.hourlyArray[index].conditionName) ?? "")
    }
    
    
    func updateDailyViews(index: Int) {
          titleLabel.text = dateFormatter.shortWeekdaySymbols[getdayOfTheWeek()[index]]
        tempLabel.text = WeatherManager.instance.weather?.dailyArray[index].tempString
        conditionImage.image = UIImage(systemName: (WeatherManager.instance.weather?.dailyArray[index].conditionName) ?? "")
      }
}
