//
//  StylistChatView.swift
//  CodiCue
//
//  Created by Yeeun on 9/22/25.
//

import SwiftUI

struct StylistChatView: View {
    let stylistName: String
    var onFinish: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var input: String = ""
    @State private var messages: [ChatMessage] = ChatMessage.mock

    @State private var showReview: Bool = false
    @State private var reviewRating: Int = 0
    @State private var reviewText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            header

            Rectangle().fill(.clear).frame(height: 12)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(messages.enumerated()), id: \.element.id) { _, msg in
                            ChatBubble(message: msg).id(msg.id)
                        }
                    }
                }
                .onChange(of: messages.count) { _ in
                    if let last = messages.last?.id {
                        withAnimation { proxy.scrollTo(last, anchor: .bottom) }
                    }
                }
            }

            inputBar
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if showReview {
                GeometryReader { geo in
                    ReviewSheet(
                        stylistName: stylistName,
                        rating: $reviewRating,
                        text: $reviewText,
                        onSubmit: { finishFlow() },
                        onClose: { showReview = false }
                    )
                    .frame(width: min(geo.size.width * 0.92, 520))
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.28, dampingFraction: 0.9), value: showReview)
                }
                .ignoresSafeArea()
                .zIndex(1)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black)
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(stylistName)
                    .font(.system(size: 24, weight: .bold))
                if UIImage(named: "verified") != nil {
                    Image("verified")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                } else {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.blue)
                        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                }
            }

            Spacer(minLength: 0)

            Button(action: { showReview = true }) {
                Text("완료")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("primaryColor"))
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private func finishFlow() {
        if let onFinish {
            onFinish()
        } else {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                dismiss()
            }
        }
    }
}

// MARK: - Models

struct ChatMessage: Identifiable {
    enum Role { case stylist, user }
    let id = UUID()
    let role: Role
    let text: String

    static let mock: [ChatMessage] = [
        .init(role: .stylist, text: "안녕하세요, 스타일리스트 장원영입니다! 원하는 코디를 알려주세요."),
        .init(role: .user, text: "안녕하세요, 스타일리스트님! 대학 친구가 주선해 준 미팅을 나가게 되었는데 어떤 옷을 입을지 추천해주세요!"),
        .init(role: .stylist, text: "안녕하세요, XXX님! XXX님의 옷장을 둘러본 결과, 아래와 같은 코디를 해보는 것은 어떤가요?")
    ]
}

// MARK: - Chat UI

struct ChatBubble: View {
    let message: ChatMessage
    var isMe: Bool { message.role == .user }

    private var bubble: some View {
        Text(message.text)
            .font(.body)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isMe ? Color.pink.opacity(0.2) : Color("Gray"))
            )
            .foregroundStyle(.primary)
            .frame(maxWidth: 280, alignment: isMe ? .trailing : .leading)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isMe { Spacer(minLength: 24) }
            bubble
            if !isMe { Spacer(minLength: 24) }
        }
    }
}

struct TagChip: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
            )
    }
}

private extension StylistChatView {
    var inputBar: some View {
        HStack(spacing: 10) {
            TextField("메시지를 입력하세요", text: $input, axis: .vertical)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(Color.white)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.12), lineWidth: 1)
                    }
                )

            Button {
                let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                messages.append(.init(role: .user, text: trimmed))
                input = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("primaryColor"))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Review Popup (centered, adaptive width)

struct ReviewSheet: View {
    let stylistName: String
    @Binding var rating: Int
    @Binding var text: String
    var onSubmit: () -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                Text(stylistName).font(.headline).bold()
                if UIImage(named: "verified") != nil {
                    Image("verified").resizable().frame(width: 16, height: 16)
                } else {
                    Image(systemName: "checkmark.seal.fill").foregroundStyle(.blue)
                }
                Text("님과의 상담은 어땠나요?").font(.headline)
            }

            StarRating(rating: $rating)

            TextField("원하시면 리뷰를 입력하세요", text: $text)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(Color.white)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    }
                )

            Button(action: onSubmit) {
                Text("상담 종료")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color("primaryColor"))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: -4)
        )
        .padding(.horizontal, 16)
    }
}

struct StarRating: View {
    @Binding var rating: Int
    private let max = 5

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...max, id: \.self) { i in
                Image(systemName: i <= rating ? "star.fill" : "star")
                    .foregroundStyle(i <= rating ? Color.starYellow : Color.gray.opacity(0.6))
                    .font(.system(size: 22))
                    .onTapGesture { rating = i }
            }
        }
    }
}

#Preview {
    StylistChatView(stylistName: "장원영")
}
