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
    
    @IBOutlet weak var mapView: MKMapView!
    
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
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        //refresh mapView
        self.refresh()
    }
    
    private func refresh() {
        self.mapView.removeAnnotations(mapView.annotations)
        self.setUpPins()
    }
    
    func handleStudentLocations(students: [StudentInformation], error: Error? ) {
        if error != nil {
            AlertVC.showMessage(title: "Couldn't Retrieve Student Locations", msg: error?.localizedDescription ?? "", on: self)
        } else {
            StudentLocationModel.studentLocations = students
            self.setUpPins() //since the download is async - set up needs to be here
        }
        
    }
    
    private func setUpPins() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in StudentLocationModel.studentLocations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude ?? 0.0 )
            let long = CLLocationDegrees(dictionary.longitude ?? 0.0 )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            //print("coordinate: \(String(describing: coordinate))")
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            
            //print("annotation: \(String(describing: annotation.title))")
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    //func Handle

}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
                    //showAlert(ofType: .incorrectURLFormat, message: "Media contains a wrong URL format")
                }
            }
        }
    }
}

