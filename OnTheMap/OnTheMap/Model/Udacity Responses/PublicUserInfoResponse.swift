//
//  PublicUserInfoResponse.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct PublicUserInfoResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
