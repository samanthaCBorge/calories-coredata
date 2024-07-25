//
//  AddNewView.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 4/7/24.
//

import SwiftUI

struct AddNewView: View {
 
    @ObservedObject var viewModel: AddNewViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var calories: Double = 0
    @State private var date: Date = Date()
    
    var body: some View {
        Form {
            Section() {
                TextField("Food name", text: $name)
                
                VStack {
                    Text("Calories: \(Int(calories))")
                    Slider(value: $calories, in: 0...1000, step: 10)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        viewModel.save(name: name, calories: calories, date: date)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}


