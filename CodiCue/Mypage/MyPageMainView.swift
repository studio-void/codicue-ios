//
//  MypageMainView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/22/25.
//

import SwiftUI
import VoidUtilities

struct MyPageMainView: View {
    var body: some View {
        ScrollView{
            HStack{
                Text("마이페이지")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom,12)
            HStack{
                Text("체형 정보 수정")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom,4)
            MyPageButtonView(label: "AI 체형 분석 바로가기")
                .padding(.bottom,8)
            HStack{
                Text("개인정보 관리")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom,4)
            MyPageButtonView(label: "프로필 정보 수정")
                .padding(.bottom, 4)
            MyPageButtonView(label: "시스템 설정", action: {
                #if os(iOS)
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
                #endif
            })
                .padding(.bottom, 8)
            HStack{
                Text("정보")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom,4)
            MyPageButtonView(label: "이용 약관")
                .padding(.bottom, 4)
            MyPageButtonView(label: "개인정보 처리방침")
                .padding(.bottom, 4)
            MyPageButtonView(label: "유료 결제 약관")
                .padding(.bottom, 64)
            
            Text("CodiCue \(version!)")
                .font(.footnote)
                .foregroundStyle(Color.gray600)
        }
    }
    
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String,
            let build = dictionary["CFBundleVersion"] as? String else {return nil}

        let versionAndBuild: String = "v\(version) (\(build))"
        return versionAndBuild
    }
}

private struct MyPageButtonView: View {
    let label: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            HStack {
                Text(label)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .fontWeight(.semibold)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .foregroundStyle(Color("primaryColor"))
            .background(Color("primaryColor").opacity(0.2))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MyPageMainView()
}
