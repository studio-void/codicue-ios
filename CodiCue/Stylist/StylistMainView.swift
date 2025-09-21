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
    Stylist(name: "장원영", rating: 4.93, isVerified: true),
    Stylist(name: "설 윤", rating: 4.99, isVerified: false),
    Stylist(name: "김지우", rating: 4.74, isVerified: true),
    Stylist(name: "아이유", rating: 4.57, isVerified: false),
]

struct StylistMainView: View {
    @State private var query: String = ""
    @State private var coin: Int = 213

    var filtered: [Stylist] {
        let q = query.trimmingCharacters(in: .whitespaces)
        return q.isEmpty ? sampleStylists : sampleStylists.filter { $0.name.contains(q) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                VStack(spacing: 16) {
                    searchBar
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filtered) { stylist in
                                StylistCard(stylist: stylist)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                }
                .padding(.top, 8)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            TextField("원하시는 스타일리스트를 검색하세요", text: $query)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
    }
}

struct StylistCard: View {
    let stylist: Stylist

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Color.gray.opacity(0.2)
                Text("🧑")
                    .font(.system(size: 40))
            }
            .frame(width: 88, height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 10) {
                Text("스타일리스트")
                    .font(.subheadline)
                    .foregroundStyle(.black)
                HStack(spacing: 6) {
                    Text(stylist.name).font(.title3.bold())
                    if stylist.isVerified {
                        Image(systemName: "checkmark.seal.fill").foregroundStyle(.blue)
                    }
                }
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.2f", stylist.rating)).font(.headline)
                    Text("/ 5.0").foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
        )
    }
}

#Preview {
    StructureView()
}
