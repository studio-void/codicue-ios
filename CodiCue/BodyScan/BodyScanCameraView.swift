//
//  BodyScanCameraView.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI
import AVFoundation
import UIKit
import Combine

// MARK: - Public SwiftUI Wrapper
struct BodyScanCameraView: View {
    var onCapture: (UIImage?) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var camera = CameraService()

    var body: some View {
        ZStack {
            CameraPreview(session: camera.session)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        onCapture(nil)
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .shadow(radius: 4)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 12)
                    Spacer()
                }
                Spacer()
                Button {
                    camera.capturePhoto { image in
                        onCapture(image)
                        dismiss()
                    }
                } label: {
                    ZStack {
                        Circle().fill(.white.opacity(0.2)).frame(width: 86, height: 86)
                        Circle().fill(.white).frame(width: 72, height: 72)
                    }
                }
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            camera.configure()
            camera.startRunning()
        }
        .onDisappear {
            camera.stopRunning()
        }
    }
}

// MARK: - Camera Service (AVCaptureSession)
final class CameraService: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    private var photoOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var captureCompletion: ((UIImage?) -> Void)?

    func configure() {
        // 여러 번 호출돼도 한 번만 구성되도록
        guard session.inputs.isEmpty && session.outputs.isEmpty else { return }

        session.beginConfiguration()
        session.sessionPreset = .photo

        // 카메라 접근 권한
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { _ in }
        default:
            break
        }

        // 후면 카메라
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }
        session.addInput(input)
        self.videoDeviceInput = input

        // 사진 출력
        guard session.canAddOutput(photoOutput) else {
            session.commitConfiguration()
            return
        }
        session.addOutput(photoOutput)
        photoOutput.isHighResolutionCaptureEnabled = true

        session.commitConfiguration()
    }

    func startRunning() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopRunning() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        captureCompletion = completion
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            print("capture error:", error)
            captureCompletion?(nil)
            captureCompletion = nil
            return
        }
        guard let data = photo.fileDataRepresentation(),
              var image = UIImage(data: data) else {
            captureCompletion?(nil)
            captureCompletion = nil
            return
        }
        // 미리보기 레이어는 항상 Portrait 기준이 아닐 수 있으니 정방향으로 보정
        image = image.fixedOrientation()
        captureCompletion?(image)
        captureCompletion = nil
    }
}

// MARK: - Preview Layer (UIViewRepresentable)
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let v = PreviewView()
        v.videoPreviewLayer.session = session
        v.videoPreviewLayer.videoGravity = .resizeAspectFill
        return v
    }

    func updateUIView(_ uiView: PreviewView, context: Context) { }
}

final class PreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}

// MARK: - UIImage orientation fix
private extension UIImage {
    func fixedOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalized ?? self
    }
}
