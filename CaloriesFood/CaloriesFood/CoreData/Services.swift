//
//  Services.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 7/2/24.
//

import CoreData

protocol Serviceable {
    func fetch(completion: @escaping (Result<[NSManagedObject], Failure>) -> ())
    func create(calorie: Calorie, completion: @escaping (Result<Bool, Failure>) -> ())
    func updateCalories(calorie: Calorie, completion: @escaping (Result<Bool, Failure>) -> ())
    func saveDataOf(calories: [Calorie])
    func delete(byId id: String, completion: @escaping (Result<Bool, Failure>) -> ())
}

final class Services {
    private let storage: Storage
    
    required init(storage: Storage) {
        self.storage = storage
    }
}

extension Services: Serviceable {
    
    func fetch(completion: @escaping (Result<[NSManagedObject], Failure>) -> ()) {
        storage.fetch { result in
            switch result {
            case .success(let todos):
                if let todos = todos {
                    completion(.success(todos))
                } else {
                    completion(.failure(.statusCode))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func create(calorie: Calorie, completion: @escaping (Result<Bool, Failure>) -> ()) {
        storage.create(object: calorie) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure:
                completion(.failure(.statusCode))
            }
        }
    }
    
    func delete(byId id: String, completion: @escaping (Result<Bool, Failure>) -> ()) {
        storage.delete(byId: id) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure:
                completion(.failure(.statusCode))
            }
        }
    }
    
    func updateCalories(calorie: Calorie, completion: @escaping (Result<Bool, Failure>) -> ()) {
        storage.updateCalories(calorie) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure:
                completion(.failure(.statusCode))
            }
        }
    }
    
    func saveDataOf(calories: [Calorie]) {
        storage.saveDataOf(calories: calories)
    }
}

