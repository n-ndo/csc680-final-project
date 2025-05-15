//
//  PasswordDetailView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque
//  UI Designed by Heber Josue Trujillo Cruz

import CoreData
import SwiftUI

struct PasswordDetailView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm: PasswordDetailViewModel
    @State private var editing = false

    private let entry: Entry

    init(entry: Entry) {
        self.entry = entry
        _vm = StateObject(wrappedValue: PasswordDetailViewModel(entry: entry))
    }

    var body: some View {
        VStack(spacing: 24) {
            if vm.revealPassword {
                Text(vm.password)
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.vertical)
            } else {
                Button("Reveal Password") {
                    Task { await vm.authenticateAndReveal() }
                }
                .buttonStyle(.borderedProminent)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Notes:")
                    .font(.headline)
                Text(vm.notes.isEmpty ? "No notes." : vm.notes)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()

            Text(
                vm.updatedAt != nil
                    ? "Updated: "
                        + vm.updatedAt!.formatted(
                            date: .omitted, time: .shortened)
                    : "Created: "
                        + (vm.createdAt?.formatted(
                            date: .omitted, time: .shortened) ?? "")
            )
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.bottom, 16)
        }
        .navigationTitle(vm.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editing = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Delete this entry?", isPresented: $vm.showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await vm.delete(context: context)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $editing) {
            EditPasswordView(entry: entry)
                .environment(\.managedObjectContext, context)
        }
    }
}
