//
//  ClosetDetailsView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI

struct ClosetDetailsView: View {
    let garment: Garment
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                    Text("👔")
                        .font(.system(size: 80))
                }
                .frame(height: 220)
                .padding(.horizontal, 16)
                
                Text(garment.title)
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("장원영님의 조언")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    
                    Text("핏: 정사이즈~살짝 오버로, 앞만 살짝 넣입 + 소매 롤업(비율 ↑).\n하의/신발: 블랙 테이퍼드 슬랙스+더비 / 미드워시 스트레이트 데님+화이트 스니커즈 / 올리브 카고+트레일 러너.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("옷 상세정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}
