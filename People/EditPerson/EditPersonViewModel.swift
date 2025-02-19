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
    @Published var emailValidationMessage: String = ""
    @Published var notesCharacterCount: Int = 0

    private var cancellables = Set<AnyCancellable>()
    private let modelContext: ModelContext
    private let router: EditPersonRouter

    init(person: Person, modelContext: ModelContext, router: EditPersonRouter) {
        self.person = person
        self.modelContext = modelContext
        self.router = router
        self.notesCharacterCount = person.details.count
        
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        // Валидация email в реальном времени
        $person
            .map(\.emailAddress)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map { email -> String in
                guard !email.isEmpty else { return "" }
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: email) ? "✓ Правильный email" : "⚠️ Неправильный формат email"
            }
            .assign(to: \.emailValidationMessage, on: self)
            .store(in: &cancellables)
        
        // Подсчет символов в заметках
        $person
            .map(\.details)
            .map { $0.count }
            .assign(to: \.notesCharacterCount, on: self)
            .store(in: &cancellables)
        
        // Автосохранение после паузы в редактировании
        $person
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveChanges()
            }
            .store(in: &cancellables)
    }

    private func saveChanges() {
        try? modelContext.save()
    }

    func loadPhoto() {
        Task { @MainActor in
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }

    func pageOpened() {
        person.countOpened += 1
    }
}
