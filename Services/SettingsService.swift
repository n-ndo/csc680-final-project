//
//  SettingsService.swift
//  csc680-final-project
//
//  By Fernando Malca on 5/8/25.
//
import Foundation

class SettingsService: ObservableObject {
    static let shared = SettingsService()
    @Published var settings: Settings

    private let key = "app_settings"
    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
            let s = try? JSONDecoder().decode(Settings.self, from: data)
        {
            settings = s
        } else {
            settings = Settings()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
