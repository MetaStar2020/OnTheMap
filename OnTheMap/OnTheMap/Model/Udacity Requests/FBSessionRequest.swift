//
//  FBSessionRequest.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-17.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct FBSessionRequest: Codable {
    
    let facebookMobile: FBAccessToken
    
    enum CodingKeys: String, CodingKey {
        case facebookMobile = "facebook_mobile"
    }
}

struct FBAccessToken: Codable {
    
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
