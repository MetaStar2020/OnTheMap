//
//  StudentResults.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct StudentResults: Codable {
    
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
}
