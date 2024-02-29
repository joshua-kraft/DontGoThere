//
//  PhotoSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import SwiftUI
import PhotosUI

struct PhotoSectionView: View {
  
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
        
        Button("Take Photo", systemImage: "camera") {
          isShowingCamera.toggle()
        }
        
        Spacer()
        
        PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 6, matching: .any(of: [.images, .not(.screenshots)])) {
          Label("Add Photos", systemImage: "photo.badge.plus")
        }
      }
      .padding([.leading, .trailing])
      .onChange(of: selectedPhotoItems) {
        loadPhotos()
      }
      
      PhotoCardScrollerView(place: place)
    }
    .fullScreenCover(isPresented: $isShowingCamera, onDismiss: {
      addTakenPhoto()
    }) {
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
