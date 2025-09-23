//
//  BodyScanFlowView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI

enum BodyScanPose: Int, CaseIterable {
    case front = 0, side, back

    var title: String {
        switch self {
        case .front: return "Step 1 / 3 - 정면 촬영"
        case .side:  return "Step 2 / 3 - 측면 촬영"
        case .back:  return "Step 3 / 3 - 후면 촬영"
        }
    }

    var guide: String {
        "아래와 같이 카메라와 약 2m 떨어져 해당 방향을 바라보고 전신 사진을 촬영해주세요!"
    }

    var sampleName: String {
        switch self {
        case .front: return "sample_front"
        case .side:  return "sample_side"
        case .back:  return "sample_back"
        }
    }
}

struct BodyScanFlowView: View {
    @State private var step: Int = 0
    @State private var showCamera: Bool = false
    @State private var photos: [BodyScanPose: UIImage] = [:]

    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    private var pose: BodyScanPose { BodyScanPose(rawValue: step)! }
    private var isLast: Bool { step == BodyScanPose.allCases.count - 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(pose.title)
                .font(.title3.bold())

            Text(pose.guide)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("예시 \(pose == .front ? "전신" : pose == .side ? "측면" : "후면") 사진")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                    sampleImage
                        .resizable()
                        .scaledToFit()
                        .padding(24)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 360)
            }

            Spacer(minLength: 0)

            Button {
                showCamera = true
            } label: {
                Text("촬영하기")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color("primaryColor")))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .tabBar)
        .sheet(isPresented: $showCamera) { cameraSheet }
        .overlay(alignment: .topTrailing) {
            HStack(spacing: 6) {
                ForEach(BodyScanPose.allCases, id: \.rawValue) { p in
                    Circle()
                        .fill(photos[p] == nil ? Color.gray.opacity(0.25) : Color("primaryColor"))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(12)
        }
    }

    @ViewBuilder
    private var cameraSheet: some View {
        #if targetEnvironment(simulator)
        PhotoLibraryPicker { image in
            if let image { photos[pose] = image; advance() }
        }
        #else
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            BodyScanCameraView { image in
                photos[pose] = image
                advance()
            }
        } else {
            VStack(spacing: 12) {
                Text("이 기기에서는 카메라를 사용할 수 없어요.")
                    .font(.headline)
                Button("닫기") { showCamera = false }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        #endif
    }

    private var sampleImage: Image {
        if let ui = UIImage(named: pose.sampleName) {
            return Image(uiImage: ui)
        } else {
            switch pose {
            case .front: return Image(systemName: "person.fill")
            case .side:  return Image(systemName: "person.fill.turn.right")
            case .back:  return Image(systemName: "person.fill.turn.down")
            }
        }
    }

    private func advance() {
        if isLast {
            // 결과 화면으로 이동 연결 예정
        } else {
            step += 1
        }
        showCamera = false
    }
}
