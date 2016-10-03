//
//  TableViewController.swift
//  OpenWeatherMapAPI
//
//  Created by Nicholas Swift on 9/30/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // Variables
    var city = ""
    var num = 0
    var forecast: [Weather] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // TableViewController
    
    override func viewDidLoad() {
        OpenWeatherMapAPI.requestWeatherForecast(city: self.city, days: self.num) { (forecast) in
            self.forecast = forecast
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherTableViewCell
        
        cell.dateLabel.text = forecast[indexPath.row].date?.description
        cell.descriptionLabel.text = "Description: " + forecast[indexPath.row].description
        cell.minLabel.text = "Min: " + String(forecast[indexPath.row].minTemperature)
        cell.maxLabel.text = "Max: " + String(forecast[indexPath.row].maxTemperature)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
}
