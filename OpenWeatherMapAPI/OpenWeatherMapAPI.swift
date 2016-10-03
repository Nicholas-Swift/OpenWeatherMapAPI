//
//  APIHelper.swift
//  OpenWeatherMapAPI
//
//  Created by Nicholas Swift on 9/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation

class OpenWeatherMapAPI {
    
    static var key:String = ""
    
    static func setAPIKey(key: String) {
        self.key = key
    }
    
    static func getAPIKey() -> String {
        return self.key
    }
    
    static func requestTodaysWeather(city: String, temperatureUnit: TemperatureUnit = .imperial, completionHandler: @escaping (Weather?) -> ()) {
        
        // Set up variables
        let baseUrl = "http://api.openweathermap.org"
        let path = "/data/2.5/weather"
        let queryString = "q=\(city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&units=\(temperatureUnit)&appid=\(key)"

        // Set up resource
        let requestResource = Resource(baseURL: baseUrl, path: path, queryString: queryString, method: Method.GET) { (response) -> Data? in
            //print(response)
            return(response)
        }
        
        // Make the request
        let requestClient = HTTPClient()
        requestClient.apiRequest(resource: requestResource, failure: { (response, data) in
            //print("REQUEST CLIENT FAILURE")
            print(response)
            
            }) { (response) in
                let decodedData = decodeJSON(data: response)
                let weather = parseToWeather(json: decodedData!, temperatureUnit: temperatureUnit)
                print(weather)
                completionHandler(weather)
        }
    }
    
    static func requestWeatherForecast(city: String, days: Int, temperatureUnit: TemperatureUnit = .imperial, completionHandler: @escaping ([Weather]) -> ()) {
        
        print("Requesting weather forecast")
        
        // Set up variables
        let baseUrl = "http://api.openweathermap.org"
        let path = "/data/2.5/forecast/daily"
        let queryString = "q=\(city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&units=\(temperatureUnit)&cnt=\(String(days))&appid=\(key)"
        
        
        // Set up resource
        let requestResource = Resource(baseURL: baseUrl, path: path, queryString: queryString, method: Method.GET) { (response) -> Data? in
            //print(response)
            return(response)
        }
        
        // Make the request
        let requestClient = HTTPClient()
        requestClient.apiRequest(resource: requestResource, failure: { (response, data) in
            //print("REQUEST CLIENT FAILURE")
            print(response)
            
        }) { (response) in
            let decodedData = decodeJSON(data: response)
            //print(decodedData)
            let weather = parseToForecast(json: decodedData!, temperatureUnit: temperatureUnit)
            print(weather)
            completionHandler(weather)
        }
    }
}

func parseToWeather(json: [String: AnyObject?], temperatureUnit: TemperatureUnit) -> Weather? {
    
    if let weath = json["weather"] as? [NSDictionary] {
    
    let description: String = (weath[0]["description"]! as? String)!
    let minTemperature: Float = (json["main"]!!["temp_min"] as? Float)!
    let maxTemperature: Float = (json["main"]!!["temp_max"] as? Float)!
    let avgTemperature = Float((minTemperature + maxTemperature) / 2)
    
        let weather = Weather(date: nil, description: description, minTemperature: minTemperature, maxTemperature: maxTemperature, avgTemperature: avgTemperature, temperatureUnit: temperatureUnit)
    return(weather)
    } else {
        // Invalid City
        return nil
    }
}

func parseToForecast(json: [String: AnyObject?], temperatureUnit: TemperatureUnit) -> [Weather] {
    
    var weatherList: [Weather] = []
    if let forecast = json["list"] as? [NSDictionary] {
        
        for i in forecast {
            print("\n")
            print(i)
            
            let myI = i as? [String: AnyObject]
            
            let myDescription = myI!["weather"] as? [[String: AnyObject]]
            print("\n\n\n")
            print(myDescription?[0]["description"] as? String)
            //let description: String = (myDescription!["description"] as? String)!
            let description: String = (myDescription?[0]["description"] as? String) ?? "no description"
            let minTemperature: Float = (myI!["temp"]!["min"] as? Float)!
            let maxTemperature: Float = (myI!["temp"]!["max"] as? Float)!
            let avgTemperature = Float((minTemperature + maxTemperature) / 2)
            let date: Int = ((myI!["dt"])! as? Int)!
            let realDate = NSDate(timeIntervalSince1970: TimeInterval(date))
            
            let weather = Weather(date: realDate, description: description, minTemperature: minTemperature, maxTemperature: maxTemperature, avgTemperature: avgTemperature, temperatureUnit: temperatureUnit)
            weatherList.append(weather)
        }
    }
    else {
        print("not a [[nsdict]]")
    }
    
    print(weatherList)
    return weatherList
}

func decodeJSON(data: Data) -> [String:AnyObject]? {
    
    do {
        let result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject]
        return result
    }
    catch {
        print("FAIL")
        return nil
    }
}
