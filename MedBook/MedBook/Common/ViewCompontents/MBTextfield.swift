//
//   MBTextfield.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

struct MBTextfield: View {
    let heading: LocalizedStringKey
    let placeholder: LocalizedStringKey
    var isSecureField: Bool = false
    @Binding var textField: String
    @State private var hideTextfield: Bool = true
    var shouldShowRightImage: Bool = false
    let rightItemImage: String = "filemenu.and.selection"
    var isTextFieldInputDisabled: Bool = false
    var keyboardType: UIKeyboardType = .default
    var validation: ((String, Bool) -> Bool)? = nil
    var errorMessage: LocalizedStringKey? = ""
    var maxLength: Int? = nil
    @State private var isValid: Bool = true
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            VStack(alignment: .leading, spacing: 8.0) {
                Text(heading)
                    .font(.system(size: 18.0))
                if hideTextfield {
                    TextField(placeholder, text: $textField,
                              onEditingChanged: { isEditing in
                        self.isEditing = isEditing
                    })
                    .padding(.all, 4)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(keyboardType)
                    .disabled(isTextFieldInputDisabled)
                    .focused($isFocused)
                    .onChange(of: isFocused, { _, _ in
                        if let validationToPreform = validation {
                            isValid = validationToPreform(textField, isEditing)
                        }
                    })
                    .onChange(of: textField) { _, newValue in
                        if let validationToPreform = validation {
                            isValid = validationToPreform(textField, isEditing)
                        }
                        if let maxLength = maxLength,
                           newValue.count > maxLength {
                            textField = String(newValue.prefix(maxLength))
                            isValid = false // Invalidate if exceeded max length
                        }
                    }
                    .overlay(alignment: .trailing) {
                        if isSecureField {
                            Button {
                                hideTextfield.toggle()
                            } label: {
                                if !hideTextfield {
                                    Image(systemName: "eye.slash")
                                        .foregroundStyle(.gray)
                                } else {
                                    Image(systemName: "eye")
                                        .foregroundStyle(.gray)
                                }
                            }
                            .padding(.horizontal, 8.0)
                        } else {
                            if shouldShowRightImage {
                                Image(systemName: rightItemImage)
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 8.0)
                            }
                        }
                    }
                    
                    
                } else {
                    SecureField(placeholder, text: $textField)
                        .padding(.all, 4)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.leading)
                        .disabled(isTextFieldInputDisabled)
                        .keyboardType(keyboardType)
                        .focused($isFocused)
                        .onChange(of: isFocused, { _, _ in
                            if isFocused {
                                isEditing = true
                            } else {
                                isEditing = false
                            }
                            if let validationToPreform = validation {
                                isValid = validationToPreform(textField, isEditing)
                            }
                        })
                        .onChange(of: textField) { _, newValue in
                            if let validationToPreform = validation {
                                isValid = validationToPreform(textField, isEditing)
                            }
                            if let maxLength = maxLength,
                               newValue.count > maxLength {
                                textField = String(newValue.prefix(maxLength))
                                isValid = false // Invalidate if exceeded max length
                            }
                        }
                        .overlay(alignment: .trailing) {
                            Button {
                                hideTextfield.toggle()
                            } label: {
                                if !hideTextfield {
                                    Image(systemName: "eye.slash")
                                        .foregroundStyle(.gray)
                                } else {
                                    Image(systemName: "eye")
                                        .foregroundStyle(.gray)
                                }
                            }
                            .padding(.horizontal, 8.0)
                        }
                }
              
            }
            if !isValid {
                Text(errorMessage ?? "")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
       
        .onAppear {
            hideTextfield = !isSecureField
        }
    }
}

#Preview {
     MBTextfield(heading: "email_address",
                 placeholder: "email_address",
                 textField: .constant(" @gmail.com"),
                 shouldShowRightImage: true,
                 isTextFieldInputDisabled: true,
                 validation: { _, _ in return true},
                 errorMessage: "error" )
}
