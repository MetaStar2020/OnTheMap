//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set MapView's delegate
        self.mapView.delegate = self
        
        // Do any additional setup after loading the view.
        print("we're in MapViewController")
        
        //Retrieving Student Locations from Udacity's RESTful service
        StudentLocation.getStudentLocation(order: StudentLocation.EndPoints.order, completion: handleStudentLocations(students:error:))
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
       }
    
    //MARK: - IBActions
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        //refresh mapView
        self.refresh()
    }
    
    private func refresh() {
        self.mapView.removeAnnotations(mapView.annotations)
        self.setUpPins()
    }
    
    //MARK: - Internal Class Functions
    
    func handleStudentLocations(students: [StudentInformation], error: Error? ) {
        if error != nil {
            AlertVC.showMessage(title: "Couldn't Retrieve Student Locations", msg: error?.localizedDescription ?? "", on: self)
        } else {
            StudentLocationModel.studentLocations = students
            self.setUpPins() //since the download is async - set up needs to be here
        }
        
    }
    
    private func setUpPins() {
        
        var annotations = [MKPointAnnotation]()
        
        for dictionary in StudentLocationModel.studentLocations {
            
            let lat = CLLocationDegrees(dictionary.latitude ?? 0.0 )
            let long = CLLocationDegrees(dictionary.longitude ?? 0.0 )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Creating the annotation and setting its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Adding the annotation in an array of annotations.
            annotations.append(annotation)
            
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
}

  // MARK: - MKMapViewDelegate Funtions (required)

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = view.annotation?.subtitle! {
                if mediaURL.contains("https"){
                    if let mediaURL = URL(string: mediaURL){
                        UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
                    }
                } else {
                    AlertVC.showMessage(title: "Incorrect URL Format", msg: "Media contains a wrong URL format", on: self)
                }
            }
        }
    }
}

