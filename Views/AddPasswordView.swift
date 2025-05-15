//
//  AddPasswordView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque
//  UI Design by Herber Josue Trujillo Cruz

import CoreData
import SwiftUI

struct AddPasswordView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = AddPasswordViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $vm.title)
                    SecureField("Password", text: $vm.password)
                    HStack {
                        Spacer()
                        Image(systemName: vm.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.bottom, 8)
                        Spacer()
                    }
                    Button("Pick Icon") { vm.showIconPicker = true }
                }
                Section("Notes") {
                    TextEditor(text: $vm.notes).frame(minHeight: 100)
                }
            }
            .sheet(isPresented: $vm.showIconPicker) {
                IconPickerView(selection: $vm.icon)
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            let ok =
                                await AuthenticationService.authenticateUser(
                                    reason: "Lock in new entry")
                            if ok {
                                vm.save(context: context)
                                dismiss()
                            }
                        }
                    }
                    .disabled(vm.title.isEmpty || vm.password.isEmpty)
                }
            }
        }
    }
}
