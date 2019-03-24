//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 13/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    @IBOutlet var Tableview: UITableView!

    var studentLocation = AppDelegate.StudentLocatiosData as! [StudentLocation]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      UpdateLocation()
    }
    func UpdateLocation(){
        studentLocation.removeAll()
        self.tableView.reloadData()
        API.shared.getLocations { (locations) in
            
            // make sure locations contains a value
            guard locations != nil else {
                return
            }
            self.studentLocation = locations!
            
            DispatchQueue.main.async {
                self.Tableview.reloadData()
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocation.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        if let firstname = studentLocation[indexPath.row].firstName {
            cell.name.text = firstname
        }
        if let url = studentLocation[indexPath.row].mediaURL {
            cell.url.text = url
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StudentUrl = studentLocation[indexPath.row].mediaURL
                
        guard ValidUrl(urlString: StudentUrl) else {
            return
        }
        let newURL = URL(string: StudentUrl!)
        let Safari = SFSafariViewController(url: newURL!)
        present(Safari, animated: true, completion: nil)
    }
    
 
    func ValidUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
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
