//
//  SearchBarView.swift
//  CodiCue
//
//  Created by Yeeun on 9/21/25.
//

import SwiftUI

public struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    var onSubmit: (() -> Void)?
    var onTapIcon: (() -> Void)?

    public init(
        text: Binding<String>,
        placeholder: String,
        onSubmit: (() -> Void)? = nil,
        onTapIcon: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
        self.onTapIcon = onTapIcon
    }

    public var body: some View {
        HStack(spacing: 10) {
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }

            Button {
                onTapIcon?() ?? onSubmit?()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
        )
    }
}
