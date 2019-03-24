//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 13/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import MapKit
import SafariServices


class MapViewController: UIViewController , MKMapViewDelegate {

    @IBOutlet weak var MapView: MKMapView!
    var studentLocation = AppDelegate.StudentLocatiosData as! [StudentLocation]

    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
      UpdateLocation()
    }
    
    func UpdateLocation(){
        studentLocation.removeAll()
        annotations.removeAll()
        let currentAnnotations = self.MapView.annotations
        self.MapView.removeAnnotations(currentAnnotations)
        API.shared.getLocations { (locations) in
            guard locations != nil else {
                return
            }
            self.studentLocation = locations!
            for AllLocations in self.studentLocation where AllLocations.latitude != nil && AllLocations.longitude != nil {
         
                let lat = CLLocationDegrees(AllLocations.latitude!)
                let long = CLLocationDegrees(AllLocations.longitude!)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let mediaURL = AllLocations.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.subtitle = mediaURL
                if let firstName = AllLocations.firstName, let lastName = AllLocations.lastName {
                    annotation.title = "\(firstName) \(lastName)"
                }
                
                self.annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.MapView.addAnnotations(self.annotations)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! ,
                let url = URL(string: toOpen) , app.canOpenURL(url){
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }
            else {
                DispatchQueue.main.async {
                    AppAlert.errorAlert(mess: "Unvalid URL", view: self)
                }
            }
        }
    }

    
    @IBAction func Refresh(_ sender: Any) {
        AppAlert.ShowLoadingAlert(Viewc: self)
        UpdateLocation()
        AppAlert.StopLoadingAlert()
    }
    
    @IBAction func Logout(_ sender: Any) {
        API.shared.logout { (st) in
            guard st else{
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }        
    }
}
