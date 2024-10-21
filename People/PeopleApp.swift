//
//  PeopleApp.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import SwiftData
import SwiftUI

@main
struct PeopleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
