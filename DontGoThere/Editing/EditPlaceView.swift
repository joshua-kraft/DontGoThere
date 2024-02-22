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
    }
    
    init(_ text: String) {
      self.text = text
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
  
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var appSettings: AppSettings
  
  @Bindable var place: Place
  
  @State private var isShowingDeleteAlert = false
  
  @State private var isShowingPhotoPicker = false
  @State private var selectedPhotoItems = [PhotosPickerItem]()

  var body: some View {
    GeometryReader { proxy in
      ScrollView(.vertical) {
        VStack(alignment: .leading) {
          
          ZStack(alignment: .top) {
            MapReader { mapProxy in
              Map(initialPosition: position(for: place), interactionModes: [.pan, .zoom, .rotate]) {
                Marker(place.name, coordinate: place.coordinate)
              }
              .frame(height: proxy.size.height * 0.40)
              .onTapGesture { position in
                if let tappedCoordinate = mapProxy.convert(position, from: .local) {
                  place.latitude = tappedCoordinate.latitude
                  place.longitude = tappedCoordinate.longitude
                }
              }
            }
            
            Text("Tap on the map to edit this place's location.")
              .frame(maxWidth: .infinity)
              .padding([.top, .bottom], 12)
              .font(.subheadline.bold())
              .background(.thinMaterial.opacity(0.9))
              .multilineTextAlignment(.center)
          }
          
          VStack(alignment: .leading) {
            Text("Details")
              .font(.title3)
              .foregroundStyle(.secondary)
              .padding(.leading)
            
            Divider()
              .padding(.bottom, 4)
            
            // name, times
            VStack(alignment: .listRowSeparatorLeading) {
              HStack {
                DetailLabel("Name:")
                  .padding([.leading])
                TextField("Place Name", text: $place.name)
                  .textFieldStyle(.roundedBorder)
                  .padding(.trailing)
              }
              .padding(.bottom, 4)
              HStack {
                DetailLabel("Added:")
                  .padding([.leading])
                DatePicker("Added Date", selection: $place.addDate, displayedComponents: .date)
                  .disabled(true)
                  .labelsHidden()
                Spacer()
                DetailLabel("Expires?")
                Toggle("Expires?", isOn: $place.shouldExpire.animation())
                  .labelsHidden()
                  .padding(.trailing)
                  .onChange(of: place.shouldExpire) {
                    place.expirationDate = place.shouldExpire ? Date.distantFuture : appSettings.getExpiryDate(from: place.addDate)
                  }
              }
              .padding(.bottom, 4)
              
              if place.shouldExpire {
                
                HStack {
                  DetailLabel("Expires:")
                    .padding([.leading])
                  DatePicker("Expires", selection: $place.expirationDate, displayedComponents: .date)
                    .labelsHidden()
                }
                .padding(.bottom, 4)
                
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
              
              TextField("Why do you want to avoid this place?", text: $place.review, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing, .bottom])
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
              
              ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                  if let imageData = place.imageData {
                    ForEach(imageData, id: \.self) { imageData in
                      PlaceImageCardView(imageData: imageData, place: place)
                        .frame(width: proxy.size.width * 0.34, height: proxy.size.height * 0.17)
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
            .padding(.bottom)
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
    }
    .background(.thinMaterial)
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
  
  func deletePhoto(imageData: Data) {
    if let index = place.imageData?.firstIndex(of: imageData) {
      place.imageData?.remove(at: index)
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
  
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return EditPlaceView(place: previewer.activePlace)
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
    
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
