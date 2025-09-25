//
//  ClosetDetailsView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SDWebImageSwiftUI
import SwiftUI
import VoidUtilities

struct ClosetDetailsView: View {
    let garment: Garment

    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                    WebImage(url: URL(string: garment.imageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                Text(garment.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)

                if garment.advice != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("착용 조언")
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)
                        HStack {
                            Text(
                                garment.advice!
                            )
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.top, 8)
                }
            }
            Spacer()

            if let url = URL(string: garment.imageURL) {
                ShareLink(
                    item: url,
                    message: Text("CodiCue에서 \(garment.name)을(를) 만나보세요!")
                ) {
                    VoidButtonView(.primary, label: "친구에게 공유하기", icon: "square.and.arrow.up", tintColor: Color("primaryColor"))
                }
            }
        }
        .padding(.top, 20)
        .navigationTitle("옷 상세정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ClosetDetailsView(
        garment: Garment(
            id: 1,
            userId: 1,
            name: "옷 이름",
            category: GarmentCategory(rawValue: "TOP")!,
            imageURL:
                "https://i.namu.wiki/i/plYksH3UeGGZLVgjTfbJ8rf1vN2HMIl9ztcpxtfpeQwCYR1CBh3SzbQ0RsgbZ65xiYR-fk7A3Dxy7cExs4rABQ.webp",
            recommendedBodyType: [BodyType(rawValue: "OVAL")!],
            advice: "이렇게 입으쇼",
            tags: ["tag1", "tag2"],
            createdAt: Date(),
            updatedAt: Date()
        )
    )
}
