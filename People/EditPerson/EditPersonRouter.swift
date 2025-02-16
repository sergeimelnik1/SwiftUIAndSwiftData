//
//  EditPersonRouter.swift
//  People
//
//  Created by admin on 16.02.2025.
//

import SwiftUI

final class EditPersonRouter: ObservableObject {
    @Published var navigationPath = NavigationPath()

    func navigateToEditEvent(_ event: Event) {
        navigationPath.append(event)
    }
}
