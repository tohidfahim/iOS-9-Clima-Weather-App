//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tohid Fahim on 18/6/20.
//  Copyright © 2020 Tohid Fahim. All rights reserved.
//


import UIKit
import CoreLocation   ///allow us to use GPS functionality of iPHONE
import UserNotifications
import Alamofire
import SwiftyJSON
import SVProgressHUD



class WeatherViewController: UIViewController, CLLocationManagerDelegate , ChangeCityDelegate{
    
    let defaults = UserDefaults.standard
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "6b586857af7c58ef861d83489a7aa366"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()       ///object declare
    let weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:Set up the location manager here.
        locationManager.delegate = self               ///delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        /// after editing info.plist
        
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url :  String, parameters : [String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("JSON Response From Website")
            ///print(response)
            
            if response.result.isSuccess{
                print("SUCCESS! Got The Weather Data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issue"
            }
        }
        
    }
    

    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON){
        if let tempResult = json["main"]["temp"].double {
        ///temperatureLabel.text = String(tempResult)
        
            weatherDataModel.temparature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"]["id"].intValue
        
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        }
        else {
            cityLabel.text = "Weather Unavailable"
            temperatureLabel.text = "!"
        }
    }
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temparature)"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
        
        defaults.set(weatherDataModel.temparature, forKey: "Notification")
        ///print(defaults.integer(forKey: "Notification"))
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            ///locationManager.delegate = nil   /// for getting data one time only
            
            
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            
            let params : [String:String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]   ///for parsing data from website through ALAMOFIRE COCOAPODS
            
            getWeatherData(url : WEATHER_URL, parameters : params)
            
        }
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        print(city)
        let cityInfo : [String:String] = ["q": city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: cityInfo)
        
//        Alamofire.request(WEATHER_URL, method: .get, parameters: cityInfo).responseJSON { (response) in
//            print("By City Information")
//
//            if response.result.isSuccess {
//                print(response)
//                let cityJSON : JSON = JSON(response.result.value!)
//                self.updateWeatherData(json: cityJSON)
//            }
//            else {
//                self.cityLabel.text = "Wrong City Name"
//            }
//
//        }
        
    }
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
    
    
}


