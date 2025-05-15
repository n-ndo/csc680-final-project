//
//  SettingsViewModel.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque, Heber Josue Trujillo Cruz

import CoreData
import Foundation
import LocalAuthentication

class SettingsViewModel: ObservableObject {
    @Published var useBiometrics: Bool {
        didSet {
            SettingsService.shared.settings.useBiometrics = useBiometrics
            SettingsService.shared.save()
        }
    }

    @Published var autoLockInterval: TimeInterval {
        didSet {
            SettingsService.shared.settings.autoLockInterval = autoLockInterval
            SettingsService.shared.save()
        }
    }

    init() {
        let s = SettingsService.shared.settings
        useBiometrics = s.useBiometrics
        autoLockInterval = s.autoLockInterval
    }

    func deleteAllPasswords(
        context: NSManagedObjectContext,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let laContext = LAContext()
        let policy: LAPolicy = .deviceOwnerAuthentication

        laContext.evaluatePolicy(
            policy,
            localizedReason: "Authenticate to delete all passwords"
        ) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.performDeleteLoop(in: context, completion: completion)
                } else {
                    completion(
                        .failure(
                            error ?? NSError(domain: "AuthFailed", code: -1)))
                }
            }
        }
    }

    private func performDeleteLoop(
        in context: NSManagedObjectContext,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        context.perform {
            let fetch: NSFetchRequest<Entry> = Entry.fetchRequest()
            do {
                let all = try context.fetch(fetch)
                all.forEach(context.delete)
                try context.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}
