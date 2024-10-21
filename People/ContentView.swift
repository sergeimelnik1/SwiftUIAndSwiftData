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
//https://www.hackingwithswift.com/articles/263/build-your-first-app-with-swiftui-and-swiftdata
    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("People")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person, navigationPath: $path)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\Person.name)])

                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }

                    Button("Add Person", systemImage: "plus", action: addPerson)
                }
                .searchable(text: $searchText)
        }
    }

    func addPerson() {
        let person = Person(name: "", emailAddress: "", details: "")
        modelContext.insert(person)
        path.append(person)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
