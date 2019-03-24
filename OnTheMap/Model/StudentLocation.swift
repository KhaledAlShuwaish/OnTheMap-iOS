//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Khaled Shuwaish on 13/02/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

struct StudentLocationResult: Codable {
    var results: [StudentLocation] = []
}

struct StudentLocation: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String? = API.shared.key
    var updatedAt: String?
}
