//
//  WeatherService.swift
//  MemphisMetrics 
//
//  Created by murph on 7/22/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import Foundation

class WeatherService {

  func getWeather(city: String, completion: @escaping(Weather?) -> ()) {

    // MARK: Please Get An API Key For Yourself. Mine is below. Insert yours please.
    guard let urlWeather = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Memphis&appid=f669527cea6d684c6a62a91ba5e8513e&units=imperial") else {
      completion(nil)
      return
    }

    URLSession.shared.dataTask(with: urlWeather) { data, response, error in
      guard let data = data, error == nil else {
        completion(nil)
        return
      }

      let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
      if let weatherResponse = weatherResponse {
        let weather = weatherResponse.main
        completion(weather)
      } else {
        completion(nil)
      }
    }.resume()

  }
}
