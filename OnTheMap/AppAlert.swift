//
//  LoadingAlert.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 15/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

struct AppAlert {
    static let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    static func ShowLoadingAlert(Viewc : UIViewController){
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        Viewc.present(alert, animated: true)
            }
    
    static func StopLoadingAlert(){
        alert.dismiss(animated: true, completion: nil)

    }

    static func errorAlert(mess : String , view : UIViewController){
        let alert = UIAlertController(title: "Error", message: mess, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }

}
