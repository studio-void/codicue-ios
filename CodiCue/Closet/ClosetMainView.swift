//
//  ClosetMainView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI
import SDWebImageSwiftUI

enum GarmentCategory: String, CaseIterable, Identifiable, Codable {
    case top = "TOP"
    case bottom = "BOTTOM"
    case shoes = "SHOES"
    case accessory = "ACCESSORY"
    var id: String { rawValue }

    /// For section headers in Korean UI
    var displayName: String {
        switch self {
        case .top: return "상의"
        case .bottom: return "하의"
        case .shoes: return "신발"
        case .accessory: return "액세서리"
        }
    }
}

enum BodyType: String, Codable, CaseIterable {
    case rectangle = "RECTANGLE"
    case hourglass = "HOURGLASS"
    case triangle = "TRIANGLE"
    case invertedTriangle = "INVERTED_TRIANGLE"
    case oval = "OVAL"
}

struct Garment: Identifiable, Codable {
    // API fields
    let id: Int
    let userId: Int
    let name: String
    let category: GarmentCategory
    let imageURL: String
    let recommendedBodyType: [BodyType]
    let advice: String?
    let tags: [String]
    let createdAt: Date
    let updatedAt: Date

    // CodingKeys to map imageUrl -> imageURL
    enum CodingKeys: String, CodingKey {
        case id, userId, name, category, recommendedBodyType, advice, tags, createdAt, updatedAt
        case imageURL = "imageUrl"
    }
}

extension Garment {
    static let mock: [Garment] = [
        .init(
            id: 1,
            userId: 1,
            name: "화이트 셔츠",
            category: .top,
            imageURL: "https://example.com/image.jpg",
            recommendedBodyType: [.rectangle, .hourglass],
            advice: "깔끔한 비즈니스 룩에 적합합니다.",
            tags: ["비즈니스", "깔끔", "화이트"],
            createdAt: ISO8601DateFormatter().date(from: "2024-01-01T00:00:00.000Z") ?? Date(),
            updatedAt: ISO8601DateFormatter().date(from: "2024-01-01T00:00:00.000Z") ?? Date()
        ),
        .init(
            id: 2,
            userId: 1,
            name: "아이보리 하프팬츠",
            category: .bottom,
            imageURL: "https://i.namu.wiki/i/plYksH3UeGGZLVgjTfbJ8rf1vN2HMIl9ztcpxtfpeQwCYR1CBh3SzbQ0RsgbZ65xiYR-fk7A3Dxy7cExs4rABQ.webp",
            recommendedBodyType: [.rectangle],
            advice: nil,
            tags: ["아이보리", "팬츠"],
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
}

private struct ClosetCardLayout {
    let cardWidth: CGFloat
    let imageH: CGFloat
    let titleH: CGFloat
    let tagsH: CGFloat

    static func `for`(_ sizeClass: UserInterfaceSizeClass?) -> Self {
        if sizeClass == .regular {
            return .init(cardWidth: 170, imageH: 140, titleH: 40, tagsH: 30)
        } else {
            return .init(cardWidth: 140, imageH: 120, titleH: 36, tagsH: 28)
        }
    }
}

struct ClosetMainView: View {
    @State private var items: [Garment] = Garment.mock
    @State private var showingAdd = false
    @Environment(\.horizontalSizeClass) private var hSize

    private var grouped: [GarmentCategory: [Garment]] {
        Dictionary(grouping: items, by: { $0.category })
    }

    var body: some View {
        let layout = ClosetCardLayout.for(hSize)

        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("나의 옷장")
                        .font(.title3.bold())

                    ForEach(GarmentCategory.allCases) { cat in
                        if let rows = grouped[cat], !rows.isEmpty {
                            HStack {
                                Text(cat.displayName)
                                    .font(.headline.weight(.semibold))
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.1))
                            )
                            .padding(.vertical, 4)

                            GarmentRow(items: rows, layout: layout)
                        }
                    }
                }
                .padding(.bottom, 72)
            }

            Button {
                showingAdd = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color("primaryColor")))
                    .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 4)
            .padding(.bottom, 20)
            .sheet(isPresented: $showingAdd) {
                Text("옷장에 옷 추가하기 (준비 중)")
                    .font(.headline)
                    .padding()
            }
        }
        .toolbar(.visible, for: .tabBar)
    }
}

private struct GarmentRow: View {
    let items: [Garment]
    let layout: ClosetCardLayout
    @State private var maxHeight: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(items) { g in
                    NavigationLink {
                        ClosetDetailsView(garment: g)
                    } label: {
                        GarmentCard(garment: g, layout: layout)
                    }
                    .buttonStyle(.plain)
                    .background(HeightReporter())
                }
            }
        }
        .onPreferenceChange(EqualHeightKey.self) { maxHeight = $0 }
        .frame(height: maxHeight == 0 ? nil : maxHeight)
    }
}

private struct HeightReporter: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: EqualHeightKey.self, value: geo.size.height)
        }
    }
}
private struct EqualHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct GarmentCard: View {
    let garment: Garment
    let layout: ClosetCardLayout
    @State private var isImageLoading: Bool = true

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)

                if let url = URL(string: garment.imageURL) {
                    WebImage(url: url)
                        .onProgress { _, _ in
                            isImageLoading = true
                        }
                        .onSuccess { _, _, _ in
                            isImageLoading = false
                        }
                        .onFailure { _ in
                            isImageLoading = false
                        }
                        .resizable()
                        .scaledToFit()
                        .padding(18)
                } else {
                    Text("👕").font(.system(size: 40))
                }
            }
            .frame(height: layout.imageH)
            .overlay {
                if isImageLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial)
                        ProgressView()
                    }
                }
            }

            Text(garment.name)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: layout.titleH)

            HStack(spacing: 6) {
                ForEach(garment.tags.prefix(2), id: \.self) { t in
                    ClosetPill(text: t)
                }
            }
            .frame(height: layout.tagsH)
        }
        .padding(10)
        .frame(width: layout.cardWidth)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("primaryColor").opacity(0.15))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
        )
    }
}

private struct ClosetPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .frame(height: 24)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
    }
}

struct ClosetPlaceholder: View {
    var body: some View {
        NavigationStack { ClosetMainView() }
    }
}

#Preview {
    ClosetPlaceholder()
}
