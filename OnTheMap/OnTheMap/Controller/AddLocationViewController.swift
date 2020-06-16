//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-09.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Class Properties
    
    var studentPin: StudentPin!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set mapView's delegate
        self.mapView.delegate = self
        
        //Set CLLocation
        let clLocation = CLLocation(latitude: studentPin.coordinate.latitude, longitude: studentPin.coordinate.longitude)
        centerMapOnLocation(clLocation , mapView: self.mapView)
        
        //Set Pins
        self.setUpPins()
        
        
    }
    
    deinit {

        self.mapView.annotations.forEach{mapView.removeAnnotation($0)}

        self.mapView.delegate = nil
        
        print("deinit: AddLocationViewController")
    }
    
    //MARK: - IBActions
    
    @IBAction func finishTapped(_ sender: Any) {
        //post online here!
        if StudentLocation.Auth.objectId != nil {
            print("updating via objectId")
            //Student already posted in this session, therefore student location will be updated instead of posted.
            StudentLocation.updateStudentLocation(body: createStudentLocation(objectId: StudentLocation.Auth.objectId!), completion: handlePostStudentLocationResponse(success:error:))
            
        } else {
            print("posting new student location")
            StudentLocation.postStudentLocation(body: createStudentLocation(), completion: handlePostStudentLocationResponse(success:error:))
            
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Internal Class Functions
    
    func handlePostStudentLocationResponse(success: Bool, error: Error?) {
        if success {
            print("success in HandlePostStudentLocationResponse")
            StudentLocation.getStudentLocation(limit: 1, order: StudentLocation.EndPoints.order, uniqueKey: StudentLocation.Auth.accountKey) { students, error in
                print("This is the last updated/created from student \(students)")
                StudentLocationModel.studentLocations.append(students[0])
            }
            
        } else { // handle error...
            print("error in HandlePostStudentLocationResponse")
            AlertVC.showMessage(title: "Couldn't Post Your Location", msg: error?.localizedDescription ?? "", on: self)
            
        }
    }
    
    //Zoom in to display student's choosen location prior to finishing
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    //create a StudentInformation struct to pass on
    func createStudentLocation(objectId: String? = nil) -> StudentInformation {
        
        return StudentInformation(objectId: objectId ?? "", uniqueKey: StudentLocation.Auth.accountKey, firstName: StudentLocation.PublicUserInfo.firstName, lastName: StudentLocation.PublicUserInfo.lastName, mapString: studentPin.mapString, mediaURL: studentPin.mediaURL, latitude: studentPin.coordinate.latitude, longitude: studentPin.coordinate.longitude, createdAt: "", updatedAt: "")
        
    }
    
    
    private func setUpPins() {
            
        var annotations = [MKPointAnnotation]()
            
        let lat = CLLocationDegrees( self.studentPin.coordinate.latitude )
        let long = CLLocationDegrees( self.studentPin.coordinate.longitude )
                
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
        let first = StudentLocation.PublicUserInfo.firstName
        let last = StudentLocation.PublicUserInfo.lastName
        let mediaURL = self.studentPin.mediaURL
                
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
                
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
            
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
}

// MARK: - MKMapViewDelegate Functions (required)

extension AddLocationViewController: MKMapViewDelegate {

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
                if mediaURL.contains("https") {
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
