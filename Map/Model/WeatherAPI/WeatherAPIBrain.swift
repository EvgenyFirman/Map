//  WeatherAPIController.swift
//  Map
//  Created by Евгений Фирман on 28.08.2021.


import UIKit
import CoreLocation


//MARK: - WeatherManagerDelegate Protocol

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherStruct)
    
    func didCatchError(error: Error)
    
}



// MARK: - WeatherAPIBrain Initialization

struct WeatherAPIBrain {
    
    var delegate: WeatherManagerDelegate?
    
    
//MARK: Main Function for Fetching Weather
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees ){
        
        let urlString = "https://api.openweathermap.org/data/2.5/find?appid=103c3e8047f010ddc6bb097044974a92&units=metric&lat=\(latitude)&lon=\(longitude)"
    
            weatherAPICall(urlString)
    }
    
    

// MARK: - Function for Weather API Call
    
    func weatherAPICall(_ url: String){
        
            // initializing url
            if let url = URL(string: url){
                
                // Initializing session
                let session = URLSession(configuration: .default)
                
                // Task session initialization
                let task = session.dataTask(with: url) {(data, urlResponse, error) in
                    
                        if error != nil {
                            
                            print(error!)
                            
                            return
                            
                        }
                    
                        if let safeData = data{
                            
                           var weather = self.decodeJSON(weatherData: safeData)
                            
                        }
                    }
                
                task.resume()
            }
        }
    

    
// MARK: - Function for Decoding JSON
    
    func decodeJSON(weatherData: Data) -> WeatherStruct?{
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weatherID = decodedData.list[0].weather[0].id
            
            let temp = decodedData.list[0].main.temp
            
            let name = decodedData.list[0].name
            
            print(weatherID,temp,name)
            
            let weather = WeatherStruct(weatherID: weatherID, name: name, temp: temp)
            
            return weather
            
        } catch {
            
            self.delegate?.didCatchError(error: error)
            
            return nil
        }
    }
}

