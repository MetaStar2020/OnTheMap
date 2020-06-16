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
        static var objectId: String?
    }
    
    struct PublicUserInfo { //Udacity created an API with random user info to protect privacy
        static var firstName = ""
        static var lastName = ""
    }
    
    //MARK: - URLS
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let order = "-updatedAt"
        
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
                case .updateStudentLocation(let objectId): return EndPoints.base + "/StudentLocation/\(objectId)"
                case .session: return EndPoints.base + "/session"
                case .getPublicUserData(let userId): return EndPoints.base + "/users/\(userId)"
                case .webAuth: return "https://auth.udacity.com/sign-up."
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
 
    //MARK: - Class Functions: GET
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                    print("Data is no longer available.")
                }
                return
            }
            
            var newData = data
            
            let decoder = JSONDecoder()
            do {
        
                if responseType is PublicUserInfoResponse.Type {
                    print("responseType is PublicUserInfoResponse")
                    let range = {5..<data.count}
                    newData = data.subdata(in: range())
                    print(String(data: newData, encoding: .utf8)!)
                }
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                
            } catch {
                do {
                    print("responseObject was not decoded")
                     print(error)
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data) as Error
                    
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
    
    class func getPublicUserData(userId: String, completion: @escaping (Bool, Error?) -> Void) {
        
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
    }
    
    class func getStudentLocation(limit: Int? = nil, skip: Int? = nil, order: String? = nil, uniqueKey: String? = nil, completion: @escaping ([StudentInformation], Error?) -> Void) {
        
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
    
   //MARK: - Class Functions: POST
    
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
                do {
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data) as Error
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
    }
    
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
                completion(false, error)
            }
        }
    }
    
    class func postStudentLocation(body: StudentInformation, completion: @escaping (Bool, Error?) -> Void ) {
        
        taskForPOSTRequest(url: EndPoints.postStudentLocation.url, responseType: StudentLocationResponse.self, body: body) { response, error in
            if let response = response {
                StudentLocation.Auth.objectId = response.objectId
                print("Student Location objectId: \(response.objectId)")
                print("Student Location created \(response.createdAt)")
                completion(true, nil)
            } else {
                completion(false, error)
            //handle error...
            }
        }
    }
   
    //MARK: - Class Functions: PUT
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    print("error in data its nil")
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print("error in decoding data - in PUT task")
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
    
    class func updateStudentLocation(body: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        
        taskForPUTRequest(url: EndPoints.updateStudentLocation(StudentLocation.Auth.objectId!).url, responseType: StudentLocationUpdateResponse.self, body: body) { response, error in
            if let response = response {
                //handle success
                print("student location updated \(response.updatedAt)")
                completion(true, nil)
            } else {
                completion(false, error)
                //handle error...
            }
        }
    }
    
    //MARK: - Class Functions: others
    
    class func logout(completion: @escaping () -> Void) {
        
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
