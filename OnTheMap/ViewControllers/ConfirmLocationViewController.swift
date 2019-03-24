//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 16/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import MapKit


class ConfirmLocationViewController: UIViewController {

    @IBOutlet weak var Mapview: MKMapView!
    var annotations : MKPointAnnotation?
    var Studentlocation: StudentLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ShowMap()
    }
    
    func ShowMap()  {
        let latitude = CLLocationDegrees((Studentlocation?.latitude!)!)
        let longitude = CLLocationDegrees((Studentlocation?.longitude!)!)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.annotations = MKPointAnnotation()
        self.annotations?.coordinate = coordinate
        self.annotations?.title = Studentlocation?.mapString
        self.Mapview.addAnnotation(self.annotations!)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.Mapview.setRegion(region, animated: true)
    }

 
    @IBAction func Submit(_ sender: Any) {
        Studentlocation?.firstName = API.shared.FirstName
        Studentlocation?.lastName = API.shared.LastName
        Studentlocation?.uniqueKey = API.shared.key
        API.shared.postLocation(location: Studentlocation!, completion: { (status) in
            guard status else {
                DispatchQueue.main.async {
                    AppAlert.errorAlert(mess: "error", view: self)
                }
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
}
