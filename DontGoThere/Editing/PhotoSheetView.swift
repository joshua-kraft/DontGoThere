//
//  PhotoSheetView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/22/24.
//

import SwiftUI

struct PhotoSheetView: View {
  
  @Environment(\.dismiss) var dismiss
  
  let imageData: Data
  @Bindable var place: Place
  @State private var isShowingDeleteAlert = false
  
  var body: some View {
    NavigationStack {
      VStack {
        if let uiImage = UIImage(data: imageData) {
          ZoomableScrollView {
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFit()
          }
        }
      }
      .navigationTitle("Photo of \(place.name)")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Delete Photo", systemImage: "trash", role: .destructive) {
            isShowingDeleteAlert = true
          }
          .tint(.red)
        }
      }
    }
    .alert("Delete Photo", isPresented: $isShowingDeleteAlert) {
      Button("Delete", role: .destructive, action: deletePhoto)
      Button("Cancel", role: .cancel) { }
    } message: {
      Text("Are you sure you want to delete this photo?")
    }
  }
  
  func deletePhoto() {
    if let index = place.imageData?.firstIndex(of: imageData) {
      place.imageData?.remove(at: index)
    }
    dismiss()
  }
  
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return PhotoSheetView(imageData: Data(), place: previewer.activePlace)
      .modelContainer(previewer.container)
    
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
