//
//  BodyScanStep1View.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI

struct BodyScanStep1View: View {
    @State private var showingCamera = false
    @State private var capturedImage: UIImage? = nil

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Step 1 / 3 - 정면 촬영")
                    .font(.title3.bold())
                Spacer()
            }

            Text("아래와 같이 카메라와 약 2m 떨어져 정면을 바라보고\n전신 사진을 촬영해주세요!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
                if let img = capturedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .padding(12)
                } else {
                    // 예시 일러스트/이모지
                    Text("🧍‍♂️")
                        .font(.system(size: 120))
                }
            }
            .frame(height: 360)

            Button {
                showingCamera = true
            } label: {
                Text("촬영하기")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color("primaryColor")))
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(16)
        .sheet(isPresented: $showingCamera) {
            BodyScanCameraView { image in
                self.capturedImage = image
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView { BodyScanStep1View() }
}
