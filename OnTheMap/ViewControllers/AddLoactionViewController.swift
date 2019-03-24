//
//  AddLoactionViewController.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 16/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import CoreLocation


class AddLoactionViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var UrlName: UITextField!
    @IBOutlet weak var LocationName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        UrlName.delegate = self
        LocationName.delegate = self
    }
    

 

    @IBAction func FindLocationButton(_ sender: Any) {
        guard let locationName = LocationName.text , let url = UrlName.text  else {
            DispatchQueue.main.async {
                AppAlert.errorAlert(mess: "There is Error", view: self)
                return
            }
            return
        }
        ActivityIndicatory.showActivityIndicatory(uiView: self.view)
        var newStudentLocation = StudentLocation.init(createdAt: "", firstName: "", lastName: "", latitude: 0, longitude: 0, mapString: locationName, mediaURL: url, objectId: "", uniqueKey: "", updatedAt: "")
        CLGeocoder().geocodeAddressString(newStudentLocation.mapString!) { (clplaceMarks, error) in
            guard let placeMarks = clplaceMarks else {
                AppAlert.errorAlert(mess: "Error", view: self)
                return
                ActivityIndicatory.stopActivityIndicatory(uiView: self.view)
            }
            newStudentLocation.longitude = Double(((placeMarks.first!.location?.coordinate.longitude)!))
            newStudentLocation.latitude = Double(((placeMarks.first!.location?.coordinate.latitude)!))
            ActivityIndicatory.stopActivityIndicatory(uiView: self.view)
            self.performSegue(withIdentifier: "ConfirmLocationViewController", sender: newStudentLocation)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmLocationViewController" {
            let viewController = segue.destination as! ConfirmLocationViewController
            viewController.Studentlocation = (sender as! StudentLocation)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func CancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
