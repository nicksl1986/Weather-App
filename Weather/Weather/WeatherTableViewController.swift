//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by Nick Slobodsky on 24/09/2018.
//  Copyright © 2018 Nick Slobodsky. All rights reserved.
//

import UIKit
import CoreLocation // we import this for working with location. we can't use the city string or the location string, to get the information we need, which means we have to geo code the location needed.

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // in this array, we'll place the results from the completion handler from updateWeatherLocation function, and work with that throughout our table view and the table view date source functions :
    
    var forecastData = [Weather]()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        searchBar.delegate = self
        
        // as soon as the app launches, we want to display data for a demo/default location :
        
        updateWeatherLocation(location: "Rome")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // how to hide the keyboard when tapping a city/country name :
        
        searchBar.resignFirstResponder()
        
        if let locationString = searchBar.text, !locationString.isEmpty
        {
            updateWeatherLocation(location: locationString)
        }
    }
    
    func updateWeatherLocation(location : String)
    {
        // the CLGeocoder method, was made for geo coding the location needed :
        
        CLGeocoder().geocodeAddressString(location) { (placemarks : [CLPlacemark]?, error : Error?) in
            
            if error == nil
            {
                if let location = placemarks?.first?.location
                {
                    // as in our weather.swift file, we use the location parameter, to send info to the dark sky API :
                    
                    Weather.forecast(withLocation: location.coordinate, completion: { (results : [Weather]?) in
                        
                        if let weatherData = results
                        {
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // number of sections which will be displayed by date :
        
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return 1
    }
    
    // providing headers for the sections :
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // configuring the cell :
        
        let weatherObject = forecastData[indexPath.section]
        
        cell.textLabel?.text = weatherObject.summary
        
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature - 32) * 5/9) °C"
        
        cell.imageView?.image = UIImage(named: weatherObject.icon)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
