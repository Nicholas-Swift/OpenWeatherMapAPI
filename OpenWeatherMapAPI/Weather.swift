//
//  Weather.swift
//  OpenWeatherMapAPI
//
//  Created by Nicholas Swift on 9/30/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation

enum TemperatureUnit: String {
    case kelvin// = "kelvin"
    case imperial// = "imperial"
    case metric// = "metric"
}

struct Weather {
    let date: NSDate?
    let description: String
    let minTemperature: Float
    let maxTemperature: Float
    let avgTemperature: Float
    let temperatureUnit: TemperatureUnit
}
