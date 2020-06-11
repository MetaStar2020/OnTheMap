//
//  StudentLocationUpdateResponse.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-11.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentLocationUpdateResponse: Codable {
    
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt
    }
    
}
