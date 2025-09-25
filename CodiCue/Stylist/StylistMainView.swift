//
//  StylistMainView.swift
//  CodiCue
//
//  Created by Yeeun on 9/21/25.
//

import SwiftUI

struct StylistMainView: View {
    @State var isLoading: Bool = true
    @State private var query: String = ""
    
    @State var stylists: [Stylist] = []

    var filtered: [Stylist] {
        let q = query.trimmingCharacters(in: .whitespaces)
        return q.isEmpty
            ? stylists
            : stylists.filter {
                $0.name.localizedCaseInsensitiveContains(q)
            }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                SearchBar(
                    text: $query,
                    placeholder: "원하시는 스타일리스트를 검색하세요",
                    onSubmit: {}
                )

                ScrollView {
                    VStack(spacing: 16) {
                        if isLoading {
                            ProgressView()
                        } else {
                            ForEach(filtered) { stylist in
                                NavigationLink(destination: StylistInfoView(stylist: stylist)) {
                                    StylistCard(stylist: stylist)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.bottom, 12)
                }
                .task { await loadStylists() }
            }
        }
    }
    
    @MainActor
    private func loadStylists() async {
        isLoading = true
        let result = await fetchStylists()
        stylists = result
        isLoading = false
    }
}

struct StylistCard: View {
    let stylist: Stylist

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.white
                Text("🧑").font(.system(size: 40))
            }
            .frame(width: 88, height: 88)
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
                            Image("verified").resizable().scaledToFit().frame(
                                height: 18
                            )
                        } else {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: "star.fill").foregroundStyle(.yellow)
                    Text(String(format: "%.2f", stylist.rating)).font(.headline)
                    Text("/ 5.0").foregroundStyle(.secondary)
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
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 12,
                    x: 0,
                    y: 6
                )
        )
    }
}

#Preview { StylistMainView() }
#Preview { StructureView() }
