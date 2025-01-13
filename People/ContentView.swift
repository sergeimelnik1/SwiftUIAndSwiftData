//
//  ContentView.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()

    @State private var sortOrder = [SortDescriptor(\Person.name)]
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("Контакты")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person, navigationPath: $path)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("ФИО (А-Я)")
                                .tag([SortDescriptor(\Person.name)])

                            Text("ФИО (Я-А)")
                                .tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }

                    Button("Добавить человека", systemImage: "plus", action: addPerson)
                }
                .searchable(text: $searchText)
        }
    }

    func addPerson() {
        let person = Person(name: "", emailAddress: "", phone: "", details: "")
        modelContext.insert(person)
        path.append(person)
    }
}

#Preview {
    do {
        let previewer = try MockDataForPreview()

        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
