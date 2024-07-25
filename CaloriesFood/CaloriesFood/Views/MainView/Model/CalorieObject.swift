//
//  CalorieObject.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 2/4/24.
//

import CoreData

struct CalorieObject: Hashable {
    private var _calorieNSManagedObject: NSManagedObject!
    
    var calorieNSManagedObject: NSManagedObject {
        set {
            _calorieNSManagedObject = newValue
            fillCalorieModel(from: newValue)
        }
        get { _calorieNSManagedObject }
    }
    
    private mutating func fillCalorieModel(from nsManagedObj: NSManagedObject){
        if let id = nsManagedObj.value(forKey: "id"),
           let name = nsManagedObj.value(forKey: "name"),
           let date = nsManagedObj.value(forKey: "date") as? Date ?? nil,
           let calories = nsManagedObj.value(forKey: "calories") as? Double ?? nil {
            
            calorie = Calorie(id: "\(id)", name: "\(name)", calories: calories, date: date)
        }
    }
    
    var calorie: Calorie?
    
    init(nsManagedObject: NSManagedObject) {
        self.calorieNSManagedObject = nsManagedObject
    }
}

