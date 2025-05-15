//
//  CryptoService.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import CryptoKit
import Foundation

struct CryptoService {
    private static let key: SymmetricKey = {
        if let data = KeychainService.load(key: "encryption_key") {
            return SymmetricKey(data: data)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            let keyData = newKey.withUnsafeBytes { Data($0) }
            try? KeychainService.save(keyData, for: "encryption_key")
            return newKey
        }
    }()

    static func encrypt(_ plaintext: String) throws -> Data {
        let data = Data(plaintext.utf8)
        let sealedBox = try AES.GCM.seal(data, using: key)
        guard let combined = sealedBox.combined else {
            throw NSError(
                domain: "CryptoService",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to combine sealed box"
                ]
            )
        }
        return combined
    }

    static func decrypt(_ ciphertext: Data) throws -> String {
        let sealedBox = try AES.GCM.SealedBox(combined: ciphertext)
        let decrypted = try AES.GCM.open(sealedBox, using: key)
        return String(decoding: decrypted, as: UTF8.self)
    }
}
