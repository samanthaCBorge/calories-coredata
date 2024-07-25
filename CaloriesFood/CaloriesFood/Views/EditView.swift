//
//  EditView.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 9/7/24.
//

import SwiftUI

struct EditView: View {
 
    @ObservedObject var viewModel: EditViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var calories: Double = 0
    
    var body: some View {
        Form {
            Section() {
                TextField("\(viewModel.calorie.name)", text: $name)
                    .onAppear {
                        name = viewModel.calorie.name
                        calories = viewModel.calorie.calories
                    }
                VStack {
                    Text("Calories: \(Int(calories))")
                    Slider(value: $calories, in: 0...2000, step: 10)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        viewModel.edit(name: name, calories: calories)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}



