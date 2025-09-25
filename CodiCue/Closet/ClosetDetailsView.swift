//
//  ClosetDetailsView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClosetDetailsView: View {
    let garment: Garment

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                    WebImage(url: garment.imageURL)
                }
                .frame(height: 220)
                .padding(.horizontal, 16)

                Text(garment.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                } label: {
                    Text("친구에게 공유하기")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primaryColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 16)

                if garment.advice != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("착용 조언")
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)
                        Text(
                            garment.advice!
                        )
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.horizontal, 16)
                }
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("옷 상세정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}
