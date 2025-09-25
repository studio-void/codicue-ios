//
//  ClosetMainView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI

enum GarmentCategory: String, CaseIterable, Identifiable {
    case top = "상의"
    case bottom = "하의"
    case shoes = "신발"
    case accessory = "신발 및 액세서리"
    var id: String { rawValue }
}

struct Garment: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String?
    let tags: [String]
    let category: GarmentCategory

    static let mock: [Garment] = [
        .init(
            title: "브리드 링클 체크 셔츠 차콜",
            imageName: nil,
            tags: ["#셔츠", "#체크무늬"],
            category: .top
        ),
        .init(
            title: "스트라이프 니트",
            imageName: nil,
            tags: ["#후드집업", "#니트"],
            category: .top
        ),
        .init(
            title: "아이보리 하프팬츠",
            imageName: nil,
            tags: ["#아이보리", "#팬츠"],
            category: .bottom
        ),
        .init(
            title: "블랙 트레이닝 반바지",
            imageName: nil,
            tags: ["#쿨톤", "#반바지"],
            category: .bottom
        ),
        .init(
            title: "더비슈즈 블랙",
            imageName: nil,
            tags: ["#포멀"],
            category: .shoes
        ),
        .init(
            title: "메탈 시계",
            imageName: nil,
            tags: ["#실버"],
            category: .accessory
        ),
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
                                Text(cat.rawValue)
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

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)

                if let name = garment.imageName, let ui = UIImage(named: name) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFit()
                        .padding(18)
                } else {
                    Text("👕").font(.system(size: 40))
                }
            }
            .frame(height: layout.imageH)

            Text(garment.title)
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
