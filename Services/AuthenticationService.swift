//
//  AuthenticationService.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import LocalAuthentication

struct AuthenticationService {
    static func authenticateUser(reason: String = "Authenticate") async -> Bool
    {
        if !SettingsService.shared.settings.useBiometrics {
            return true
        }

        let ctx = LAContext()
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        else {
            return true
        }
        return
            (try? await ctx.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: reason)) ?? false
    }
}
