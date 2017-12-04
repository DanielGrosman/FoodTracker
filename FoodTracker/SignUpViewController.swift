//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Daniel Grosman on 2017-12-04.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//
import Foundation
import UIKit
import KeychainSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        sendRequest()
    }
    func sendRequest() {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard var URL = URL(string: "https://cloud-tracker.herokuapp.com/signup") else {return}
        let URLParams = [
            "username": usernameTextField.text!,
            "password": passwordTextField.text!,
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
            let user = Person(username: users["username"] as! String, password: users["password"] as! String, token: users["token"] as! String)
            let keychain = KeychainSwift ()
            keychain.set(user!.username, forKey: "username")
            keychain.set(user!.password, forKey: "password")
            
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



