//
//  ContentView.swift
//  MemphisMetrics
//  https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=memt1&output=tabular&time_zone=cdt
//  Created by murph on 7/22/20.
//  Copyright © 2020 k9doghouse. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  @ObservedObject var weatherVM: WeatherVM

  var riverService = RiverService()
  var feet: String
  var obsDateTime: String

  init() {
    self.feet = riverService.getRiver(city: "MEMPHIS")
    self.obsDateTime = riverService.obsDateTime
    self.weatherVM = WeatherVM()
    self.weatherVM.search()
  }

  var body: some View {
    VStack(alignment: .center) {
      Text("Memphis")
        .font(.custom("Aviner Next", size: 42))
        .minimumScaleFactor(0.7)
        .padding()
      Text("\(self.weatherVM.temperature)℉")
        .font(.custom("Aviner Next", size: 72))
        .foregroundColor(Color("ButterColor"))
        .offset(y: -33)
        .padding()
      Text("\(self.weatherVM.pressure)mb")
        .font(.custom("Aviner Next", size: 72))
        .foregroundColor(Color("ButterColor"))
        .offset(y: -66)
        .padding()
      Text("\(self.weatherVM.humidity)%")
        .font(.custom("Aviner Next", size: 72))
        .foregroundColor(Color("ButterColor"))
        .offset(y: -99)
        .padding()

      ZStack {
        Divider()
        VStack {
        Text("\(obsDateTime)")
          .font(.custom("Aviner Next", size: 16))
          .foregroundColor(Color("ButterColor"))
          .minimumScaleFactor(0.7)
        Text("Flood Stage is 34ft")
          .font(.custom("Aviner Next", size: 14))
          .foregroundColor(Color("ButterColor"))
          .minimumScaleFactor(0.7)
        }
      }
      .foregroundColor(Color("ButterColor"))
      .offset(y: -132)
      .padding(.horizontal, 40)

      Text("\(feet)ft")
        .font(.custom("Aviner Next", size: 72))
        .foregroundColor(Color("ButterColor"))
        .offset(y: -165)
        .padding()
      }.shadow(color: Color("DarkShadow"), radius: 5, x: 0, y: 0)
    .frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity)
      .background(Color("DimGreenColor"))
      .edgesIgnoringSafeArea(.all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
