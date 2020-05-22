//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: Date
    let updatedAt: Date
    //let ACL: ACL
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
        case createdAt
        case updatedAt
        //case ACL
    }
    
}
