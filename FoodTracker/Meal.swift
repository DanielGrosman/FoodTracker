//
//  Meal.swift
//  FoodTracker
//
//  Created by Daniel Grosman on 2017-12-03.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject {
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    var itemDescription: String
    var calories: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let itemDescription = "itemDescription"
        static let calories = "calories"
    }
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int, itemDescription: String, calories: String) {
        if name.isEmpty || rating < 0  {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
        self.itemDescription = itemDescription
        self.calories = calories
    }
}
