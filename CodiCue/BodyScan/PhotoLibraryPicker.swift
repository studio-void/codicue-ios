//
//  PhotoLibraryPicker.swift
//  CodiCue
//
//  Created by Yeeun on 9/23/25.
//

import SwiftUI
import PhotosUI

struct PhotoLibraryPicker: UIViewControllerRepresentable {
    var onPick: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onPick: onPick) }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onPick: (UIImage?) -> Void
        init(onPick: @escaping (UIImage?) -> Void) { self.onPick = onPick }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                onPick(nil); return
            }
            provider.loadObject(ofClass: UIImage.self) { obj, _ in
                DispatchQueue.main.async { self.onPick(obj as? UIImage) }
            }
        }
    }
}
