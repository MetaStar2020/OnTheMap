//
//  Student.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class StudentLocation {
    
    //MARK: - URLS
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let order = "?order=-updatedAt"
        
        case getStudentLocation(String)
        case postStudentLocation
        case updateStudentLocation(String)
        case session
        case getPublicUserData(String)
        
        var stringValue: String {
            switch self {
                case .getStudentLocation(let query): return EndPoints.base + "/StudentLocation" + query
                case .postStudentLocation: return EndPoints.base + "/StudentLocation"
                case .updateStudentLocation(let objectId): return EndPoints.base + "/\(objectId)"
                case .session: return EndPoints.base + "/session"
            case .getPublicUserData(let userId): return EndPoints.base + "/users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
 
    //MARK: - class functions
    class func getStudentLocation() {
        //Optional Parameters: limit(Number), skip(Number), order(String), uniqueKey(String)[aka UserID]
        //Method: https://onthemap-api.udacity.com/v1/StudentLocation
        
        var request = URLRequest(url:  EndPoints.getStudentLocation(EndPoints.order).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func postStudentLocation() {
        //Method: https://onthemap-api.udacity.com/v1/StudentLocation
        
        var request = URLRequest(url: EndPoints.postStudentLocation.url )
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func updateStudentLocation(objectId: String) {
        //required parameters: objectId(String)
        //Method: https://onthemap-api.udacity.com/v1/StudentLocation/<objectId>
        // let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8"
        
        var request = URLRequest(url: EndPoints.updateStudentLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func createSessionId() {
        //Method: https://onthemap-api.udacity.com/v1/session
        
        var request = URLRequest(url: EndPoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
            let range = {5..<data!.count}
            let newData = data?.subdata(in: range()) /* subset response data! TO CHECK: Range<Int> in documentation */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func getPublicUserData(userId: String) {
        //Method Name: https://onthemap-api.udacity.com/v1/users/<user_id>
        //let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        
        let request = URLRequest(url: EndPoints.getPublicUserData(userId).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
            let range = {5..<data!.count}
          let newData = data?.subdata(in: range()) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func logout() {
        // Method: https://onthemap-api.udacity.com/v1/session
        
        var request = URLRequest(url: EndPoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
            let range = {5..<data!.count}
          let newData = data?.subdata(in: range()) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
