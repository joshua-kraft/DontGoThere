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
  
  struct TextLabel: View {
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
  
  struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
      Button(action: {
        configuration.isOn.toggle()
      }, label: {
        HStack {
          Image(systemName: configuration.isOn ? "checkmark.square" : "square")
          configuration.label
        }
      })
      .buttonStyle(.plain)
    }
  }
  
  struct TimeUnit {
    enum tUnits { case days, weeks, months, years }
    var unit: tUnits
    var expiryInterval: Int {
      switch unit {
      case .days:
        return 1 * 86400
      case .weeks:
        return 7 * 86400
      case .months:
        return 30 * 86400
      case .years:
        return 365 * 86400
      }
    }
  }
  
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  
  @State private var isShowingDeleteAlert = false
  
  @Bindable var place: Place
  
  // Detail section state
  @State private var timeUnit = TimeUnit(unit: .months)
  @State private var shouldAutoCalcExpiry = true
  @State private var expiryValue = 3
  @State private var expiryIsInDays = false
  @State private var expiryIsInWeeks = false
  @State private var expiryIsInMonths = true
  @State private var expiryIsInYears = false
  
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
                TextLabel("NAME:")
                TextField("Place Name", text: $place.name)
                  .textFieldStyle(.roundedBorder)
                  .padding(.trailing)
              }
              .padding(.bottom, 4)
              HStack {
                TextLabel("NOTES:")
                TextField("Place Notes", text: $place.notes)
                  .textFieldStyle(.roundedBorder)
                  .padding(.trailing)
              }
              .padding(.bottom, 4)
              HStack {
                TextLabel("ADDED:")
                DatePicker("Added Date", selection: $place.addDate)
                  .disabled(true)
                  .labelsHidden()
              }
              .padding(.bottom, 4)
              HStack {
                TextLabel("EXPIRES: ")
                DatePicker("Expires", selection: $place.expirationDate)
                  .labelsHidden()
                  .disabled(shouldAutoCalcExpiry)
                Toggle(isOn: $shouldAutoCalcExpiry) {
                  Text("Auto")
                }
                .toggleStyle(CheckboxToggleStyle())
                .padding(.trailing)
                .onChange(of: shouldAutoCalcExpiry) { if !shouldAutoCalcExpiry { updateExpiryValue() } }
              }
              .padding(.bottom, 4)
              
              // expiry time picker
              if !shouldAutoCalcExpiry {
                HStack {
                  Text("SET TO EXPIRE IN:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                  
                  Picker("Expiry", selection: $expiryValue) {
                    ForEach(1...100, id: \.self) { value in
                      Text(String(value))
                    }
                  }
                  .labelsHidden()
                  .pickerStyle(.wheel)
                  .frame(height: 85)
                  .onChange(of: expiryValue) {
                    updateExpiryValue()
                  }
                  
                  VStack(alignment: .leading) {
                    
                    Toggle(isOn: $expiryIsInDays) {
                      Text("Days")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .onChange(of: expiryIsInDays) {
                      daysChecked()
                    }
                    
                    Toggle(isOn: $expiryIsInWeeks) {
                      Text("Weeks")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .onChange(of: expiryIsInWeeks) {
                      weeksChecked()
                    }
                    
                    Toggle(isOn: $expiryIsInMonths) {
                      Text("Months")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .onChange(of: expiryIsInMonths) {
                      monthsChecked()
                    }
                    
                    Toggle(isOn: $expiryIsInYears) {
                      Text("Years")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .onChange(of: expiryIsInYears) {
                      yearsChecked()
                    }
                  }
                  .padding(.trailing)
                }
                .padding(.bottom, 4)
              }
              
            }
            
            Divider()
              .padding(.bottom, 4)
            
            // images
            VStack {
              HStack(alignment: .bottom) {
                Text("Images")
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
                if !imageData.isEmpty {
                  ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                      ForEach(imageData, id: \.self) { imageData in
                        if let uiImage = UIImage(data: imageData) {
                          Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width * 0.35, height: proxy.size.height * 0.20)
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
        .frame(minHeight: proxy.size.height)
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
          place.imageData?.append(data)
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
    place.expirationDate = place.addDate.addingTimeInterval(TimeInterval(expiryValue * timeUnit.expiryInterval))
  }
  
  func daysChecked() {
    if expiryIsInDays {
      expiryIsInWeeks = false
      expiryIsInMonths = false
      expiryIsInYears = false
      timeUnit.unit = .days
      updateExpiryValue()
    }
  }
  
  func weeksChecked() {
    if expiryIsInWeeks {
      expiryIsInDays = false
      expiryIsInMonths = false
      expiryIsInYears = false
      timeUnit.unit = .weeks
      updateExpiryValue()
    }
  }
  
  func monthsChecked() {
    if expiryIsInMonths {
      expiryIsInDays = false
      expiryIsInWeeks = false
      expiryIsInYears = false
      timeUnit.unit = .months
      updateExpiryValue()
    }
  }
  
  func yearsChecked() {
    if expiryIsInYears {
      expiryIsInDays = false
      expiryIsInWeeks = false
      expiryIsInMonths = false
      timeUnit.unit = .years
      updateExpiryValue()
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return EditPlaceView(place: previewer.place)
      .modelContainer(previewer.container)
    
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
