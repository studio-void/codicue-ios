//
//  StylistInfoView.swift
//  CodiCue
//
//  Created by Yeeun on 9/21/25.
//

import SwiftUI

struct StylistInfoView: View {
    @State private var query: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1.0, green: 0.9647, blue: 0.9843)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    searchBar
                    profileCard
                    Spacer(minLength: 8)
                    consultButton
                }
                .padding(.top, 8)
            }
        }
    }
    
    // MARK: - Search
    private var searchBar: some View {
        HStack(spacing: 10) {
            TextField("장원영 좋아요", text: $query)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - Profile Card
    private var profileCard: some View {
        ZStack(alignment: .trailing) {
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
                            Text("장원영")
                                .font(.title3.bold())
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                        }
                                                HStack(spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "star.fill").foregroundStyle(.yellow)
                                Text("4.93").font(.headline)
                                Text("/ 5.0").foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "text.bubble").foregroundStyle(.secondary)
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
                
                Text("""
                안녕하세요, 스타일리스트 장원영입니다.
                사람의 분위기와 프로젝트 목적을 정확히 읽고, 체형·퍼스널 톤·무드 보드를 바탕으로 가장 설득력 있는 룩을 제안합니다.

                결과로 말하는 스타일리스트, 장원영입니다.
                """)
                .font(.body)
                .foregroundStyle(.primary)
                .padding(.top, 4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
            )
            .padding(.horizontal, 16)
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.gray)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.white))
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            }
            .padding(.trailing, 28)
            .offset(y: 6)
        }
    }
    
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Circle().fill(Color.gray.opacity(0.6)).frame(width: 4, height: 4)
            Text(text).font(.subheadline).foregroundStyle(.secondary)
        }
    }
    
    private var consultButton: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Text("상담하기").fontWeight(.semibold)
                Image(systemName: "circle.fill").foregroundStyle(Color.yellow)
                Text("50")
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.pink)
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

#Preview {
    StylistInfoView()
}
