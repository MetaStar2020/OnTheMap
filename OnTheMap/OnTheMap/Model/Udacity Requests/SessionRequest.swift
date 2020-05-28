//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-27.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct Student: Codable {
    
    let username: String
    let password: String
    
    //let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        //case requestToken = "request_token"
    }
}

struct SessionRequest: Codable {
    
    let udacity: Student
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
