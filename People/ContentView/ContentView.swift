//
//  ContentView.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var router = PeopleRouter()
    @StateObject private var viewModel = PeopleViewModel()
    @StateObject private var editPersonRouter = EditPersonRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            PeopleView(searchString: viewModel.searchText, sortOrder: viewModel.sortOrder)
                .navigationTitle("Контакты")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(viewModel: EditPersonViewModel(person: person, modelContext: modelContext, router: editPersonRouter), router: editPersonRouter)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $viewModel.sortOrder) {
                            Text("ФИО (А-Я)").tag([SortDescriptor(\Person.name)])
                            Text("ФИО (Я-А)").tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }

                    Button("Добавить человека", systemImage: "plus", action: viewModel.addPerson)
                }
                .searchable(text: $viewModel.searchText)
                .onAppear {
                    viewModel.setContext(modelContext) // Передаем modelContext после загрузки View
                    viewModel.setRouter(router)       // Передаем router
                }
        }
    }
}
