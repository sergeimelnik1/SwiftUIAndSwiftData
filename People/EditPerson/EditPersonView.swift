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
    @State private var selectedItem: PhotosPickerItem?
    @State private var temporaryNotes = ""

    var body: some View {
        Form {
            photoSection
            personalInfoSection
            phoneField
            notesSection
            statisticsSection
        }
        .navigationTitle("Изменить человека")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { destination in
            if destination == "notes" {
                EditNotesView(notes: $router.tempNotes)
                    .navigationTitle("Заметки")
                    .onDisappear {
                        viewModel.person.details = router.tempNotes
                    }
            }
        }
        .onChange(of: viewModel.selectedItem) { _, _ in
            viewModel.loadPhoto()
        }
        .onAppear {
            viewModel.pageOpened()
        }
    }

    var photoSection: some View {
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
    }

    var personalInfoSection: some View {
        Section {
            TextField("ФИО", text: $viewModel.person.name)
                .textContentType(.name)
            
            VStack(alignment: .leading) {
                TextField("Email", text: $viewModel.person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                if !viewModel.emailValidationMessage.isEmpty {
                    Text(viewModel.emailValidationMessage)
                        .font(.caption)
                        .foregroundColor(viewModel.emailValidationMessage.contains("✓") ? .green : .red)
                }
            }
        }
    }

    var phoneField: some View {
        TextField("Телефон", text: $viewModel.person.phone)
            .textContentType(.telephoneNumber)
            .textInputAutocapitalization(.never)
    }

    var notesSection: some View {
        Section("Заметки") {
            NavigationLink {
                EditNotesView(notes: $viewModel.person.details)
                    .navigationTitle("Заметки")
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.person.details.isEmpty ? "Добавить заметки" : viewModel.person.details)
                            .foregroundStyle(viewModel.person.details.isEmpty ? .secondary : .primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Символов: \(viewModel.notesCharacterCount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    var statisticsSection: some View {
        Section("Статистика открытия страницы") {
            Text("Количество открытий: \(viewModel.person.countOpened)")
        }
    }
}
