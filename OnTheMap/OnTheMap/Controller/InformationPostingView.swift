//
//  InformationPostingView.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class InformationPostingView: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var studentLocation: TextField!
    @IBOutlet weak var studentURL: TextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    //MARK: - Class Properties
    
    var studentPin: StudentPin?
    var urlErrorMsg: String = ""
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let addLocationVC = segue.destination as! AddLocationViewController
            addLocationVC.studentPin = self.studentPin
            
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func findLocationTapped(_ sender: Any) {
        //Geocode the mapString
        self.setGeocodeIn(true)
        print("studentLocation text\(self.studentLocation.text!)")
        self.getCoordinate(addressString: self.studentLocation.text ?? "", completionHandler: { coordinate2D, error  in
            if error == nil {
                print("coordinate is \(coordinate2D)")
                
                //Check if the mediaURL is in correct format before performing Segue
                if self.isMediaURLFormat() {
                    self.studentPin = StudentPin(coordinate: coordinate2D, mapString: self.studentLocation.text ?? "", mediaURL:  self.studentURL.text ?? "" )
                    self.setGeocodeIn(false)
                    self.performSegue(withIdentifier: "addLocation", sender: nil)
                } else {
                    self.setGeocodeIn(false)
                    AlertVC.showMessage(title: "Incompatible URL Format", msg: self.urlErrorMsg, on: self)
                }
            } else {
                self.setGeocodeIn(false)
                AlertVC.showMessage(title: "Couldn't Find Location", msg: error?.localizedDescription ?? "", on: self)
            }
        })
        
    }
    
    //MARK: - Internal Class Functions
    
    func isMediaURLFormat() -> Bool {
        //handle - checking if url starts with 'https://'
        if let typedURL = self.studentURL.text, !typedURL.isEmpty {
        
            if typedURL.starts(with: "https://") {
            
                //returns true if the URL is working
                if verifyUrl(urlString: typedURL) { return true
                
                } else {
                    urlErrorMsg = "URL provided does not work."
                    return false
                }
            
            } else {
            
                urlErrorMsg = "URL must begin with 'https://'"
                return false
            
            }
            
        } else {
            urlErrorMsg = "Please Add a Link."
            return false
        }
    }
    
    //Verifying if the URL is openable
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    //Set activity indicator while geocoding
    func setGeocodeIn(_ geocodeIn: Bool) {
        if geocodeIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        findLocationButton.isEnabled = !geocodeIn 
    }
    
    //Translate string into coordinates for the mapView
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
}
