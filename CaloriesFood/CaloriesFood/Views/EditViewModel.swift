//
//  EditViewModel.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 9/7/24.
//

import Foundation

protocol EditViewModelRepresentable: ObservableObject {
    var calorie: Calorie { get }
    func edit(name: String, calories: Double)
}

final class EditViewModel {
    @Published var calorie: Calorie
    
    var services: Serviceable {
        let manager = CalorieManager()
        return Services(storage: manager)
    }
    
    init(calorie: Calorie) {
        self.calorie = calorie
    }
}

extension EditViewModel: EditViewModelRepresentable {
    func edit(name: String, calories: Double) {
        
        calorie.name = name
        calorie.calories = calories
        
        services.updateCalories(calorie: calorie) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

