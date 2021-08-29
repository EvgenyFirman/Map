//
//  ViewController.swift
//  Map
//
//  Created by Евгений Фирман on 27.08.2021.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

class ViewController: UIViewController {
    
//MARK: - Pre Initialization
    private var map = MKMapView()
    var locationManager = CLLocationManager()
    let regionInMeters: Double = 2000
    var weatherName: String?
    var temperature: Double? 
    var weatherAPI = WeatherAPIBrain()
    var infoViewController = InfoViewController()
    
 
    
//MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        
        super.viewDidLoad()
        weatherAPI.delegate = self                          // Setting Up WeatherAPI Delegate
        initializeMap()                                     // Initializing Map
        checkLocationServices()                             // Calling CheckLocationServices
        
    }
    
    
// MARK: - ViewDidLayoutSubviews Function
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        map.frame = view.bounds
        
    }
    
    
    
// MARK: - Initialize map view
    private func initializeMap() {
        
        view.addSubview(map)
        
        infoViewController.addSpinner()
        
        addInfoViewController()
        
    }
    

// MARK: - Func to add InfoViewController
    
    func addInfoViewController() {
        
        addChild(infoViewController)
        
        view.addSubview(infoViewController.view)
        
        infoViewController.didMove(toParent: self)
            
            if let weatherName = self.weatherName , let temperature = self.temperature {
                
                    self.infoViewController.regionLabel.text = weatherName
                    
                    self.infoViewController.temperatureLabel.text = String(temperature)
                
            
        }
        
        
        infoViewController.view.snp.makeConstraints { maker in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(200)
            maker.bottom.equalToSuperview()
        }
    }
    

    
// MARK: - Setup Location Manager
    func setUpLocationManager() {
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    
// MARK: - Check location services
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {

            setUpLocationManager()
            
            checkLocationManagerAutorization()
            
        } else {
            

        }
        
    }
    
// MARK: - Allign View on Users Location
    
    func centerViewOnUsersLocation() {
        if let location = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            weatherAPI.fetchWeather(latitude: location.latitude, longitude: location.longitude)
            
            map.setRegion(region, animated: true)
        }
    }

// MARK: - Check Location Manager Autorization Function
    func checkLocationManagerAutorization() {
        
        switch locationManager.authorizationStatus {
        
        case .authorizedWhenInUse:
            
            map.showsUserLocation = true
            
            centerViewOnUsersLocation()
            
            locationManager.startUpdatingLocation()
            
            break
        case .denied:
         
            break
        case .notDetermined:
           
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            
            
            break
        case .authorizedAlways:
            
            break
        }
    }
}




// MARK: - Extension View Controller
extension ViewController: CLLocationManagerDelegate {
    
    // Tracking User Location Dynamically
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        map.setRegion(region, animated: true)
        
    }
    
    // Tracking location authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationManagerAutorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error")
        
    }
    
}


//MARK: - WeatherManagerDelegate Protocol
extension ViewController: WeatherManagerDelegate {

    
    // Update weather function
    func didUpdateWeather(weather: WeatherStruct?){
        
            
        // Async dispatchQueue Method
        DispatchQueue.main.async { [weak self] in
            
            if let weather = weather {

                self?.infoViewController.temperatureLabel.text = "\(String(format:"%.1f",weather.temp))˚"
                
                self?.infoViewController.regionLabel.text = weather.name
                
                self?.infoViewController.removeSpinner()
            }
        }
       
    }
    
    
    // Catch Error for testing function
    func didCatchError(error: Error) {
        print(error)
    }
}

