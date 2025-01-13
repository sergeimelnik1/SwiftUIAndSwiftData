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
    @Environment(\.modelContext) var modelContext
    @Bindable var person: Person
    @Binding var navigationPath: NavigationPath
    @State private var selectedItem: PhotosPickerItem?
    @State private var cancellables = Set<AnyCancellable>() // Для хранения подписок
    @State private var pageOpenedPublisher = PassthroughSubject<Void, Never>() // Publisher для события открытия страницы

    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)
    ]) var events: [Event]

    var body: some View {
        Form {
            Section {
                if let imageData = person.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Выбрать фото", systemImage: "person")
                }
            }

            Section {
                TextField("ФИО", text: $person.name)
                    .textContentType(.name)

                TextField("Email", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            Section("Where did you meet them?") {
                Picker("Met at", selection: $person.metAt) {
                    Text("Unknown event")
                        .tag(Optional<Event>.none)

                    if events.isEmpty == false {
                        Divider()

                        ForEach(events) { event in
                            Text(event.name)
                                .tag(Optional(event))
                        }
                    }
                }

                Button("Add a new event", action: addEvent)
            }
            
            TextField("Телефон", text: $person.phone)
                .textContentType(.telephoneNumber)
                .textInputAutocapitalization(.never)


            Section("Заметки") {
                TextField("Детали о человеке", text: $person.details, axis: .vertical)
            }
            Section("Статистика открытия страницы") {
                Text("Количество открытий: \(person.countOpened)")
            }
        }
        .navigationTitle("Изменить человека")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Event.self) { event in
            EditEventView(event: event)
        }
        .onChange(of: selectedItem, loadPhoto)
        .onAppear {
            // При появлении экрана, отправляем событие через publisher
            pageOpenedPublisher.send()
        }
        .onReceive(pageOpenedPublisher) { _ in
            // Увеличиваем countOpened каждый раз при открытии страницы
            person.countOpened += 1
        }
        .onDisappear {
            // Можно остановить подписку или выполнить другие действия при исчезновении экрана
            cancellables.removeAll()
        }
    }

    func addEvent() {
        let event = Event(name: "", location: "")
        modelContext.insert(event)
        navigationPath.append(event)
    }

    func loadPhoto() {
        Task { @MainActor in
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
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
