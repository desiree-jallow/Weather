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
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
        
    @IBOutlet weak var weatherSegment: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    let dateFormatter = DateFormatter()
    
    var isShowingHourly = true
    
    var myWeather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        WeatherManager.instance.delegate = self
        locationManager.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.reloadData()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        myCollectionView.reloadData()
        isShowingHourly.toggle()
        
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
    
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            self.myWeather = weather
           
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        
            //weather condition current
            self.dateFormatter.dateStyle = .long
            self.dateLabel.text = self.dateFormatter.string(from: Date())
            self.temperatureLabel.text = weather.currentTempString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            self.conditionLabel.text = weather.description
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    
}

extension WeatherViewController: UICollectionViewDataSource {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCollectionViewCell
        

        if isShowingHourly {
           
            cell?.updateHourlyViews(index: indexPath.row)
            
            
        } else {
            
            cell?.updateDailyViews(index: indexPath.row)
           
            
        }
        
        return cell ?? UICollectionViewCell()
       
    }
    
    
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            WeatherManager.instance.fetchCurrentWeather(latitude: lat, longitude: lon)
            
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


