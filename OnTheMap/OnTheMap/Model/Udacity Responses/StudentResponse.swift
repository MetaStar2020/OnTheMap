//
//  StudentResponse.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-05.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct StudentResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension StudentResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
