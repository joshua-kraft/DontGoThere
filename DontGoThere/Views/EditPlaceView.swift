//
//  EditPlaceView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import MapKit
import PhotosUI
import SwiftData
import SwiftUI

struct EditPlaceView: View {
  
  struct DetailLabel: View {
    let text: String
    
    var body: some View {
      Text(text)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(width: 65)
        .padding(.leading)
    }
    
    init(_ text: String) {
      self.text = text
    }
  }
  
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var appSettings: AppSettings
  
  @State private var isShowingDeleteAlert = false
  
  @Bindable var place: Place
  
  // Detail section state
  @State private var shouldAutoCalcExpiry = true
  @State private var expiryValue = 1
  @State private var expiryUnit = TimeUnit.months
  @State private var expiryInterval = 0.0
  
  // Photo picker state
  @State private var isShowingPhotoPicker = false
  @State private var selectedPhotoItems = [PhotosPickerItem]()
  
  var body: some View {
    GeometryReader { proxy in
      ScrollView(.vertical) {
        VStack(alignment: .leading) {
          Map(initialPosition: position(for: place), interactionModes: []) {
            Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
          }
          .frame(height: proxy.size.height * 0.30)
          
          VStack(alignment: .leading) {
            Text("Details")
              .font(.title3)
              .foregroundStyle(.secondary)
              .padding(.leading)
            
            Divider()
              .padding(.bottom, 4)
            
            // name, notes, times
            VStack(alignment: .leading) {
              HStack {
                DetailLabel("NAME:")
                TextField("Place Name", text: $place.name)
                  .textFieldStyle(.roundedBorder)
                  .padding(.trailing)
              }
              .padding(.bottom, 4)
              HStack {
                DetailLabel("NOTES:")
                TextField("Place Notes", text: $place.notes)
                  .textFieldStyle(.roundedBorder)
                  .padding(.trailing)
              }
              .padding(.bottom, 4)
              HStack {
                DetailLabel("ADDED:")
                DatePicker("Added Date", selection: $place.addDate, displayedComponents: .date)
                  .disabled(true)
                  .labelsHidden()
              }
              .padding(.bottom, 4)
              HStack {
                DetailLabel("EXPIRES: ")
                DatePicker("Expires", selection: $place.expirationDate, displayedComponents: .date)
                  .labelsHidden()
                  .disabled(shouldAutoCalcExpiry)
                Spacer()
                Toggle(isOn: $shouldAutoCalcExpiry) {
                  Text("Auto")
                }
                .toggleStyle(CheckboxToggleStyle())
                .padding(.trailing)
                .onChange(of: shouldAutoCalcExpiry) { 
                    updateExpiryValue()
                }
              }
              .padding(.bottom, 4)
              
              if !shouldAutoCalcExpiry {
                TimeValuePickerView(timeValue: $expiryValue, timeUnit: $expiryUnit, timeInterval: $expiryInterval, labelText: "SET TO EXPIRE IN:", pickerTitle: "Expiry Value")
                  .onChange(of: expiryInterval) {
                    updateExpiryValue()
                  }
              }
              
            }
            
            Divider()
              .padding(.bottom, 4)
            
            // images
            VStack {
              HStack(alignment: .bottom) {
                Text("Photos")
                  .font(.title3)
                  .foregroundStyle(.secondary)
                
                Spacer()
                
                PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 6, matching: .any(of: [.images, .not(.screenshots)])) {
                  Label("Add Photos", systemImage: "photo.badge.plus")
                }
              }
              .padding([.leading, .trailing])
              .onChange(of: selectedPhotoItems) {
                loadPhotos()
              }
              
              if let imageData = place.imageData {
                if imageData.isEmpty {
                  Text("No Photos")
                    .foregroundStyle(.secondary)
                    .frame(height: proxy.size.height * 0.17)
                } else {
                  ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                      ForEach(imageData, id: \.self) { imageData in
                        if let uiImage = UIImage(data: imageData) {
                          Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width * 0.34, height: proxy.size.height * 0.17)
                            .clipShape(.rect(cornerRadius: 5))
                        }
                      }
                    }
                    .padding([.leading, .trailing])
                    .padding(.bottom, 4)
                  }
                }
              }
            }
            
            Divider()
              .padding(.bottom, 4)
            
            // review
            VStack(alignment: .leading) {
              Text("Review")
                .font(.title3)
                .foregroundStyle(.secondary)
                .padding(.leading)
              
              TextField("Review", text: $place.review, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .padding()
            }
          }
        }
        .frame(minHeight: proxy.size.height, maxHeight: .infinity)
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(.thinMaterial)
        .alert("Delete place", isPresented: $isShowingDeleteAlert) {
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
    }
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
  
  func deletePlace() {
    modelContext.delete(place)
    dismiss()
  }
  
  func position(for place: Place) -> MapCameraPosition {
    MapCameraPosition.region(
      MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    )
  }
  
  func updateExpiryValue() {
    if shouldAutoCalcExpiry {
      place.expirationDate = place.addDate.addingTimeInterval(appSettings.autoExpiryInterval)
    } else {
      place.expirationDate = place.addDate.addingTimeInterval(expiryInterval)
    }
  }

}

#Preview {
  do {
    let previewer = try Previewer()
    
    return EditPlaceView(place: previewer.place)
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
    
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
