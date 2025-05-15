//
//  ContentView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import SwiftUI

struct ContentView: View {
    var body: some View {
        PasswordListView()
          .environment(\.managedObjectContext,
                       PersistenceController.preview.container.viewContext)
          .environmentObject(SettingsService.shared)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
          .environment(\.managedObjectContext,
                       PersistenceController.preview.container.viewContext)
          .environmentObject(SettingsService.shared)
    }
}

