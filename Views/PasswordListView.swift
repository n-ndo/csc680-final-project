//
//  PasswordListView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque
//  UI Designed by Heber Josue Trujillo Cruz

import CoreData
import SwiftUI

struct PasswordListView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var settingsService: SettingsService

    @State private var showAdd = false
    @State private var showSettings = false
    @State private var showTools = false

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Entry.title, ascending: true)
        ],
        animation: .default
    )

    private var entries: FetchedResults<Entry>

    private var favoriteEntries: [Entry] {
        let favs = entries.filter(\.isFavorite)
        return settingsService.settings.sortAZ ? favs : favs.reversed()
    }

    private var groupedOther: [(letter: String, entries: [Entry])] {
        let others = entries.filter { !$0.isFavorite }
        let ordered =
            settingsService.settings.sortAZ ? others : others.reversed()
        let groups = Dictionary(grouping: ordered) {
            String($0.title?.first ?? "#").uppercased()
        }
        return
            groups
            .map { (letter: $0.key, entries: $0.value) }
            .sorted {
                settingsService.settings.sortAZ ? $0.0 < $1.0 : $0.0 > $1.0
            }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Favorites") {
                    ForEach(favoriteEntries) { entry in
                        NavigationLink(
                            destination: PasswordDetailView(entry: entry)
                        ) {
                            entryRow(for: entry)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listRowSeparator(.hidden)

                Section("All Passwords") {
                    ForEach(groupedOther, id: \.letter) { group in
                        Text(group.letter)
                            .font(.subheadline).bold()
                            .foregroundColor(.secondary)
                            .padding(.vertical, 4)
                            .listRowSeparator(.visible, edges: .bottom)

                        ForEach(group.entries) { entry in
                            NavigationLink(
                                destination: PasswordDetailView(entry: entry)
                            ) {
                                entryRow(for: entry)
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("My Saved Passwords")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        showTools = true
                    } label: {
                        Image(systemName: "hammer.fill")
                    }
                    Spacer()
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    Spacer()
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: $showAdd) {
                AddPasswordView()
                    .environment(\.managedObjectContext, context)
            }
            .navigationDestination(isPresented: $showTools) {
                PasswordToolsView()
                    .environmentObject(settingsService)
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
                    .environment(\.managedObjectContext, context)
                    .environmentObject(settingsService)
            }
            .navigationDestination(for: Entry.self) { entry in
                PasswordDetailView(entry: entry)
            }
        }
    }

    @ViewBuilder
    private func entryRow(for entry: Entry) -> some View {
        HStack(spacing: 12) {
            Image(systemName: entry.icon ?? "lock.shield")
                .frame(width: 32, height: 32)
            Text(entry.title ?? "")
                .font(.headline)
            Spacer()
            Button {
                entry.isFavorite.toggle()
                try? context.save()
            } label: {
                Image(systemName: entry.isFavorite ? "star.fill" : "star")
                    .foregroundColor(entry.isFavorite ? .yellow : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 8)
    }
}
