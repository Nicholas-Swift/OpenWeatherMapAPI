//
//  ViewController.swift
//  OpenWeatherMapAPI
//
//  Created by Nicholas Swift on 9/28/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Variables
    
    var city = ""
    
    // Outlets
    
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var dayNumField: UITextField!
    @IBOutlet weak var forecastButton: UIButton!
    
    // Actions
    
    @IBAction func goAction(_ sender: AnyObject) {
        
        city = cityField.text ?? ""
        
        OpenWeatherMapAPI.requestTodaysWeather(city: (city)) { (weather) in
            
            if let weather = weather {
                print("COMPLETE")
                
                DispatchQueue.main.async {
                    self.navigationItem.title = "Weather - " + self.city
                    
                    self.descriptionLabel.text = "Description: " + weather.description
                    self.minLabel.text = "Min: " + String(weather.minTemperature)
                    self.maxLabel.text = "Max: " + String(weather.maxTemperature)
                }
                
                print("SET LABEL")
            }
            else {
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Invalid City", message: "The city you typed in does not exist.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            
            }
            
        }
    }
    
    @IBAction func forecastAction(_ sender: AnyObject) {
        // forecast action
        
        performSegue(withIdentifier: "toForecast", sender: self)
    }
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        OpenWeatherMapAPI.setAPIKey(key: "b5689ff6944f5c600737608a0be51f05")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toForecast" {
            let destination = segue.destination as! TableViewController
            destination.city = self.city
            destination.num = Int(dayNumField.text!) ?? 0
            destination.navigationItem.title = "Forecast - " + self.city
        }
    }


}

