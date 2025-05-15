//
//  LockScreenView.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import LocalAuthentication
import SwiftUI

struct LockScreenView: View {
    @Binding var isUnlocked: Bool

    var body: some View {
        VStack {
            Text("Unlocking…")
                .font(.largeTitle)
                .padding()
        }
        .task {
            await authenticate()
        }
    }

    func authenticate() async {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        var error: NSError?

        guard
            context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        else {
            return
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Unlock to view your passwords"
            )
            if success {
                await MainActor.run {
                    isUnlocked = true
                }
            }
        } catch {
            print("Auth failed: \(error.localizedDescription)")
        }
    }
}
