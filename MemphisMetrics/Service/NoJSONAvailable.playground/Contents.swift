import UIKit
import PlaygroundSupport

extension String {
  var lines: [String] {
    var result: [String] = []
    enumerateLines { line, _ in result.append(line) }
    return result
  } // END: VAR RESULT
} // END: EXTENSION

// < - - - Constants & Variables - - - >
let stations: Int = 0
let floods: Int = 1
let riverURL: String = "http://forecast.weather.gov/product.php?site=NWS&issuedby=ORN&product=RVA&format=TXT&version=1&glossary=0"
let stationArray: Array = ["CAPE GIRARDEAU", "NEW MADRID", "TIPTONVILLE", "CARUTHERSVILLE", "OSCEOLA", "MEMPHIS", "TUNICA", "HELENA", "ARKANSAS CITY", "GREENVILLE", "VICKSBURG", "NATCHEZ", "RED RIVER LNDG", "BATON ROUGE", "DONALDSONVILLE", "RESERVE", "NEW ORLEANS"]
let floodArray: Array = ["32 ft.", "34 ft.", "37 ft.", "32 ft.", "28 ft.", "34 ft.", "41 ft.", "44 ft.", "37 ft.", "48 ft.", "43 ft.", "48 ft.", "48 ft.", "35 ft.", "27 ft.", "22 ft.", "17 ft."]
var riverGauges: Array = [[String]]()
var stationName: String = "RED RIVER LNDG" // < - - Manually inject STATION NAME here - - >
var line: String = "placeholder"
var obsDateTime: String = "placeholder"
var today: Int = 2
var tomorrow: Int = 4
var oneDayAfters: Int = 5
var twoDaysAfters: Int = 6
// < - - - FUNCTION - - - >
func grabRiverGaugeRawData(stationName: String) {
if let url: URL = URL(string: riverURL) {
  do {
    let content: String = try String(contentsOf: url)
    let rivDat: String = String(content)
    // regex to grab the time the river gauge was observed i.e. 0929AM or 1929PM or 2329PM
    let regex: NSRegularExpression = try NSRegularExpression(pattern: "(?:((0|1|2)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(A|P)M).*)")
    for match in regex.matches(in: rivDat, range: NSRange(0..<rivDat.utf16.count)) {
      // <- - - - - find and display the observation report time from webpage - - - - ->
      let lineRange: NSRange = match.range(at: 1)
      let line = lineRange.location != NSNotFound ? (rivDat as NSString).substring(with: lineRange): nil
      let funkyPattern: String = line!
      var lines: [String] = []
      // MARK: CLOSURE RIV DAT
      rivDat.enumerateLines { line, _ in

        // if the time pattern == funkyPattern (space(s)) is detected then grab the time of observation
        if line.hasPrefix(funkyPattern) {
          obsDateTime = "\(line)"
        } // END: if...
        // <- - - - - find the line with the data for the selected name of a river gauge city - - - - ->
        if line.contains("\(stationName)") {
          lines.append(line)
          // massage the data to account for city names with a space or spaces
          let stationCity: String = lines[stations]
          let currentRiverGauge: Array = stationCity.split(separator: " ", maxSplits: 16, omittingEmptySubsequences: true)
          let gauge: ArraySlice = currentRiverGauge[...]
          switch gauge[stations] {    // city name has 2 spaces
            case "RED":                 // Red River Lndg
              today = 4
              tomorrow = 6
              oneDayAfters = 7
              twoDaysAfters = 8
            case "NEW",             // city names have 1 space
            "CAPE",            // New Orleans, New Madrid, Cape G, Ark City, Baton R.
            "ARKANSAS",
            "BATON":
              today = 3
              tomorrow = 5
              oneDayAfters = 6
              twoDaysAfters = 7
            default:                // city names having no spaces
              today = 2      // Memphis, Tiptonville, Reserve, Oceola...
              tomorrow = 4
              oneDayAfters = 5
              twoDaysAfters = 6
          } // END: switch...
          // < - grab entire line for the station city name - - >
          print(" \(obsDateTime)")
          print(" \(line)")
          print(" Today: \(gauge[today])ft")
          print(" Tommorrow: \(gauge[tomorrow])ft")
          print(" 1 Day After Tomorrow: \(gauge[oneDayAfters])ft")
          print(" 2 Days After Tomorrow: \(gauge[twoDaysAfters])ft\n")
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
} // END: FUNC
// < - - - Here the end of a class would be in full app - - - >
grabRiverGaugeRawData(stationName: "MEMPHIS")
grabRiverGaugeRawData(stationName: "ARKANSAS CITY")
grabRiverGaugeRawData(stationName: "RED RIVER LNDG")

PlaygroundPage.current.needsIndefiniteExecution = true

// < - - - THIS DATA IS FROM WEBPAGE AT:  1105AM CDT SAT AUG 01 2020 - - - >
// TODO: Determine IF { the level is increasing(⬆️) or decreasing(⬇️) } 
/*
 CAPE GIRARDEAU 32  23.4  +2.0 25.1 26.4 26.9 26.5 25.4
 NEW MADRID     34  13.3  +0.8 15.0 16.2 17.3 18.2 18.4
 TIPTONVILLE    37  17.4  +0.6 18.9 19.8 20.7 21.4 21.7
 CARUTHERSVILLE 32  15.3  +0.3 16.6 17.6 18.4 19.1 19.4
 OSCEOLA        28   5.5  +0.1  6.5  7.8  9.1 10.3 11.2
 MEMPHIS        34   6.9  -0.3  7.2  8.2  9.4 10.6 11.5
 TUNICA         41  16.1  -0.6 15.9 16.5 17.5 18.6 19.7
 HELENA         44  13.3  -0.7 13.0 13.2 14.1 15.2 16.0
 ARKANSAS CITY  37  14.7  -0.3 14.1 13.9 14.0 14.5 15.2
 GREENVILLE     48  24.5  +0.1 24.0 23.6 23.5 23.8 24.4
 VICKSBURG      43  20.8  +0.2 20.7 20.5 20.2 20.0 20.1
 NATCHEZ        48  29.8   0.0 29.8 29.7 29.6 29.4 29.2
 RED RIVER LNDG 48  31.9  -0.1 31.9 31.9 31.9 31.8 31.7
 BATON ROUGE    35  15.3   0.0 15.4 15.4 15.4 15.4 15.2
 DONALDSONVILLE 27   8.3   0.0  8.4  8.4  8.5  8.4  8.5
 RESERVE        22   6.3  -0.1  6.3  6.4  6.3  6.2  6.2
 NEW ORLEANS   /17/  4.7  -0.1  4.5  4.6  4.5  4.3  4.4
 */
