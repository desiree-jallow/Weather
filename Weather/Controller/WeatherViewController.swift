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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var weatherSegment: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    let dateFormatter = DateFormatter()
    
    var isShowingHourly = true
    
    var myWeather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInitialView()
    }
    
    //toggle hourly and daily views
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        myCollectionView.reloadData()
        isShowingHourly.toggle()
    }
}

extension WeatherViewController {
    //sets up initial views
    func setUpInitialView() {
        WeatherManager.instance.delegate = self
        locationManager.delegate = self
        myCollectionView.dataSource = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        activityIndicator.startAnimating()
    }
    
    //shows view when API call is complete
    func showView() {
        dateLabel.isHidden = false
        myCollectionView.isHidden = false
        cityLabel.isHidden = false
        conditionLabel.isHidden = false
        temperatureLabel.isHidden = false
        weatherSegment.isHidden = false
        conditionImage.isHidden = false
        activityIndicator.stopAnimating()
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    //set size of collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ((collectionView.frame.width) / 10)
        return CGSize(width: width, height: 200)
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
            myWeather = weather
        OperationQueue.main.addOperation { [self] in
            myCollectionView.reloadData()
            showView()
        }
            
            
            //weather condition current
            dateFormatter.dateStyle = .long
            dateLabel.text = self.dateFormatter.string(from: Date())
            temperatureLabel.text = weather.currentTempString
            conditionImage.image = UIImage(named: weather.conditionName)
            conditionLabel.text = weather.description.capitalized
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
    }
    
    //show view based on what isShowHourly variable is set to
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        
        if isShowingHourly {
                cell.updateHourlyViews(index: indexPath.row)
        } else {
                cell.updateDailyViews(index: indexPath.row)
        }
        return cell
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


