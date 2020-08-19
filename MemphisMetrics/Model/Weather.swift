//
//  Weather.swift
//  MemphisMetrics 
//
//  Created by murph on 7/22/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
  let main: Weather
}

struct Weather: Decodable {
  var temp: Double?
  var pressure: Double?
  var humidity: Double?
}
