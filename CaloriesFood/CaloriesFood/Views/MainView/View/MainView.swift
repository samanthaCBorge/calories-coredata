//
//  MainView.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 8/2/24.
//

import SwiftUI

struct MainView: View {
    
    @State var viewModel = MainViewModel()
    @State private var showingAddView = false
    @State private var showingEditView = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.calorie, id: \.id) { item in
                        let editViewModel = EditViewModel(calorie: item)
                        NavigationLink(destination: EditView(viewModel: editViewModel)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .bold()
                                    
                                    Text("\(Int(item.calories))") + Text(" calories").foregroundColor(.red)
                                }
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: viewModel.delete)
                }
                .sheet(isPresented: $showingAddView) {
                    let viewModel = AddNewViewModel()
                    AddNewView(viewModel: viewModel)
                }
                .onChange(of: showingAddView) {
                    viewModel.getCalories()
                }
                .onAppear {
                    viewModel.getCalories()
                }
            }
            .navigationBarItems(trailing:
            Button {
                showingAddView.toggle()
            } label: {
                Label("", systemImage: "plus.circle")
                    .font(.system(size: 24))
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Calories")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}



