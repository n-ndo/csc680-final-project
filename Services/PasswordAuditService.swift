//
//  PasswordAudit.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import SwiftUI

struct PasswordAuditService {
    static func strength(_ password: String) -> Int {
        var score = min(password.count * 2, 40)
        let digits = password.filter(\.isNumber).count
        let symbols = password.filter { "!@#$%^&*()_$^".contains($0) }.count
        let uppercase = password.filter(\.isUppercase).count
        score += min(digits * 4, 20)
        score += min(symbols * 4, 20)
        score += min(uppercase * 2, 20)
        return min(score, 100)
    }
}
