//
//  DetailView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import MapKit
import SwiftData
import SwiftUI

struct DetailView: View {
  
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
  
  @Bindable var place: Place
  
  @State private var timeUnit = TimeUnit(unit: .months)
  @State private var shouldAutoCalcExpiry = true
  @State private var expiryValue = 3
  @State private var expiryIsInDays = false
  @State private var expiryIsInWeeks = false
  @State private var expiryIsInMonths = true
  @State private var expiryIsInYears = false

  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        Map(initialPosition: position(for: place), interactionModes: []) {
          Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
        }
        .frame(idealHeight: 225)
        
        VStack(alignment: .leading) {
          Text("Details")
            .font(.title3)
            .foregroundStyle(.secondary)
            .padding(.leading)
          
          Divider()
            .padding(.bottom, 4)
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
              .padding(.leading)
              .onChange(of: shouldAutoCalcExpiry) { if !shouldAutoCalcExpiry { updateExpiryValue() } }
            }
            .padding(.bottom, 4)
            
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
          
          HStack {
            Text("Images")
              .font(.title3)
              .foregroundStyle(.secondary)
            
            Spacer()
            
            Button("Add Images", systemImage: "photo.badge.plus") {
              // bring up a photo picker and save the images
            }
          }
          .padding([.leading, .trailing])
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              ForEach(place.imageNames, id: \.self) { imageName in
                Image(imageName)
                  .resizable()
                  .frame(width: 160, height: 160)
                  .clipShape(.rect(cornerRadius: 5))
              }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 4)
          }
          
          Divider()
            .padding(.bottom, 4)
          
          Text("Review")
            .font(.title3)
            .foregroundStyle(.secondary)
            .padding(.leading)
          
          TextField("Review", text: .constant(place.review), axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding([.leading, .trailing])
        }
      }
      .navigationTitle(place.name)
      .navigationBarTitleDisplayMode(.inline)
      .background(.thinMaterial)
    }
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Place.self, configurations: config)
    let examplePlace = Place(name: "Example Place Name", notes: "Example Notes Text", review: "This is a longer sentence that is being used as the preview review for this example place in order to wrap the TextField inside the preview.", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(7 * 86400), imageNames: ["example1a", "example1b", "example1c"])
    
    return DetailView(place: examplePlace)
      .modelContainer(container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
