//
//  AccessCameraView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/28/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import SwiftUI

struct AccessCameraView: UIViewControllerRepresentable {

  @Binding var takenPhotoData: Data?
  @Environment(\.dismiss) var dismiss

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = context.coordinator
    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    // intentionally empty
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(camera: self)
  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var camera: AccessCameraView

    init(camera: AccessCameraView) {
      self.camera = camera
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      guard let takenPhoto = info[.originalImage] as? UIImage else { return }
      guard let photoData = takenPhoto.heicData() else { return }
      self.camera.takenPhotoData = photoData
      self.camera.dismiss()
    }
  }
}
