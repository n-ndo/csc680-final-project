//
//  PasswordGenerator.swift
//  csc680-final-project
//
//  By Fernando Malca on 5/8/25.
//

import Foundation

struct PasswordGenerator {
    static func randomPassword(
        length: Int,
        uppercase: Bool,
        lowercase: Bool,
        numbersCount: Int,
        symbolsCount: Int
    ) -> String {
        var chars: [Character] = []

        let lowercaseLetters = Array("abcdefghijklmnopqrstuvwxyz")
        let uppercaseLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let numbers = Array("0123456789")
        let symbols = Array("!@#$%^&*()_$^")

        for _ in 0..<min(symbolsCount, length) {
            chars.append(symbols.randomElement()!)
        }

        let maxNum = min(numbersCount, length - chars.count)
        for _ in 0..<maxNum {
            chars.append(numbers.randomElement()!)
        }

        var letterPool: [Character] = []
        if lowercase { letterPool += lowercaseLetters }
        if uppercase { letterPool += uppercaseLetters }

        let remaining = length - chars.count
        for _ in 0..<remaining {
            if let c = letterPool.randomElement() {
                chars.append(c)
            }
        }

        return String(chars.shuffled())
    }
}
