//
//  EditPasswordView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque
//  UI Design by Fernando Abel Malca Luque

import CoreData
import SwiftUI

struct EditPasswordView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: EditPasswordViewModel

    init(entry: Entry) {
        _vm = StateObject(wrappedValue: EditPasswordViewModel(entry: entry))
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Entry Name", text: $vm.title)
                    SecureField(
                        "New Password (leave blank to keep old)",
                        text: $vm.password)
                    HStack {
                        Spacer()
                        Image(systemName: vm.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Spacer()
                    }
                    Button("Pick Icon") {
                        vm.showIconPicker = true
                    }
                }

                Section("Notes") {
                    TextEditor(text: $vm.notes)
                        .frame(minHeight: 100)
                }
            }
            .sheet(isPresented: $vm.showIconPicker) {
                IconPickerView(selection: $vm.icon)
            }
            .navigationTitle("Edit Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            let ok =
                                await AuthenticationService.authenticateUser(
                                    reason: "Confirm edit")
                            if ok {
                                vm.save(context: context)
                                dismiss()
                            }
                        }
                    }
                    .disabled(vm.title.isEmpty)
                }
            }
        }
    }
}
