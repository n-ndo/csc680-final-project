//
//  PasswordToolsViewModel.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import Combine
import SwiftUI

class PasswordToolsViewModel: ObservableObject {
    static let maxAuditLength = 32

    @Published var length = 16
    @Published var lowercase = true
    @Published var uppercase = true
    @Published var numbersCount = 2
    @Published var symbolsCount = 2
    @Published var generatedPassword = ""
    @Published var auditPassword = ""
    @Published private(set) var strength = 0

    private var cancellables = Set<AnyCancellable>()

    init() {
        $auditPassword
            .map(PasswordAuditService.strength)
            .assign(to: \.strength, on: self)
            .store(in: &cancellables)
    }

    func generate() {
        generatedPassword = PasswordGenerator.randomPassword(
            length: length,
            uppercase: uppercase,
            lowercase: lowercase,
            numbersCount: numbersCount,
            symbolsCount: symbolsCount
        )
    }

    var strengthFraction: Double { Double(strength) / 100.0 }

    var qualityText: String {
        switch strength {
        case ..<30: return "Weak"
        case ..<60: return "Good"
        case ..<85: return "Strong"
        default: return "Very Strong"
        }
    }

    var colorForStrength: Color {
        switch strength {
        case ..<30: return .red
        case ..<60: return .orange
        case ..<85: return .yellow
        default: return .green
        }
    }
}
