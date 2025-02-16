//
//  EditEventView.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import SwiftUI

struct EditEventView: View {
    @Bindable var event: Event

    var body: some View {
        Form {
            TextField("Название события", text: $event.name)
            TextField("Локация", text: $event.location)
        }
        .navigationTitle("Изменить событие")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let previewer = try MockDataForPreview()

        return EditEventView(event: previewer.event)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
