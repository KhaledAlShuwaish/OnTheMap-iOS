//
//  API.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 13/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

class API {
    static let shared = API()
    private init() {}
    
    var key: String = ""
    var id: String = ""
    var FirstName = ""
    var LastName = ""
    var FullName = ""

    
    func login(username: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        let params = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let url = "https://onthemap-api.udacity.com/v1/session"
        request(url: url, method: "POST", parameters: params) { (status, data) in
            guard status else {
                completion("incorrect username or password")
                return
            }
            do {
                let newData = data?.subdata(in: 5..<data!.count)
                let data = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)  as? [String: Any]
                let sessionDict = data?["session"] as? [String: Any]
                let accountDict = data?["account"] as? [String: Any]
                self.key = accountDict?["key"] as? String ?? ""
                print(self.key)
                self.id = sessionDict?["id"] as? String ?? ""
                completion(nil)
            } catch {
                completion("couldn't serialize the object")
            }
        }
    }
    
    func logout(completion: @escaping (_ status: Bool) -> Void) {
        let url = "https://onthemap-api.udacity.com/v1/session"
        request(url: url, method: "DELETE") { (status, data) in
            guard status else {
                completion(false)
                return
            }
            completion(true)
        }
        
        
        
    }
    
    func getLocations(limit: Int = 100, skip: Int = 0, orderBy: String = "updatedAt", completion: @escaping ([StudentLocation]?) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(limit)&skip=\(skip)&order=-\(orderBy)"
        
        request(url: url, method: "GET") { (status, data) in
            guard status else {
                completion(nil)
                return
            }
            do {
                let location = try JSONDecoder().decode(StudentLocationResult.self, from: data!)
                completion(location.results)
            } catch {
                completion(nil)
            }
        }
    }
    
    func getUserInfo(completion: @escaping (_ status: Bool) -> Void) {
        let url = "https://onthemap-api.udacity.com/v1/users/\(self.key)"
        request(url: url, method: "GET") { (status, data) in
            guard status else {
                return
            }
            let newData = data?.subdata(in: 5..<data!.count)
            do {
                let object = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String : Any]
                self.FullName = object?["nickname"] as? String ?? ""
                var components = self.FullName.components(separatedBy: " ")
                self.FirstName = components.removeFirst()
                self.LastName = components.joined(separator: " ")
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func postLocation(location: StudentLocation, completion: @escaping (_ status: Bool) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        var params: Data?
          params = "{\"uniqueKey\": \"\(API.shared.key)\", \"firstName\": \"\(location.firstName ?? "")\", \"lastName\": \"\(location.lastName ?? "")\",\"mapString\": \"\(location.mapString ?? "")\", \"mediaURL\": \"\(location.mediaURL ?? "")\",\"latitude\": \(location.latitude ?? 0), \"longitude\": \(location.longitude ?? 0)}".data(using: .utf8)
      
        request(url: url, method: "POST", parameters: params) { (status, data) in
            guard status else {
                completion(false)
                return
            }
            do {
                let data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(data)
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
        }
    }
    
    func request(url: String, method: String, parameters: Data? = nil, completion: @escaping (_ status: Bool, _ data: Data?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.httpBody = parameters
        request.httpMethod = method
        
        URLSession.shared.dataTask(with: request) { (data, response1, error) in
            guard let response = response1 as? HTTPURLResponse,
                let data = data, (response.statusCode >= 200 && response.statusCode < 300) else {
                    completion(false, nil)
                    return
            }
            completion(true, data)
            }.resume()
    }
}
