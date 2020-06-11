//
//  Student.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


class StudentLocation {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    
    struct PublicUserInfo { //Udacity created an API with random user info to protect privacy
        static var firstName = ""
        static var lastName = ""
    }
    
    //MARK: - URLS
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let order = "?order=-updatedAt"
        
        case getStudentLocation(String)
        case postStudentLocation
        case updateStudentLocation(String)
        case session
        case getPublicUserData(String)
        case webAuth
        
        var stringValue: String {
            switch self {
                case .getStudentLocation(let query): return EndPoints.base + "/StudentLocation" + query
                case .postStudentLocation: return EndPoints.base + "/StudentLocation"
                case .updateStudentLocation(let objectId): return EndPoints.base + "/\(objectId)"
                case .session: return EndPoints.base + "/session"
                case .getPublicUserData(let userId): return EndPoints.base + "/users/\(userId)"
                case .webAuth: return "https://auth.udacity.com/sign-up."
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
 
    //MARK: - class functions
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                    print("no data was in GET")
                }
                return
            }
            
            var newData = data
            
            let decoder = JSONDecoder()
            do {
                //print("this is the raw data in GET\(String(data: data, encoding: .utf8)!)")
                
                if responseType is PublicUserInfoResponse.Type {
                    print("responseType is PublicUserInfoResponse")
                    let range = {5..<data.count}
                    newData = data.subdata(in: range()) // subset response data! TO CHECK: Range<Int> in documentation
                    print(String(data: newData, encoding: .utf8)!)
                }
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                        //print("responseObject is\(responseObject)")
                    }
                
            } catch {
                do {
                    print("responseObject was not decoded")
                     print(error)
                    let errorResponse = try decoder.decode(StudentResponse.self, from: data) as Error
                    
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                       
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func getStudentLocation(limit: Int? = nil, skip: Int? = nil, order: String? = nil, uniqueKey: String? = nil, completion: @escaping ([StudentInformation], Error?) -> Void) {
        //Optional Parameters: limit(Number), skip(Number), order(String), uniqueKey(String)[aka UserID]
        //let query = EndPoints.order
        let query = createQuery(limit: limit, skip: skip, order: order, uniqueKey: uniqueKey)
        taskForGETRequest(url: EndPoints.getStudentLocation(query).url, responseType: StudentResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
                //print("getStudentLocation results: \(response.results)")
            } else {
                completion([], error)
            }
        }
    }
    
    class func createQuery(limit: Int?, skip: Int?, order: String?, uniqueKey: String?) -> String {
        
        var query = ""
        var next = false
        
        //add '?' symbol to the query only if not nil
        if limit != nil || skip != nil || order != nil || uniqueKey != nil {
            query += "?"
        }
        
        if let limit = limit {
            query += "limit=\(limit)"
            next = true
        }
        
        if let skip = skip {
            if next == true { query += "&" }
            query += "skip=\(skip)"
            next = true
        }
        
        if let order = order {
            if next == true { query += "&" }
            query += "order=\(order)"
            next = true
        }
        
        if let uniqueKey = uniqueKey {
            if next == true { query += "&" }
            query += "uniqueKey=\(uniqueKey)"
            next = true
        }
        
        print("StudentLocation query is \(query)")
        
        return query
    }
    
    /*class func getStudentLocation() {
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
    }*/
    
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
    
    //MARK: -I am here!
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: Student(username: username, password: password))
          taskForPOSTRequest(url: EndPoints.session.url, responseType: SessionResponse.self, body: body) { response, error in
              if let response = response {
                print("session succeeded, now adding to Auth...")
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                print(Auth.sessionId)
                print(Auth.accountKey)
                  completion(true, nil)
              } else {
                print("no SessionResponse")
                  completion(false, nil)
              }
          }
      }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if responseType is SessionResponse.Type {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            print("addedValue")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    print("error in data its nil")
                    completion(nil, error)
                }
                return
            }
            var newData = data
            
            if responseType is SessionResponse.Type {
                let range = {5..<data.count}
                newData = data.subdata(in: range()) /* subset response data! TO CHECK: Range<Int> in documentation */
                print("data is ranged for session response")
                print(String(data: newData, encoding: .utf8)!)
                //NOTE: if account is invalid this will be the response: {"status":403,"error":"Account not found or invalid credentials."}
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print("error in decoding data")
                /*do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }*/
            }
        }
        task.resume()
    }

    /*
    class func createSessionId() {
        //Method: https://onthemap-api.udacity.com/v1/session
        //request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        
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
 */
    
    class func getPublicUserData(userId: String, completion: @escaping (Bool, Error?) -> Void) {
        //Method Name: https://onthemap-api.udacity.com/v1/users/<user_id>
        //let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        
        taskForGETRequest(url: EndPoints.getPublicUserData(userId).url, responseType: PublicUserInfoResponse.self) { response, error in
            if let response = response {
                completion(true, nil)
                print("getPublicUserData: \(response)")
                PublicUserInfo.firstName = response.firstName
                PublicUserInfo.lastName = response.lastName
            } else {
                completion(false, error)
            }
        }
        //let range = {5..<data!.count}
        //let newData = data?.subdata(in: range()) /* subset response data! */
        //print(String(data: newData!, encoding: .utf8)!)
    }
    
    
    class func logout(completion: @escaping () -> Void) {
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
            completion()
        }
        task.resume()
    }
}
