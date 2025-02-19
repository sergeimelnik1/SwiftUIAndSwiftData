//
//  MockDataForPreview.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import Foundation
import SwiftData

@MainActor
struct MockDataForPreview {
    let container: ModelContainer
    let person: Person

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Person.self, configurations: config)

        person = Person(name: "Сергей Мельник", emailAddress: "melniksv@mkb.ru", phone: "+79969235544", details: "Какое-то описание контакта")

        container.mainContext.insert(person)
    }
}
