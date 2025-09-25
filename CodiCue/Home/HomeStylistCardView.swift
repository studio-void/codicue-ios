//
//  HomeStylistCardView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/22/25.
//

import SDWebImageSwiftUI
import SwiftUI
import VoidUtilities

struct HomeStylistCardView: View {
    @State var imageURL: URL? = URL(
        string:
            "https://i.namu.wiki/i/plYksH3UeGGZLVgjTfbJ8rf1vN2HMIl9ztcpxtfpeQwCYR1CBh3SzbQ0RsgbZ65xiYR-fk7A3Dxy7cExs4rABQ.webp"
    )
    @State var name: String
    @State var rating: Double
    @State var descriptions: [String]
    @State var isVerified: Bool = false
    @State private var isLoading: Bool = true
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                WebImage(url: imageURL)
                    .onProgress { received, total in
                        isLoading = true
                    }
                    .onSuccess { _, _, _ in
                        isLoading = false
                    }
                    .onFailure { _ in
                        isLoading = false
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                    )
                    .overlay {
                        if isLoading {
                            ZStack {
                                RoundedRectangle(
                                    cornerRadius: 32,
                                    style: .continuous
                                )
                                .fill(.ultraThinMaterial)
                                ProgressView()
                            }
                        }
                    }
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text("스타일리스트")
                        .padding(.bottom, 2)
                    HStack {
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.gray400)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.bottom, 8)

            HStack(spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill").foregroundStyle(.yellow)
                    Text(String(format: "%.2f", rating)).font(.headline)
                    Text("/ 5.0").foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }
            ForEach(descriptions, id: \.self) { description in
                bullet(description)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 4, y: 4)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            // The dot is vertically centered to approximately the first line height
            Circle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 4, height: 4)
                .padding(.top, 6)  // approximate half of a subheadline line height
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    HomeStylistCardView(
        name: "장원영",
        rating: 4.93,
        descriptions: ["서울 플라시 어워드 금상", "포브스 선정 올해의 스타일리스트", "(현) 연예인 스타일리스트"]
    )
}
