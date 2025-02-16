//
//  PeopleViewModel.swift
//  People
//
//  Created by admin on 16.02.2025.
//

import SwiftUI
import SwiftData

final class PeopleViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var sortOrder = [SortDescriptor(\Person.name)]

    private var modelContext: ModelContext?
    private var router: PeopleRouter?

    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func setRouter(_ router: PeopleRouter) {
        self.router = router
    }

    func addPerson() {
        guard let modelContext, let router else { return }
        let person = Person(name: "", emailAddress: "", phone: "", details: "")
        modelContext.insert(person)
        router.navigateToEditPerson(person)
    }
}
