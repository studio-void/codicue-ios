//
//  StylistInfoView.swift
//  CodiCue
//
//  Created by Yeeun on 9/21/25.
//

import SDWebImageSwiftUI
import SwiftUI

struct StylistInfoView: View {
    let stylist: StylistInfo
    @State private var query: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isImageLoading: Bool = true

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color.white)
                        )
                }
                SearchBar(
                    text: $query,
                    placeholder: "\(stylist.name) 스타일리스트"
                )
            }

            profileCard

            Spacer(minLength: 8)
            consultButton
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Profile Card
    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                Group {
                    if let url = URL(string: stylist.profileImageUrl) {
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
                    } else {
                        ZStack {
                            Color.gray.opacity(0.2)
                            Text("🧑").font(.system(size: 40))
                        }
                    }
                }
                .frame(width: 88, height: 88)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                )
                .overlay {
                    if isImageLoading {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 18,
                                style: .continuous
                            )
                            .fill(.ultraThinMaterial)
                            ProgressView()
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("스타일리스트")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 6) {
                        Text(stylist.name).font(.title3.bold())
                        if stylist.isVerified {
                            Image("verified").resizable().scaledToFit().frame(
                                height: 18
                            )
                        }
                    }

                    HStack(spacing: 10) {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill").foregroundStyle(
                                .yellow
                            )
                            Text(String(format: "%.2f", stylist.rating)).font(
                                .headline
                            )
                            Text("/ 5.0").foregroundStyle(.secondary)
                        }
                        .font(.subheadline)

                        HStack(spacing: 6) {
                            Image(systemName: "text.bubble").foregroundStyle(
                                .secondary
                            )
                            Text("415").foregroundStyle(.secondary)
                        }
                        .font(.subheadline)
                    }
                }
                Spacer(minLength: 0)
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(stylist.career, id: \.self) { career in
                    bullet(career)
                }
            }
            .padding(.top, 2)

            Text(
                stylist.introduction
            )
            .font(.body)
            .lineSpacing(4)
            .foregroundStyle(.primary)
            .padding(.top, 4)
        }
        .padding(16)
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

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            // Dot is vertically centered to approximately the first line height
            Circle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 4, height: 4)
                .padding(.top, 6)  // approx half of a subheadline line height
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Bottom CTA
    private var consultButton: some View {
        NavigationLink {
            StylistChatView(stylistName: stylist.name)
        } label: {
            HStack(spacing: 8) {
                Text("상담하기").fontWeight(.semibold)
                Image(systemName: "circle.fill").foregroundStyle(.yellow)
                Text("50")
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color("primaryColor"))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview { StructureView() }
