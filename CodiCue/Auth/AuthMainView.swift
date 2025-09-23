//
//  AuthMainView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/23/25.
//

import SwiftUI
import SwiftyJSON
import VoidUtilities

struct AuthMainView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @AppStorage("jwtToken") var jwtToken: String?
    @AppStorage("isStylist") var isStylist: Bool?
    var body: some View {
        VStack{
            Spacer()
            Image("logoType")
                .padding(.bottom, 36)
            VStack{
                TextField("이메일을 입력하세요", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom)
                SecureField("비밀번호를 입력하세요", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom,24)
                Button(action: {
                    signIn()
                }) {
                    VoidButtonView(.primary, label: "로그인", tintColor: Color("primaryColor"))
                }
                .padding(.bottom)
                HStack{
                    Text("계정이 없으신가요?")
                    Button(action: {
                        
                    }) {
                        Text("회원가입")
                            .foregroundStyle(Color("primaryColor"))
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            Spacer()
        }
    }
    private func signIn() {
        Task{
            let params = ["email": email, "password": password]
            let (isSuccess, data) = await sendPostRequest(endpoint: "auth/login", parameters: params)
            if isSuccess {
                if let data {
                    let jwtToken = data["accessToken"]
//                    print(jwtToken)
                    self.jwtToken = jwtToken.string
                }
            }
        }
    }
    private func stylistSignIn() {
        Task{
            let params = ["email": email, "password": password]
            let (isSuccess, data) = await sendPostRequest(endpoint: "auth/stylist/login", parameters: params)
            if isSuccess {
                if let data {
                    let jwtToken = data["accessToken"]
//                    print(jwtToken)
                    self.jwtToken = jwtToken.string
                }
            }
        }
    }
}

#Preview {
    AuthMainView()
}
