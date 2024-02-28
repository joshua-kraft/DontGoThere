//
//  AccessCameraView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/28/24.
//

import SwiftUI

struct AccessCameraView: UIViewControllerRepresentable {
  
  @Binding var takenPhoto: UIImage?
  @Environment(\.dismiss) var dismiss
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = true
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let takenPhoto = info[.originalImage] as? UIImage else {
        print("could not get image")
        return
      }
      self.camera.takenPhoto = takenPhoto
      self.camera.dismiss()
    }
  }
}
