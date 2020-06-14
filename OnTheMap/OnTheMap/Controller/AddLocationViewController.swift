//
//  AddLocation.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-09.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentPin: StudentPin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set mapView's delegate
        self.mapView.delegate = self
        self.setUpPins()
        
        
    }
    
    deinit {

        self.mapView.annotations.forEach{mapView.removeAnnotation($0)}

        self.mapView.delegate = nil
        
        print("deinit: AddLocationViewController")
    }
    
    
    @IBAction func finishTapped(_ sender: Any) {
        //post online here!
        if StudentLocation.Auth.objectId != nil {
            print("updating via objectId")
            StudentLocation.updateStudentLocation(body: createStudentLocation(objectId: StudentLocation.Auth.objectId!), completion: handlePostStudentLocationResponse(success:error:))
            
        } else {
            print("posting new student location")
            StudentLocation.postStudentLocation(body: createStudentLocation(), completion: handlePostStudentLocationResponse(success:error:))
            
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handlePostStudentLocationResponse(success: Bool, error: Error?) {
        if success {
            //handle success...
            print("success in HandlePostStudentLocationResponse")
            StudentLocation.getStudentLocation(limit: 1, order: StudentLocation.EndPoints.order, uniqueKey: StudentLocation.Auth.accountKey) { students, error in
                print("This is the last updated/created from student \(students)")
                StudentLocationModel.studentLocations.append(students[0])
            }
            
        } else {
            print("error in HandlePostStudentLocationResponse")
            //handle error
        }
    }
    
    private func createStudentLocation(objectId: String? = nil) -> StudentInformation {
        
        return StudentInformation(objectId: objectId ?? "", uniqueKey: StudentLocation.Auth.accountKey, firstName: StudentLocation.PublicUserInfo.firstName, lastName: StudentLocation.PublicUserInfo.lastName, mapString: studentPin.mapString, mediaURL: studentPin.mediaURL, latitude: studentPin.coordinate.latitude, longitude: studentPin.coordinate.longitude, createdAt: "", updatedAt: "")
        
    }
    
    
    private func setUpPins() {
            
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
            
            // The "locations" array is loaded with the sample data below. We are using the dictionaries
            // to create map annotations. This would be more stylish if the dictionaries were being
            // used to create custom structs. Perhaps StudentLocation structs.
            
            //for dictionary in StudentLocationModel.studentLocations {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
        let lat = CLLocationDegrees( self.studentPin.coordinate.latitude )
        let long = CLLocationDegrees( self.studentPin.coordinate.longitude )
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        print("coordinate: \(String(describing: coordinate))")
                
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
                
        print("annotation: \(String(describing: annotation.title))")
            
            // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        //}
    }
        //func Handle
}

// MARK: - MKMapViewDelegate

extension AddLocationViewController: MKMapViewDelegate {

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
                if mediaURL.contains("https") {
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
