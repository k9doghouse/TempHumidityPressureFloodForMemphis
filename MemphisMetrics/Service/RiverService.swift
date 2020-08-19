//
//  RiverService.swift
//  MemphisMetrics 
//
//  Created by murph on 8/19/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import Foundation
import SwiftUI

extension String {
  var lines: [String] {
    var result: [String] = []
    enumerateLines { line, _ in result.append(line) }
    return result
  } // END: VAR RESULT
} // END: EXTENSION

// < - - - Constants & Variables - - - >
let stations: Int = 0
// MARK: NO API KEY REQUIRED
let riverURL: String = "http://forecast.weather.gov/product.php?site=NWS&issuedby=ORN&product=RVA&format=TXT&version=1&glossary=0"

var riverGauges: Array = [[String]]()
var stationName: String = "MEMPHIS"
var line: String = "placeholder"
var today: Int = 2

class RiverService {
  var feet: String = "0.0"
  var obsDateTime: String = "placeholder"

  func getRiver(city: String) -> String {
    if let url: URL = URL(string: riverURL) {
      do {
        let content: String = try String(contentsOf: url)
        let rivDat: String = String(content)
        // regex to grab the time the river gauge was observed i.e. 0929AM or 1929PM or 2329PM
        let regex: NSRegularExpression = try NSRegularExpression(pattern: "(?:((0|1|2)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(A|P)M).*)")
        for match in regex.matches(in: rivDat, range: NSRange(0..<rivDat.utf16.count)) {
          // <- - - - - find and display the observation time from webpage - - - - ->
          let lineRange: NSRange = match.range(at: 1)
          let line = lineRange.location != NSNotFound ? (rivDat as NSString).substring(with: lineRange): nil
          let funkyPattern: String = line!
          var lines: [String] = []
          // MARK: CLOSURE RIV DAT
          rivDat.enumerateLines { line, _ in
            // if the time pattern == funkyPattern (space(s)) is detected then grab the time of observation
            if line.hasPrefix(funkyPattern) {
              self.obsDateTime = "\(line)" // MARK: Date/Time of River level observation
            } // END: if...
            // <- - - - - find the line with the data for "MEMPHIS" - - - - ->
            if line.contains("\(stationName)") {
              lines.append(line)
              let stationCity: String = lines[stations]
              let currentRiverGauge: Array = stationCity.split(separator: " ", maxSplits: 16, omittingEmptySubsequences: true)
              let gauge: ArraySlice = currentRiverGauge[...]
              switch gauge[stations] {
                default:                // city names having no spaces
                  today = 2             // Memphis, Tiptonville, Reserve, Oceola...
              } // END: switch...
              self.feet = String(gauge[today])
            } // END: if line
          } // END: closure enumerateLines...
        } // END: for match...
      } // END: do...
      catch {
        print("contents could not be loaded.\n")
      } // END: catch...
    } // END: IF LET
    else {
      print("the URL was bad!\n")
    }  // END: ELSE
    return feet
  } // END: FUNC
} // END: CLASS
