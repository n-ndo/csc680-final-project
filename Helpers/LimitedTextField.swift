//
//  LimitedText.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque


import SwiftUI
import UIKit

struct LimitedTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let font: UIFont
    let maxLength: Int

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.delegate = context.coordinator
        tf.placeholder = placeholder
        tf.font = font
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: LimitedTextField

        init(_ parent: LimitedTextField) {
            self.parent = parent
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let current = textField.text ?? ""
            guard let r = Range(range, in: current) else { return false }
            let updated = current.replacingCharacters(in: r, with: string)
                .replacingOccurrences(of: "\t", with: "")
            if updated.count <= parent.maxLength {
                parent.text = updated
            }
            return false
        }
    }
}
