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
    func getdayOfTheWeek(currentDate: Date, datesAway: Int) -> Int {
        var component = DateComponents()
        component.day = datesAway
        
        var day = 0
        let nextDate =  Calendar.current.date(byAdding: component, to: currentDate)
        day = Calendar.current.component(.weekday, from: nextDate ?? Date())
        return day - 1
    }
    
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        if self.weatherSegment.selectedSegmentIndex == 1 {
            
        let firstDay = getdayOfTheWeek(currentDate: Date(), datesAway: 1)
        let secondDay = getdayOfTheWeek(currentDate: Date(), datesAway: 2)
        let thirdDay = getdayOfTheWeek(currentDate: Date(), datesAway: 3)
        let fourthDay = getdayOfTheWeek(currentDate: Date(), datesAway: 4)
        let fifthDay = getdayOfTheWeek(currentDate: Date(), datesAway: 5)
            
    self.labelOne.text = self.dateFormatter.shortWeekdaySymbols[firstDay]
    self.labelTwo.text = self.dateFormatter.shortWeekdaySymbols[secondDay]
    self.labelThree.text = self.dateFormatter.shortWeekdaySymbols[thirdDay]
    self.labelFour.text = self.dateFormatter.shortWeekdaySymbols[fourthDay]
    self.labelFive.text = self.dateFormatter.shortWeekdaySymbols[fifthDay]
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
