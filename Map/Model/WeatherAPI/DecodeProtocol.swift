//
//  DecodeProtocol.swift
//  Map
//
//  Created by Евгений Фирман on 28.08.2021.
//

import Foundation

struct WeatherData: Decodable {
    let list: [List]
}
struct List: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
}
struct Main: Decodable{
    let temp: Double
}
struct Weather: Decodable{
    let id: Int
}
