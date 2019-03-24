//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 14/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserName.delegate = self
        Password.delegate = self
    }
    

    @IBAction func LoginButton(_ sender: Any) {
        
        if ((UserName.text?.isEmpty)!) || ((Password.text?.isEmpty)!) {
            AppAlert.errorAlert(mess: "Please enter Username and Password", view: self)
        } else {
            AppAlert.ShowLoadingAlert(Viewc: self)
            API.shared.login(username: UserName.text!, password: Password.text!) { (error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        AppAlert.StopLoadingAlert()
                        AppAlert.errorAlert(mess: "Please make sure your Username and password are correct", view: self)
                    }
                    return
                }
                DispatchQueue.main.async{
                    AppAlert.StopLoadingAlert()
                }
                API.shared.getUserInfo { (status) in
                }
                DispatchQueue.main.async {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(controller, animated: true, completion: nil)
                }
            }
            }
            }
    
    @IBAction func SignUp(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else { return }
        UIApplication.shared.openURL(url)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
