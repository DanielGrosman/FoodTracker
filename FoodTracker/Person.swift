//
//  Person.swift
//  FoodTracker
//
//  Created by Daniel Grosman on 2017-12-04.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    //MARK: Properties
    
    var username: String
    var password: String
    var token: String
    
    init?(username: String, password: String, token: String) {
        
        self.username = username
        self.password = password
        self.token = token
    }
}
