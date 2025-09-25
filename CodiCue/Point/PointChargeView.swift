//
//  PointChargeView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI

struct PointChargeView: View {
    @AppStorage("point") private var point: Int = 0

    private let packs: [PointPack] = [
        .init(points: 200, priceKRW: 2_200),
        .init(points: 500, priceKRW: 5_500),
        .init(points: 1_000, priceKRW: 10_000),
        .init(points: 1_500, priceKRW: 13_000),
        .init(points: 2_000, priceKRW: 18_000, isBest: true),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("충전하기")
                    .font(.title3.bold())

                HStack {
                    Text("보유 포인트")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(point)P")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("primaryColor"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("primaryColor").opacity(0.2))
                )

                LazyVStack(spacing: 12) {
                    ForEach(packs) { pack in
                        ChargeRow(pack: pack, onTap: {point += pack.points})
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
        .navigationTitle("포인트 충전")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 2) {
                Text("결제는 App Store를 통해 처리됩니다.")
                Text("상품을 이용하지 않았을 경우에만 청약 철회가 가능하며,")
                Text("결제 시 이용 약관 및 유료 결제 약관에 동의하는 것으로 간주됩니다.")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
        }
    }
}

private struct ChargeRow: View {
    let pack: PointPack
    var onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("\(pack.points.formatted())P")
                .font(.body.weight(.medium))

            if pack.isBest {
                Text("인기")
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.pink.opacity(0.15)))
                    .foregroundStyle(.pink)
            }

            Spacer()

            Button(action: onTap) {
                Text(pack.priceFormatted)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color("primaryColor")))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
    }
}

struct PointPack: Identifiable {
    let id = UUID()
    let points: Int
    let priceKRW: Int
    var isBest: Bool = false

    var priceFormatted: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "₩"
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: priceKRW)) ?? "₩\(priceKRW)"
    }
}
