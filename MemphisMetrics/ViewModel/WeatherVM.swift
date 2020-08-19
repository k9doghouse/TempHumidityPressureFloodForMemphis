//
//  WeatherVM.swift
//  MemphisMetrics 
//
//  Created by murph on 7/22/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import Foundation

class WeatherVM: ObservableObject {

  private var weatherService: WeatherService!

  @Published var weather = Weather()

  init() {
    self.weatherService = WeatherService()
  }

  var temperature: String {
    if let temp = self.weather.temp {
      return String(format: "%.0f", temp)
    } else {
      return ""
    }
  }

  var pressure: String {
    if let pressure = self.weather.pressure {
      return String(format: "%.0f", pressure)
    } else {
      return ""
    }
  }

  var humidity: String {
    if let humidity = self.weather.humidity {
      return String(format: "%.0f", humidity)
    } else {
      return ""
    }
  }

  var cityName: String = "MEMPHIS"

  func search() {
    if let city = self.cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
      fetchWeather(by: city)
    }
  }

  private func fetchWeather(by city: String) {

    self.weatherService.getWeather(city: city) { weather in
      if let weather = weather {
        DispatchQueue.main.async {
          self.weather = weather
        }
      }
    }
  }

} // END: CLASS
