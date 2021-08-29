//  ViewController.swift
//  Map
//  Created by Евгений Фирман on 27.08.2021.


import UIKit
import MapKit
import SnapKit
import CoreLocation
import SystemConfiguration

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
        
        if isInternetAvailable() {
            
            print("Интернет соединение доступно")
            
            return
            
        } else {
            
            let alert = UIAlertController(title: "Нет интернет соединения", message: "Отсутствует интернет соединение, подключите интернет и попробуйте снова.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            return
        }
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
            
            let alert = UIAlertController(title: "Сервис геолокации недоступен", message: "Подключите сервис геолокации и попробуйте снова", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            return
            
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
            
            let alert = UIAlertController(title: "Запрещено использовать геолокацию", message: "Приложение не сможет корректно функционировать", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            
            break
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            
            let alert = UIAlertController(title: "Запрещено использовать геолокацию", message: "Приложение не сможет корректно функционировать", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            break
        case .authorizedAlways:
            
            map.showsUserLocation = true
            
            centerViewOnUsersLocation()
            
            locationManager.startUpdatingLocation()
            
            break
        @unknown default:
            
            let alert = UIAlertController(title: "Фатальная ошибка приложения", message: "Обратитесь в поддержку", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            break
        }
    }
    
    
// MARK: - Check if internet available Function
    
    func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            
            return false
            
        }
        let isReachable = flags.contains(.reachable)
        
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
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
        
        let alert = UIAlertController(title: "Менеджер локации недоступен", message: "Обратитесь в поддержку приложения", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        return
        
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

