//
//  Settings.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import Foundation

struct Settings: Codable {
    var useBiometrics: Bool = true
    var autoLockInterval: TimeInterval = 60
    var sortAZ: Bool = true
}
