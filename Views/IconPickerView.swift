//
//  IconPickerView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import SwiftUI

struct IconPickerView: View {
    let icons = [
        "lock", "globe", "creditcard", "bag", "star", "briefcase",
        "airplane", "shield", "key", "bookmark", "folder", "cloud",
    ]
    @Binding var selection: String
    @Environment(\.dismiss) var dismiss
    let cols = [GridItem(.adaptive(minimum: 50))]
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: cols, spacing: 20) {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .resizable().scaledToFit().frame(
                                width: 40, height: 40
                            )
                            .padding().background(
                                selection == icon
                                    ? Color.accentColor.opacity(0.2)
                                    : Color.clear
                            )
                            .cornerRadius(8)
                            .onTapGesture {
                                selection = icon
                                dismiss()
                            }
                    }
                }.padding()
            }
            .navigationTitle("Pick Icon")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
