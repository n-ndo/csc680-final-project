//
//  PasswordToolsView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque
//  UI Design by Fernando Abel Malca Luque

import SwiftUI

struct PasswordToolsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = PasswordToolsViewModel()
    @State private var showGenerator = true

    var body: some View {
        Form {
            Picker("", selection: $showGenerator) {
                Text("Generator").tag(true)
                Text("Audit").tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.vertical)

            if showGenerator {
                Section("Generator") {
                    Stepper(
                        "Length: \(vm.length)", value: $vm.length, in: 8...64
                    )
                    .padding(.vertical, 4)

                    Toggle("Include Lowercased", isOn: $vm.lowercase)
                    Toggle("Include Uppercased", isOn: $vm.uppercase)

                    Stepper(
                        "Include Digit(s): \(vm.numbersCount)",
                        value: $vm.numbersCount,
                        in: 0...vm.length
                    )
                    .padding(.vertical, 4)

                    Stepper(
                        "Include Symbol(s): \(vm.symbolsCount)",
                        value: $vm.symbolsCount,
                        in: 0...vm.length
                    )
                    .padding(.vertical, 4)

                    Button("Generate Password") {
                        vm.generate()
                    }
                    .padding(.vertical, 8)

                    HStack {
                        TextField(
                            "Generated Password", text: $vm.generatedPassword
                        )
                        .textSelection(.enabled)
                        .font(.system(.body, design: .monospaced))

                        Button(action: {
                            UIPasteboard.general.string = vm.generatedPassword
                        }) {
                            Image(systemName: "doc.on.doc")
                        }
                        .disabled(vm.generatedPassword.isEmpty)
                    }
                    .padding(.vertical, 4)
                }

            } else {
                Section("Audit") {
                    let filledBars = {
                        switch vm.strength {
                        case 1..<30: return 1
                        case 30..<60: return 2
                        case 60..<85: return 3
                        case 85...100: return 4
                        default: return 0
                        }
                    }()

                    HStack(spacing: 4) {
                        ForEach(0..<4) { i in
                            Rectangle()
                                .foregroundColor(
                                    i < filledBars
                                        ? vm.colorForStrength
                                        : Color.gray.opacity(0.3))
                        }
                    }
                    .frame(height: 8)
                    .cornerRadius(4)
                    .listRowSeparator(.hidden)

                    if filledBars > 0 {
                        Text(vm.qualityText)
                            .font(.subheadline.bold())
                            .foregroundColor(vm.colorForStrength)
                            .listRowSeparator(.hidden)
                            .padding(.bottom, 4)
                    }

                    LimitedTextField(
                        text: $vm.auditPassword,
                        placeholder: "Enter Password",
                        font: UIFont.monospacedSystemFont(
                            ofSize: UIFont.systemFontSize,
                            weight: .regular
                        ),
                        maxLength: PasswordToolsViewModel.maxAuditLength
                    )
                    .frame(height: 22)

                    Text(
                        "\(vm.auditPassword.count)/\(PasswordToolsViewModel.maxAuditLength)"
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
                }
            }
        }
        .navigationTitle("Password Tools")
    }
}
