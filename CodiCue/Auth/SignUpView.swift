//
//  SignUpView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/23/25.
//

import SwiftUI
import SwiftyJSON
import VoidUtilities

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @AppStorage("jwtToken") var jwtToken: String?
    @AppStorage("isStylist") var isStylist: Bool = false
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var selectedStyles: Set<String> = []
    private let allStyles: [String] = ["미니멀", "꾸안꾸", "스트릿", "힙합", "캐주얼", "포멀", "레트로", "스포츠"]
    var body: some View {
        VStack{
            Spacer()
            Image("logoType")
                .padding(.bottom)
            VStack{
                HStack{
                    Text("이메일")
                    Spacer()
                }
                .fontWeight(.semibold)
                TextField("이메일을 입력하세요", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom)
                HStack{
                    Text("비밀번호")
                    Spacer()
                }
                .fontWeight(.semibold)
                SecureField("비밀번호를 입력하세요", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom)

                HStack(spacing: 20) {
                    // 이름 칼럼
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("이름")
                            Spacer()
                        }
                        .fontWeight(.semibold)
                        TextField("이름을 입력하세요", text: $name)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .frame(maxWidth: .infinity)

                    // 역할 칼럼
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("역할")
                            Spacer()
                        }
                        .fontWeight(.semibold)
                        Menu {
                            Button("사용자") { isStylist = false }
                            Button("스타일리스트") { isStylist = true }
                        } label: {
                            HStack {
                                Text(isStylist ? "스타일리스트" : "사용자")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(Color.primary)
                                VStack(spacing: 2) {
                                    Image(systemName: "chevron.up")
                                    Image(systemName: "chevron.down")
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        .menuStyle(.borderlessButton)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom)

                // 신장 / 체중 라인
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack { Text("신장").fontWeight(.semibold); Spacer() }
                        ZStack(alignment: .trailing) {
                            TextField("예: 173.5", text: $height)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("cm")
                                .foregroundStyle(.gray)
                                .padding(.trailing, 16)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack { Text("체중").fontWeight(.semibold); Spacer() }
                        ZStack(alignment: .trailing) {
                            TextField("예: 58.5", text: $weight)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            Text("kg")
                                .foregroundStyle(.gray)
                                .padding(.trailing, 16)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom)

                // 추구 스타일
                HStack { Text("추구 스타일").fontWeight(.semibold); Spacer() }

                Menu {
                    // 전체 스타일 목록을 드롭다운으로 표시하며 토글 선택
                    ForEach(allStyles, id: \.self) { style in
                        Button(action: {
                            if selectedStyles.contains(style) {
                                selectedStyles.remove(style)
                            } else {
                                selectedStyles.insert(style)
                            }
                        }) {
                            HStack {
                                Text("#\(style)")
                                Spacer()
                                if selectedStyles.contains(style) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }

                    // 선택 초기화
                    if !selectedStyles.isEmpty {
                        Divider()
                        Button(role: .destructive) {
                            selectedStyles.removeAll()
                        } label: {
                            Label("전체 선택 해제", systemImage: "xmark.circle")
                        }
                    }
                } label: {
                    // 라벨: 선택된 칩들을 보여주는 박스 + 우측 ▲▼ 아이콘
                    ZStack(alignment: .trailing) {
                        VStack(alignment: .leading) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 4)], alignment: .leading, spacing: 4) {
                                if selectedStyles.isEmpty {
                                    Text("선택")
                                        .foregroundStyle(.gray)
                                        .padding(.vertical, 6)
                                } else {
                                    ForEach(Array(selectedStyles).sorted(), id: \.self) { style in
                                        Text("#\(style)")
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule().fill(Color("primaryColor").opacity(0.2))
                                            )
                                            .foregroundStyle(Color("primaryColor"))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 1)
                        )

                        VStack(spacing: 2) {
                            Image(systemName: "chevron.up")
                            Image(systemName: "chevron.down")
                        }
                        .font(.footnote)
                        .foregroundStyle(Color.gray)
                        .padding(.trailing, 16)
                    }
                }
                .menuStyle(.borderlessButton)
                .padding(.bottom,24)
                
                Button(action: {
                    
                }) {
                    VoidButtonView(.primary, label: "회원가입", tintColor: Color("primaryColor"))
                }
            }
            .padding()
            Spacer()
        }
    }
    private func signUp() {
        Task{
            let params = ["email": AnyEncodable(email), "password": AnyEncodable(password), "name": AnyEncodable(name), "height": AnyEncodable(height), "weight": AnyEncodable(weight), "preferredStyle": AnyEncodable(selectedStyles)]
            let (isSuccess, data) = await sendPostRequest(endpoint: "user", parameters: params)
            if isSuccess {
                if let data = data {
                    data["accessToken"]
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
