//
//  EditPersonView.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import SwiftUI

struct EditNotesView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var notes: String
    
    var body: some View {
        TextEditor(text: $notes)
            .padding()
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
    }
}
