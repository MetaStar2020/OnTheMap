//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-11.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
    
}
