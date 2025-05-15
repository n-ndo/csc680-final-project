//
//  SettingsView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque
//  UI Designed by Heber Josue Trujillo Cruz

import CoreData
import LocalAuthentication
import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var settingsService: SettingsService

    @StateObject private var vm = SettingsViewModel()
    @State private var requireAuthError = false
    @State private var showAbout = false
    @State private var showDeleteConfirm = false
    @State private var showErrorAlert = false
    @State private var deleteErrorMessage = ""

    var body: some View {
        Form {
            Section("General") {
                Toggle(
                    "Use Biometrics",
                    isOn: Binding(
                        get: { vm.useBiometrics },
                        set: { new in
                            if !new {
                                authenticateToDisableBiometrics()
                            } else {
                                vm.useBiometrics = true
                            }
                        }
                    )
                )
                .alert("Authentication failed", isPresented: $requireAuthError)
                {
                    Button("OK", role: .cancel) {}
                }

                Stepper(
                    "Auto-lock: \(Int(vm.autoLockInterval))s",
                    value: $vm.autoLockInterval,
                    in: 10...300, step: 10)

                Picker(
                    "Sort Order",
                    selection: Binding<Bool>(
                        get: { settingsService.settings.sortAZ },
                        set: { newValue in
                            settingsService.settings.sortAZ = newValue
                            settingsService.save()
                        }
                    )
                ) {
                    Text("A–Z").tag(true)
                    Text("Z–A").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Button("Delete All Passwords", role: .destructive) {
                    showDeleteConfirm = true
                }
                .alert("Are you sure?", isPresented: $showDeleteConfirm) {
                    Button("Delete", role: .destructive) {
                        vm.deleteAllPasswords(context: context) { result in
                            switch result {
                            case .success: break
                            case .failure(let error):
                                deleteErrorMessage = error.localizedDescription
                                showErrorAlert = true
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will permanently remove all saved passwords.")
                }
                .alert("Error", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(deleteErrorMessage)
                }
            }

            Section {
                Button("About This App") {
                    showAbout = true
                }
                .alert("About This App", isPresented: $showAbout) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(
                        """
                               PassManager
                          CSC 680 Final Project
                                 © 2025 
                        Fernando Abel Malca Luque
                        Heber Josue Trujillo Cruz
                        """)
                }
            }
        }
        .navigationTitle("Settings")
    }

    private func authenticateToDisableBiometrics() {
        let ctx = LAContext()
        var error: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        else {
            vm.useBiometrics = false
            return
        }

        ctx.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: "Authenticate to disable biometrics"
        ) { success, _ in
            DispatchQueue.main.async {
                if success {
                    vm.useBiometrics = false
                } else {
                    requireAuthError = true
                }
            }
        }
    }
}
