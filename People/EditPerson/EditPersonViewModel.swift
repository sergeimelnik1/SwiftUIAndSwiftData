//
//  EditPersonViewModel.swift
//  People
//
//  Created by admin on 16.02.2025.
//

import SwiftUI
import PhotosUI
import Combine
import SwiftData

final class EditPersonViewModel: ObservableObject {
    @Published var person: Person
    @Published var selectedItem: PhotosPickerItem?
    @Published var events: [Event] = []

    private var cancellables = Set<AnyCancellable>()
    private let modelContext: ModelContext
    private let router: EditPersonRouter

    init(person: Person, modelContext: ModelContext, router: EditPersonRouter) {
        self.person = person
        self.modelContext = modelContext
        self.router = router
    }

    func loadEvents() {
        // Здесь можно использовать FetchRequest или другой способ загрузки событий
        // (если SwiftData, то лучше передавать данные через DI)
    }

    func loadPhoto() {
        Task { @MainActor in
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }

    func addEvent() {
        let event = Event(name: "", location: "")
        modelContext.insert(event)
        router.navigateToEditEvent(event)
    }

    func pageOpened() {
        person.countOpened += 1
    }
}
