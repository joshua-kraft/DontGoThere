//
//  EditPlaceView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import MapKit
import PhotosUI
import SwiftData
import SwiftUI

struct EditPlaceView: View {

  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var settingsHandler: SettingsHandler
  @EnvironmentObject var locationHandler: LocationHandler

  @Bindable var place: Place

  @State private var isShowingDeleteAlert = false

  @State private var isShowingPhotoPicker = false
  @State private var selectedPhotoItems = [PhotosPickerItem]()

  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        PlaceMinimapView(place: place)

        VStack(alignment: .leading) {
          DetailSectionView(place: place)

          Divider()
            .padding(.bottom, 4)

          NotificationSectionView(place: place)

          Divider()
            .padding(.bottom, 4)

          VStack(alignment: .leading) {
            HeaderLabel("Review")
              .padding(.leading)

            TextField("Why do you want to avoid this place?", text: $place.review, axis: .vertical)
              .lineLimit(6, reservesSpace: true)
              .textFieldStyle(.roundedBorder)
              .padding([.leading, .trailing, .bottom])
          }

          Divider()
            .padding(.bottom, 4)

          PhotoSectionView(place: place)
        }
      }
      .navigationTitle(place.name)
      .navigationBarTitleDisplayMode(.inline)
      .alert("Delete Place", isPresented: $isShowingDeleteAlert) {
        Button("Delete", role: .destructive, action: deletePlace)
        Button("Cancel", role: .cancel) { }
      } message: {
        Text("Are you sure?")
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Delete Place", systemImage: "trash") {
            isShowingDeleteAlert = true
          }
        }
      }
    }
    .scrollDismissesKeyboard(.interactively)
    .background(.thinMaterial)
  }

  func deletePlace() {
    Task { await locationHandler.removeConditionFromMonitor(id: place.id.uuidString) }
    modelContext.delete(place)
    dismiss()
  }

}

#Preview {
  do {
    let previewer = try Previewer()
    return EditPlaceView(place: previewer.activePlace)
      .modelContainer(previewer.container)
      .environmentObject(SettingsHandler.defaults)
      .environmentObject(LocationHandler.shared)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
