//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-05.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct UdacityErrorResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
