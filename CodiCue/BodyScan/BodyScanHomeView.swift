//
//  BodyScanHomeView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI

struct BodyScanHomeView: View {
    @State private var reports: [BodyScanReport] = BodyScanReport.mock

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("AI 체형 분석")
                    .font(.title3.weight(.bold))

                Text("AI가 전신 사진을 분석하여 체형을 진단하고 스타일을 추천해드립니다!")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                NavigationLink {
                    BodyScanStep1View()
                } label: {
                    Text("AI 체형 분석 시작하기")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color("primaryColor")))
                }
                .buttonStyle(.plain)

                Text("기존 분석 결과")
                    .font(.headline)
                    .padding(.top, 8)

                VStack(spacing: 12) {
                    ForEach(reports) { report in
                        BodyScanReportCard(report: report)
                    }
                }
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .tabBar)
    }
}

private struct BodyScanReportCard: View {
    let report: BodyScanReport

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                Image(systemName: figureSymbol)
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 64, height: 88)

            VStack(alignment: .leading, spacing: 6) {
                Text(report.dateString + " · 분석 결과")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(report.title)
                    .font(.body.weight(.semibold))

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(report.highlights, id: \.self) { line in
                        HStack(alignment: .top, spacing: 8) {
                            Circle().frame(width: 4, height: 4)
                                .foregroundStyle(.secondary)
                                .padding(.top, 6)
                            Text(line)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.top, 2)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }

    private var figureSymbol: String {
        if UIImage(systemName: "figure.stand") != nil {
            return "figure.stand"
        } else {
            return "person"
        }
    }
}


struct BodyScanReport: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let highlights: [String]

    var dateString: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy. MM. dd."
        return f.string(from: date)
    }

    static let mock: [BodyScanReport] = [
        .init(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            title: "역삼각형 체형",
            highlights: [
                "어깨가 넓고, 허리가 얇은 체형",
                "세미 오버 재킷 스타일 추천"
            ]
        ),
        .init(
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            title: "역삼각형 체형",
            highlights: [
                "어깨가 넓고, 허리가 얇은 체형",
                "세미 오버 재킷 스타일 추천"
            ]
        ),
        .init(
            date: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
            title: "역삼각형 체형",
            highlights: [
                "어깨가 넓고, 허리가 얇은 체형",
                "세미 오버 재킷 스타일 추천"
            ]
        )
    ]
}

#Preview {
    NavigationView { BodyScanHomeView() }
}
