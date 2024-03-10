//
//  PhotoCardScrollerView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import SwiftUI

struct PhotoCardScrollerView: View {
  @Bindable var place: Place

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        if let imageData = place.imageData {
          ForEach(imageData, id: \.self) { imageData in
            PlaceImageCardView(imageData: imageData, place: place)
              .frame(width: 120, height: 120)
              .clipShape(.rect(cornerRadius: 5))
              .contextMenu {
                Button("Delete", systemImage: "trash", role: .destructive) {
                  withAnimation {
                    deletePhoto(imageData: imageData)
                  }
                }
              }
          }
        }
      }
      .padding([.leading, .trailing])
      .padding(.bottom, 4)
    }
  }

  func deletePhoto(imageData: Data) {
    if let index = place.imageData?.firstIndex(of: imageData) {
      place.imageData?.remove(at: index)
    }
  }
}

struct PlaceImageCardView: View {
  let imageData: Data
  @Bindable var place: Place
  @State private var isShowingPhotoSheet = false

  var body: some View {
    if let uiImage = UIImage(data: imageData) {
      Image(uiImage: uiImage)
        .resizable()
        .scaledToFill()
        .onTapGesture {
          isShowingPhotoSheet = true
        }
        .sheet(isPresented: $isShowingPhotoSheet) {
          PhotoSheetView(imageData: imageData, place: place)
        }
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return PhotoCardScrollerView(place: previewer.activePlace)
      .modelContainer(previewer.container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
