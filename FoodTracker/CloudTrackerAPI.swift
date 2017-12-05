//
//  CloudTrackerAPI.swift
//  FoodTracker
//
//  Created by Daniel Grosman on 2017-12-04.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

import UIKit
import KeychainSwift

class CloudTrackerAPI: NSObject {
    
    func registerUser (username: String, password: String) -> (){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard var URL = URL(string: "https://cloud-tracker.herokuapp.com/signup") else {return}
        let URLParams = [
            "username": username,
            "password": password,
            ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print(#line, error)
                return
            }
            guard (response as! HTTPURLResponse).statusCode == 200 else { return }
            guard let data = data else {
                print(#line, "no data")
                return
            }
            var json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data)
            }
            catch {
                print(#line, error.localizedDescription)
            }
            guard let users = json as? [String: Any] else {
                return
            }
            
            let username = users["username"] as? String
            let password = users["password"] as? String
            let token = users["token"] as? String
            
            let keychain = KeychainSwift ()
            keychain.set(username!, forKey: "username")
            keychain.set(password!, forKey: "password")
            keychain.set(token!, forKey: "token")

        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func loginUser (username: String, password: String) -> (){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard var URL = URL(string: "https://cloud-tracker.herokuapp.com/login") else {return}
        let URLParams = [
            "username": username,
            "password": password,
            ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print(#line, error)
                return
            }
            guard (response as! HTTPURLResponse).statusCode == 200 else { return }
            guard let data = data else {
                print(#line, "no data")
                return
            }
            var json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data)
            }
            catch {
                print(#line, error.localizedDescription)
            }
            guard let users = json as? [String: Any] else {
                return
            }
            
            let username = users["username"] as? String
            let password = users["password"] as? String
            let token = users["token"] as? String

            let keychain = KeychainSwift ()
            keychain.set(username!, forKey: "username")
            keychain.set(password!, forKey: "password")
            keychain.set(token!, forKey: "token")
            
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
