//
//  HomeView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/21/25.
//

import SwiftUI

struct HomeView: View {
    @State var condition: String = ""
    var body: some View {
        VStack{
            TextField("상황을 알려주시면 스타일링해드립니다!", text: $condition)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom,8)
            if condition != "" {
                ScrollView(.horizontal) {
                    HStack{
                        ConditionChipView(label: "MOOD")
                        ConditionChipView(label: "OOTD")
                    }
                }
                .padding(.bottom,8)
            }
            Spacer()
        }
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
