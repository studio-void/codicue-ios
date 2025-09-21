//
//  StylistMainView.swift
//  CodiCue
//
//  Created by Yeeun on 9/21/25.
//

import SwiftUI

struct Stylist: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let isVerified: Bool
}

let sampleStylists: [Stylist] = [
    .init(name: "장원영", rating: 4.93, isVerified: true),
    .init(name: "설 윤", rating: 4.99, isVerified: false),
    .init(name: "김지우", rating: 4.74, isVerified: true),
    .init(name: "아이유", rating: 4.57, isVerified: false),
]

struct StylistMainView: View {
    @State private var query: String = ""

    var filtered: [Stylist] {
        let q = query.trimmingCharacters(in: .whitespaces)
        return q.isEmpty
        ? sampleStylists
        : sampleStylists.filter { $0.name.localizedCaseInsensitiveContains(q) }
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 5)
            
            SearchBar(
                text: $query,
                placeholder: "원하시는 스타일리스트를 검색하세요",
                onSubmit: { }
            )

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filtered) { stylist in
                        StylistCard(stylist: stylist)
                    }
                }
                .padding(.bottom, 12)
            }
        }
    }
}

struct StylistCard: View {
    let stylist: Stylist

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.white
                Text("🧑")
                    .font(.system(size: 40))
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 8) {
                Text("스타일리스트")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    Text(stylist.name).font(.title3.bold())
                    if stylist.isVerified {
                        if UIImage(named: "verified") != nil {
                            Image("verified")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 18)
                        } else {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.2f", stylist.rating))
                        .font(.headline)
                    Text("/ 5.0")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
        )
    }
}

#Preview { StructureView() }
