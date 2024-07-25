//
//  AddNewViewModel.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 4/7/24.
//

import Foundation

protocol AddNewViewModelRepresentable: ObservableObject {
    func save(name: String, calories: Double, date: Date)
}

final class AddNewViewModel {
    
    var services: Serviceable {
        let manager = CalorieManager()
        return Services(storage: manager)
    }
    
}

extension AddNewViewModel: AddNewViewModelRepresentable {
    func save(name: String, calories: Double, date: Date) {
        let calorie = Calorie(id: UUID().uuidString, name: name, calories: calories, date: date)
        services.create(calorie: calorie) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
