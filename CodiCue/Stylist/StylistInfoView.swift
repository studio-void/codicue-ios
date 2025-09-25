//
//  StylistInfoView.swift
//  CodiCue
//
//  Created by Yeeun on 9/21/25.
//

import SwiftUI

struct StylistInfoView: View {
    let stylist: Stylist
    @State private var query: String = ""
    @Environment(\.dismiss) private var dismiss

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
                ZStack {
                    Color.gray.opacity(0.2)
                    Text("🧑").font(.system(size: 40))
                }
                .frame(width: 88, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 18))

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
                bullet("서울 프라시보 어워드 금상")
                bullet("포브스 선정 올해의 스타일리스트")
                bullet("(현)연예인 스타일리스트")
            }
            .padding(.top, 2)

            Text(
                """
                안녕하세요, 스타일리스트 \(stylist.name)입니다.
                사람의 분위기와 프로젝트 목적을 정확히 읽고, 체형·퍼스널 톤·무드 보드를 바탕으로 가장 설득력 있는 룩을 제안합니다.

                결과로 말하는 스타일리스트, \(stylist.name)입니다.
                """
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
        HStack(alignment: .center, spacing: 8) {
            Circle().fill(Color.gray.opacity(0.6)).frame(width: 4, height: 4)
            Text(text).font(.subheadline).foregroundStyle(.secondary)
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
