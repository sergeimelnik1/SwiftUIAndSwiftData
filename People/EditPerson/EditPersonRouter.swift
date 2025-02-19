//
//  EditPersonRouter.swift
//  People
//
//  Created by admin on 16.02.2025.
//

import SwiftUI

final class EditPersonRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var tempNotes: String = ""
    
    func navigateToNotes(currentNotes: String) {
        tempNotes = currentNotes
        path.append("notes")
    }
}
