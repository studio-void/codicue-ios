//
//  PointMainView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI

struct PointMainView: View {
    @AppStorage("point") private var point: Int = 213
    @State private var history: [PointHistory] = PointHistory.mock
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("포인트")
                        .font(.title3.bold())
                    
                    ZStack {
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.88, green: 0.68, blue: 0.77), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.78, green: 0.24, blue: 0.5), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.94, y: 1.28),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                        .cornerRadius(16)
                        
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .black.opacity(0), location: 0.00),
                                Gradient.Stop(color: .black.opacity(0.25), location: 1.00),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .cornerRadius(16)
                        
                        VStack(spacing: 6) {
                            Text("내 보유 포인트")
                                .font(.caption.bold())
                                .foregroundStyle(.white.opacity(0.9))
                            Text("\(point)P")
                                .font(.system(size: 36, weight: .heavy))
                                .foregroundStyle(.white)
                            NavigationLink {
                                PointChargeView()
                            } label: {
                                Text("충전하기")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Color("primaryColor"))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white)
                                    )
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 2)
                        }
                        .padding(16)
                    }
                    .frame(height: 120)
                    
                    Spacer()
                    Text("이용 내역")
                        .font(.headline)
                        .padding(.top, 4)
                    
                    ForEach(PointHistory.groupedByDate(history), id: \.date) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.date)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            VStack(spacing: 10) {
                                ForEach(section.items) { item in
                                    PointHistoryRow(item: item)
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PointHistoryRow: View {
    @AppStorage("point") private var point: Int = 213
    let item: PointHistory
    
    var body: some View {
        HStack {
            Text(item.title)
                .font(.subheadline)
                .lineLimit(1)
            Spacer()
            Text(item.delta > 0 ? "+\(item.delta)P" : "\(item.delta)P")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(item.delta > 0 ? Color.green : Color.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(Color("primaryColor").opacity(0.15))
                )
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("primaryColor").opacity(0.18))
        )
        .onTapGesture {
            point += item.delta
        }
    }
}

struct PointHistory: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let delta: Int
    
    static let mock: [PointHistory] = [
        .init(date: Date(), title: "장원영 스타일리스트 상담", delta: -200),
        .init(date: Date(), title: "설윤 스타일리스트 상담 취소 (자동 환불)", delta: +100),
        .init(date: Date(), title: "설윤 스타일리스트 상담", delta: -100),
        .init(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, title: "김지우 스타일리스트 상담", delta: -200)
    ]
    
    static func groupedByDate(_ list: [PointHistory]) -> [(date: String, items: [PointHistory])] {
        let fmt = DateFormatter()
        fmt.dateFormat = "M월 d일"
        let groups = Dictionary(grouping: list) { fmt.string(from: $0.date) }
        return groups.keys.sorted { lhs, rhs in
            fmt.date(from: lhs)! > fmt.date(from: rhs)!
        }.map { key in
            (date: key, items: groups[key]!.sorted { $0.date > $1.date })
        }
    }
}

#Preview {
    PointMainView()
}
