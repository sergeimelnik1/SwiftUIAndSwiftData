//
//  EditPersonView.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import PhotosUI
import SwiftData
import SwiftUI
import Combine

struct EditPersonView: View {
    @ObservedObject var viewModel: EditPersonViewModel
    @ObservedObject var router: EditPersonRouter

    var body: some View {
        Form {
            Section {
                if let imageData = viewModel.person.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }

                PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                    Label("Выбрать фото", systemImage: "person")
                }
            }

            Section {
                TextField("ФИО", text: $viewModel.person.name)
                    .textContentType(.name)

                TextField("Email", text: $viewModel.person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            Section("Where did you meet them?") {
                Picker("Met at", selection: $viewModel.person.metAt) {
                    Text("Unknown event")
                        .tag(Optional<Event>.none)

                    if viewModel.events.isEmpty == false {
                        Divider()

                        ForEach(viewModel.events) { event in
                            Text(event.name)
                                .tag(Optional(event))
                        }
                    }
                }

                Button("Add a new event") {
                    viewModel.addEvent()
                }
            }

            TextField("Телефон", text: $viewModel.person.phone)
                .textContentType(.telephoneNumber)
                .textInputAutocapitalization(.never)

            Section("Заметки") {
                TextField("Детали о человеке", text: $viewModel.person.details, axis: .vertical)
            }

            Section("Статистика открытия страницы") {
                Text("Количество открытий: \(viewModel.person.countOpened)")
            }
        }
        .navigationTitle("Изменить человека")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Event.self) { event in
            EditEventView(event: event)
        }
        .onChange(of: viewModel.selectedItem) { _, _ in
            viewModel.loadPhoto()
        }
        .onAppear { viewModel.pageOpened() }
        .navigationDestination(for: Event.self) { event in
            EditEventView(event: event)
        }
    }
}

//#Preview {
//    do {
//        let previewer = try MockDataForPreview()
//
//        return EditPersonView(person: previewer.person, navigationPath: .constant(NavigationPath()))
//            .modelContainer(previewer.container)
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
