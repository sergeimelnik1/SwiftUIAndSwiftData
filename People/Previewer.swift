//
//  Previewer.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let event: Event
    let person: Person

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Person.self, configurations: config)

        event = Event(name: "Dimension Jump", location: "Nottingham")
        person = Person(name: "Dave Lister", emailAddress: "dave@reddwarf.com", details: "", metAt: event)

        container.mainContext.insert(person)
    }
}
