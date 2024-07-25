//
//  CaloriesManager.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 7/2/24.
//

import CoreData

protocol Storage {
    func create<T>(object: T, completion: @escaping (Result<Bool, Failure>) -> ())
    func fetch<T: NSManagedObject>(completion: @escaping (Result<[T]?, Failure>) -> ())
    func updateCalories(_ calorie: Calorie, completion: @escaping (Result<Bool, Failure>) -> ()) 
    func saveDataOf(calories: [Calorie])
    func delete(byId id: String, completion: @escaping (Result<Bool, Failure>) -> ())
}

struct CalorieManager {
    
    let mainContext: NSManagedObjectContext
    private let fetchRequest = NSFetchRequest<CaloriesFoodEntity>(entityName: "CaloriesFoodEntity")
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
    
    private func deleteObjectsfromCoreData() {
        do {
            let objects = try mainContext.fetch(fetchRequest)
            _ = objects.map({mainContext.delete($0)})
            
            try mainContext.save()
        } catch {
            print("Deleting Error: \(error)")
        }
    }
    
    private func updateCalorieInCoreData(_ calorie: Calorie) {
        mainContext.performAndWait {
            let fetchRequest: NSFetchRequest<CaloriesFoodEntity> = CaloriesFoodEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", calorie.id as CVarArg)
            
            do {
                let results = try mainContext.fetch(fetchRequest)
                if let calorieEntity = results.first {
                    calorieEntity.name = calorie.name
                    calorieEntity.calories = calorie.calories
                    
                    try mainContext.save()
                }
            } catch {
                print("Error updating calorie: \(error)")
            }
        }
    }
    
    private func saveDataToCoreData(calories: [Calorie]) {
        mainContext.perform {
            for calorie in calories {
                let caloriesFoodEntity = CaloriesFoodEntity(context: mainContext)
                caloriesFoodEntity.id = calorie.id
                caloriesFoodEntity.name = calorie.name
                caloriesFoodEntity.calories = calorie.calories
                caloriesFoodEntity.date = calorie.date
            }
            
            do {
                try mainContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}

extension CalorieManager: Storage {
    
    func saveDataOf(calories: [Calorie]) {
        deleteObjectsfromCoreData()
        saveDataToCoreData(calories: calories)
    }
    
    func delete(byId id: String, completion: @escaping (Result<Bool, Failure>) -> ()) {
        mainContext.perform {
            let fetchRequest: NSFetchRequest<CaloriesFoodEntity> = CaloriesFoodEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try mainContext.fetch(fetchRequest)
                if let calorieToDelete = results.first {
                    mainContext.delete(calorieToDelete)
                    try mainContext.save()
                }
            } catch {
                print("Deleting Error: \(error)")
            }
        }
    }
    
    func updateCalories(_ calorie: Calorie, completion: @escaping (Result<Bool, Failure>) -> ()) {
        mainContext.performAndWait {
            updateCalorieInCoreData(calorie)
            completion(.success(true))
        }
    }
    
    func create<T>(object: T, completion: @escaping (Result<Bool, Failure>) -> ()) {
        guard let calorie = object as Any as? Calorie else {
            completion(.failure(.statusCode))
            return
        }
        
        let caloriesEntity = CaloriesFoodEntity(context: mainContext)
        caloriesEntity.id = calorie.id
        caloriesEntity.name = calorie.name
        caloriesEntity.calories = calorie.calories
        caloriesEntity.date = calorie.date
        
        do {
            try mainContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(.statusCode))
        }
    }
    
    func fetch<T>(completion: @escaping (Result<[T]?, Failure>) -> ()) where T : NSManagedObject {
        let fetchRequest = NSFetchRequest<T>(entityName: "CaloriesFoodEntity")
        
        do {
            let calories = try mainContext.fetch(fetchRequest)
            completion(.success(calories))
        } catch {
            completion(.failure(.statusCode))
        }
    }
}

enum Failure: Error {
    case decodingError
    case urlConstructError
    case APIError(Error)
    case statusCode
}
