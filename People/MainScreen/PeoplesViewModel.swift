//
//  PeoplesViewModel.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import SwiftData
import SwiftUI

final class PeoplesViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var searchText: String = ""
    @Published var sortOrder: [SortDescriptor<Person>] = []

    private var modelContext: ModelContext?

    func setContext(_ context: ModelContext) {
        self.modelContext = context
        fetchPeople() // Загружаем данные при установке контекста
    }

    func fetchPeople() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<Person>(sortBy: sortOrder)

        do {
            let allPeople = try modelContext.fetch(descriptor)
            if searchText.isEmpty {
                people = allPeople
            } else {
                people = allPeople.filter { person in
                    person.name.localizedStandardContains(searchText) ||
                    person.emailAddress.localizedStandardContains(searchText) ||
                    person.details.localizedStandardContains(searchText)
                }
            }
        } catch {
            print("Ошибка загрузки людей: \(error)")
        }
    }

    func deletePeople(at offsets: IndexSet) {
        guard let modelContext else { return }
        for offset in offsets {
            let person = people[offset]
            modelContext.delete(person)
        }
        fetchPeople() // Обновляем список после удаления
    }
}

//#Preview {
//    do {
//        let previewer = try MockDataForPreview()
//
//        return PeopleView()
//            .modelContainer(previewer.container)
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}

