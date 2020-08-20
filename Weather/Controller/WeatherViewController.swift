//
//  ViewController.swift
//  Weather
//
//  Created by Desiree on 8/13/20.
//  Copyright © 2020 Desiree. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    
    @IBOutlet weak var conditionImageOne: UIImageView!
    @IBOutlet weak var conditionImageTwo: UIImageView!
    @IBOutlet weak var conditionImageThree: UIImageView!
    @IBOutlet weak var conditionImageFour: UIImageView!
    @IBOutlet weak var conditionImageFive: UIImageView!
    
    @IBOutlet weak var tempOne: UILabel!
    @IBOutlet weak var tempTwo: UILabel!
    @IBOutlet weak var tempThree: UILabel!
    @IBOutlet weak var tempFour: UILabel!
    @IBOutlet weak var tempFive: UILabel!
    
    @IBOutlet weak var weatherSegment: UISegmentedControl!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHourlyView()
        
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date())
        
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    func getdayOfTheWeek(datesAway: Int) -> Int {
        var component = DateComponents()
        component.day = datesAway
        
        var day = 0
        let nextDate =  Calendar.current.date(byAdding: component, to: Date())
        day = Calendar.current.component(.weekday, from: nextDate ?? Date())
        return day - 1
    }
    
    func getHours(hoursAway: Int) -> String {
        
        let later = Calendar.current.date(byAdding: .hour, value: hoursAway, to: Date()) ?? Date()
        
        var minComponent = Calendar.current.dateComponents([.minute], from: later)
        minComponent.minute = 0
        
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "h:00"

        return dateFormatter.string(from: later)
    }
    
    func updateHourlyView() {
        let firstHour = getHours(hoursAway: 1)
        let secondHour = getHours(hoursAway: 2)
        let thirdHour = getHours(hoursAway: 3)
        let fourthHour = getHours(hoursAway: 4)
        let fifthHour = getHours(hoursAway: 5)
                 
        self.labelOne.text = firstHour
        self.labelTwo.text = secondHour
        self.labelThree.text = thirdHour
        self.labelFour.text = fourthHour
        self.labelFive.text = fifthHour
    }
    
    func updateDailyView() {
        let firstDay = getdayOfTheWeek(datesAway: 1)
        let secondDay = getdayOfTheWeek(datesAway: 2)
        let thirdDay = getdayOfTheWeek(datesAway: 3)
        let fourthDay = getdayOfTheWeek(datesAway: 4)
        let fifthDay = getdayOfTheWeek(datesAway: 5)
                 
        self.labelOne.text =
            self.dateFormatter.shortWeekdaySymbols[firstDay]
        self.labelTwo.text = self.dateFormatter.shortWeekdaySymbols[secondDay]
        self.labelThree.text = self.dateFormatter.shortWeekdaySymbols[thirdDay]
        self.labelFour.text = self.dateFormatter.shortWeekdaySymbols[fourthDay]
        self.labelFive.text = self.dateFormatter.shortWeekdaySymbols[fifthDay]
    }
    
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            updateHourlyView()
            
        default:
            updateDailyView()
        }
        
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            //weather condition current
            self.temperatureLabel.text = weather.currentTempString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            self.conditionLabel.text = weather.description
        
            //weather condition picture does not work with segment
        switch self.weatherSegment.selectedSegmentIndex {
            case 1:
                self.conditionImageOne.image = UIImage(systemName: weather.dailyArray[0].conditionName)
                self.conditionImageTwo.image = UIImage(systemName: weather.dailyArray[1].conditionName)
                self.conditionImageThree.image = UIImage(systemName: weather.dailyArray[2].conditionName)
                self.conditionImageFour.image = UIImage(systemName: weather.dailyArray[3].conditionName)
                self.conditionImageFive.image = UIImage(systemName: weather.dailyArray[4].conditionName)
            default:
                self.conditionImageOne.image = UIImage(systemName: weather.hourlyArray[0].conditionName)
                self.conditionImageTwo.image = UIImage(systemName: weather.hourlyArray[1].conditionName)
                self.conditionImageThree.image = UIImage(systemName: weather.hourlyArray[2].conditionName)
                self.conditionImageFour.image = UIImage(systemName: weather.hourlyArray[3].conditionName)
                self.conditionImageFive.image = UIImage(systemName: weather.hourlyArray[4].conditionName)
                }
            
            //weather condititon temp does not work with segment control
        switch self.weatherSegment.selectedSegmentIndex {
        case 1:
            self.tempOne.text = weather.hourlyArray[0].tempString
            self.tempTwo.text = weather.hourlyArray[1].tempString
            self.tempThree.text = weather.hourlyArray[2].tempString
            self.tempFour.text = weather.hourlyArray[3].tempString
            self.tempFive.text = weather.hourlyArray[4].tempString
        default:
            self.tempOne.text = weather.dailyArray[0].tempString
            self.tempTwo.text = weather.dailyArray[1].tempString
            self.tempThree.text = weather.dailyArray[2].tempString
            self.tempFour.text = weather.dailyArray[3].tempString
            self.tempFive.text = weather.dailyArray[4].tempString
        }
    }
    
}
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchCurrentWeather(latitude: lat, longitude: lon)
            
            func fetchCity(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in completion(placemarks?.first?.locality, error)
                }
            }
            
            guard let location: CLLocation = manager.location else { return }
            fetchCity(from: location) { city, error in
                guard let city = city, error == nil else { return }
                self.cityLabel.text = city
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}


