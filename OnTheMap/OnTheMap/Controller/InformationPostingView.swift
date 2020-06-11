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
    
    @IBOutlet weak var studentLocation: TextField!
    @IBOutlet weak var studentURL: TextField!
    
    var studentPin: StudentPin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let addLocationVC = segue.destination as! AddLocationViewController
            addLocationVC.studentPin = self.studentPin
            
        }
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        //Geocode the mapString
        print("studentLocation text\(self.studentLocation.text!)")
        self.getCoordinate(addressString: self.studentLocation.text ?? "", completionHandler: { coordinate2D, error  in
            if error == nil {
                print("coordinate is \(coordinate2D)")
                self.studentPin = StudentPin(coordinate: coordinate2D, mapString: self.studentLocation.text ?? "", mediaURL:  self.studentURL.text ?? "" )
                
                self.performSegue(withIdentifier: "addLocation", sender: nil)
            }
        })
        
    }
    
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
