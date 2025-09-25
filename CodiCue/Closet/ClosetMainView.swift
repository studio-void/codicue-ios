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



struct ClosetMainView: View {
    @State private var items: [Garment] = []
    @State private var showingAdd = false
    @State private var isLoading = false

    private var grouped: [GarmentCategory: [Garment]] {
        Dictionary(grouping: items, by: { $0.category })
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("나의 옷장")
                                .font(.title3.bold())
                            Spacer()
                        }
                        if isLoading {
                            ProgressView()
                        } else {
                            if items.isEmpty {
                                Text("옷장이 비었습니다. 추가해 보세요!")
                            } else {
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
                                        
                                        GarmentRow(items: rows)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .task{ await loadCloset() }
                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
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
                }
            }
            .toolbar(.visible, for: .tabBar)
        }
    }
    
    @MainActor
    private func loadCloset() async {
        isLoading = true
        let result = await fetchClothes()
        items = result
        isLoading = false
    }
}

private struct GarmentRow: View {
    let items: [Garment]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(items) { g in
                    NavigationLink {
                        ClosetDetailsView(garment: g)
                    } label: {
                        GarmentCard(garment: g)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 2)
        }
    }
}



private struct GarmentCard: View {
    let garment: Garment
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
                        .scaledToFill()
                        .frame(width: 140, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    Text("👕").font(.system(size: 40))
                }
            }
            .frame(height: 120)
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
                .font(.callout)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 36)

            HStack(spacing: 6) {
                ForEach(garment.tags.prefix(2), id: \.self) { t in
                    ClosetPill(text: t)
                }
            }
            .frame(height: 28)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("primaryColor").opacity(0.15))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
        ).frame(width: 140)
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

#Preview {
    ClosetMainView()
}
