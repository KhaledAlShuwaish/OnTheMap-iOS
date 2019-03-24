//
//  ActivityIndicatory.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 15/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

struct ActivityIndicatory {
static var   actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
   static func showActivityIndicatory(uiView: UIView) {
        actInd.frame = uiView.frame
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style = .white
        actInd.backgroundColor = UIColor(white: 0, alpha: 0.5)
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
     static func stopActivityIndicatory(uiView: UIView) {
        actInd.stopAnimating()
    }
}
