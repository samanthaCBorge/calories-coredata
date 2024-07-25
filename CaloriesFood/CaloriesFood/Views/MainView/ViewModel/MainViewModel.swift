//
//  MainViewModel.swift
//  CaloriesFood
//
//  Created by SC on 8/2/24.
//

import SwiftUI
import Combine

@Observable
final class MainViewModel {
    var id: String = ""
    var calorie = [Calorie]()
    
    var services: Serviceable {
        let manager = CalorieManager()
        return Services(storage: manager)
    }
}

extension MainViewModel {
    func getCalories() {
        services.fetch { [weak self] result in
            switch result {
            case .success(let caloriesManagedObjects):
                let calories = caloriesManagedObjects.compactMap {
                    CalorieObject(nsManagedObject: $0).calorie
                }
                self?.calorie = calories
                
            case .failure:
                break
            }
        }
    }
    
    func delete(at indexSet: IndexSet) {
        for index in indexSet {
            let calorieId = calorie[index].id
            calorie.remove(at: index)
            
            withAnimation {
                services.delete(byId: calorieId) { result in
                    switch result {
                    case .success:
                        break
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            }
        }
    }
}

