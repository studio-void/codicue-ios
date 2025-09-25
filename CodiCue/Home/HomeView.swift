//
//  HomeView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/21/25.
//

import SwiftUI
import SwiftyJSON
import VoidUtilities

struct HomeView: View {
    @State var condition: String = ""
    @State var isLoading: Bool = true
    @State var stylists: [StylistInfo] = []
    var body: some View {
        NavigationView {
            VStack {
                TextField("상황을 알려주시면 스타일링해드립니다!", text: $condition)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom, 8)
                if condition != "" {
                    ScrollView(.horizontal) {
                        HStack {
                            ConditionChipView(label: "MOOD")
                            ConditionChipView(label: "OOTD")
                        }
                    }
                    .padding(.bottom, 8)
                }
                ScrollView(.horizontal) {
                    if stylists.isEmpty || isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        HStack(spacing: 24) {
                            ForEach(stylists) { stylist in
                                NavigationLink(destination: StylistInfoView(stylist: stylist)) {
                                    HomeStylistCardView(
                                        imageURL: URL(string: stylist.profileImageUrl),
                                        name: stylist.name,
                                        rating: stylist.rating,
                                        descriptions: stylist.career,
                                        isVerified: stylist.isVerified
                                    )
                                }
                                .tint(.primary)
                            }
                        }
                        .padding()
                    }
                }
                .background(isLoading ? Color.clear : Color("lightPink"))
                .task { await loadStylists() }
                Spacer()
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

struct ConditionChipView: View {
    var label: String = "MOOD"
    var body: some View {
        Text("#\(label)")
            .padding(8)
            .foregroundStyle(Color("primaryColor"))
            .background(Color("primaryColor").opacity(0.2))
            .clipShape(Capsule())
    }
}

#Preview {
    StructureView()
}
