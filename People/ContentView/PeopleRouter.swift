//
//  PeopleRouter.swift
//  People
//
//  Created by admin on 16.02.2025.
//

import SwiftUI

final class PeopleRouter: ObservableObject {
    @Published var path = NavigationPath()

    func navigateToEditPerson(_ person: Person) {
        path.append(person)
    }
}
