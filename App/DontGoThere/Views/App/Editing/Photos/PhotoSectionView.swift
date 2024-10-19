//
//  PhotoSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import SwiftUI
import PhotosUI

struct PhotoSectionView: View {

  var isOnMac: Bool {
    return ProcessInfo.processInfo.isiOSAppOnMac
  }

  @Bindable var place: Place
  @State private var isShowingPhotoPicker = false
  @State private var selectedPhotoItems = [PhotosPickerItem]()

  @State private var isShowingCamera = false
  @State private var takenPhotoData: Data?

  var body: some View {
    VStack {
      HStack(alignment: .bottom) {
        HeaderLabel("Photos")

        Spacer()

        Menu("Add Photos", systemImage: "photo.badge.plus") {

          if !isOnMac {
            Button("Take Photo...", systemImage: "camera") {
              isShowingCamera.toggle()
            }
          }

          Button("Choose Photos...", systemImage: "photo.on.rectangle.angled") {
            isShowingPhotoPicker.toggle()
          }

        }
      }
      .padding([.leading, .trailing])
      .onChange(of: selectedPhotoItems) {
        loadPhotos()
      }

      PhotoCardScrollerView(place: place)
    }
    .photosPicker(isPresented: $isShowingPhotoPicker,
                  selection: $selectedPhotoItems,
                  matching: .any(of: [.images, .not(.screenshots)]))
    .fullScreenCover(isPresented: $isShowingCamera, onDismiss: addTakenPhoto) {
      AccessCameraView(takenPhotoData: $takenPhotoData)
        .ignoresSafeArea()
    }

    .padding(.bottom)
  }

  func loadPhotos() {
    Task { @MainActor in
      for selectedItem in selectedPhotoItems {
        let imageDatum = try await selectedItem.loadTransferable(type: Data.self)
        if let data = imageDatum {
          if let contains = place.imageData?.contains(data) {
            if !contains {
              place.imageData?.append(data)
            }
          }
        }
      }
    }
  }

  func addTakenPhoto() {
    if let takenPhotoData {
      place.imageData?.append(takenPhotoData)
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return PhotoSectionView(place: previewer.activePlace)
      .modelContainer(previewer.container)
  } catch {
    return Text("Could not create preview: \(error.localizedDescription)")
  }
}
