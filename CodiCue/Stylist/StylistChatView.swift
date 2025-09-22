//
//  StylistChatView.swift
//  CodiCue
//
//  Created by Yeeun on 9/22/25.
//

import SwiftUI

struct StylistChatView: View {
    let stylistName: String
    @Environment(\.dismiss) private var dismiss
    @State private var input: String = ""
    @State private var messages: [ChatMessage] = ChatMessage.mock

    private let suggestInsertAfterIndex: Int = 2

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(messages.enumerated()), id: \.element.id) { idx, msg in
                            ChatBubble(message: msg)
                                .id(msg.id)

//                            if idx == suggestInsertAfterIndex {
//                                SuggestSection()
//                            }
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
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: -3)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(spacing: 12) {
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

            Button(action: {}) {
                Text("완료")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("primaryColor"))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

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

struct SuggestSection: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ProductCard(title: "아이보리 하프팬츠", tags: ["#아이보리", "#팬츠"])
                ProductCard(title: "블랙 하프팬츠", tags: ["#쿨톤", "#반바지"])
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
    }
}

struct ProductCard: View {
    let title: String
    let tags: [String]

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                Text("👖").font(.system(size: 40))
            }
            .frame(width: 140, height: 140)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(1)

            HStack(spacing: 6) {
                ForEach(tags, id: \.self) { tag in
                    TagChip(text: tag)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("primaryColor").opacity(0.15))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
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
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
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
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("primaryColor"))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    StylistChatView(stylistName: "장원영")
}
