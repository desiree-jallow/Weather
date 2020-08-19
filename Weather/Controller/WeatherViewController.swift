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
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date())
        
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    func getDayOfTheWeek(date: Date) -> Int {
        var component = DateComponents()
        component.day = 1
        
        var day = 0
        let nextDate =  Calendar.current.date(byAdding: component, to: date)
        day = Calendar.current.component(.weekday, from: nextDate ?? Date())
        return day - 1
    }
    
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        if self.weatherSegment.selectedSegmentIndex == 1 {
                        
            var component = DateComponents()
                component.day = 1
        
            let firstDate = Calendar.current.date(byAdding: component, to: Date())
            let firstDay = Calendar.current.component(.weekday, from: firstDate ?? Date())
                    
            let secondDate = Calendar.current.date(byAdding: component, to: firstDate ?? Date())
            let secondDay = Calendar.current.component(.weekday, from: secondDate ?? Date())
                    
            let thirdDate = Calendar.current.date(byAdding: component, to: secondDate ?? Date())
            let thirdDay = Calendar.current.component(.weekday, from: thirdDate ?? Date())
                    
            let fourthDate = Calendar.current.date(byAdding: component, to: thirdDate ?? Date())
            let fourthDay = Calendar.current.component(.weekday, from: fourthDate ?? Date())
                    
            let fifthDate = Calendar.current.date(byAdding: component, to: fourthDate ?? Date())
            let fifthDay = Calendar.current.component(.weekday, from: fifthDate ?? Date())
                        
                        
    self.labelOne.text = self.dateFormatter.shortWeekdaySymbols[firstDay - 1]
    self.labelTwo.text = self.dateFormatter.shortWeekdaySymbols[secondDay - 1]
    self.labelThree.text = self.dateFormatter.shortWeekdaySymbols[thirdDay - 1]
    self.labelFour.text = self.dateFormatter.shortWeekdaySymbols[fourthDay - 1]
    self.labelFive.text = self.dateFormatter.shortWeekdaySymbols[fifthDay - 1]
        }
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.currentTempString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            
            self.conditionLabel.text = weather.description

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
            
        func fetchCity(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in completion(placemarks?.first?.locality, error)
                }
            }
            
            guard let location: CLLocation = manager.location else { return }
            fetchCity(from: location) { city, error in
                guard let city = city, error == nil else { return }
                self.cityLabel.text = city
                
            }
        weatherManager.fetchCurrentWeather(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
