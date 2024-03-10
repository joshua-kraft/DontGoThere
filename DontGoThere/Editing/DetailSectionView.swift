//
//  DetailSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import SwiftUI

struct DetailSectionView: View {

  @Bindable var place: Place
  @EnvironmentObject var appSettings: AppSettings
  @EnvironmentObject var locationHandler: LocationHandler
  @State var enteredAddress = ""
  @FocusState private var focusedField: Field?

  enum Field: Equatable {
    case addressField
  }

  var body: some View {
    VStack(alignment: .leading) {
      HeaderLabel("Details")
        .padding(.leading)

      Divider()
        .padding(.bottom, 4)

      HStack {
        DetailLabel("Name:")
          .padding([.leading, .trailing])

        TextField("Place Name", text: $place.name)
          .textFieldStyle(.roundedBorder)
          .padding(.trailing)
      }
      .padding(.bottom, 4)

      HStack {
        DetailLabel("Address:")
          .padding([.leading])

        TextField("Address", text: $enteredAddress, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .padding(.trailing)
          .submitLabel(.search)
          .focused($focusedField, equals: .addressField)
          .lineLimit(2, reservesSpace: true)
          .onAppear {
            enteredAddress = place.address.printableAddress
          }
          .onChange(of: enteredAddress) { _, newValue in
            if let lastCharacter = newValue.last {
              if lastCharacter == "\n" {
                focusedField = nil
                updateAddress()
              }
            }
          }
          .onChange(of: place.address) {
            enteredAddress = place.address.printableAddress
          }
          .onChange(of: focusedField) {
            if focusedField == .addressField {
              Task {
                UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
              }
            }
          }
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
            place.expirationDate = place.shouldExpire ?
            appSettings.getExpiryDate(from: place.addDate) :
            Date.distantFuture
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
  }

  @MainActor
  func updateAddress() {
    GeocodingHandler.getCoordinateFromAddress(address: enteredAddress) { placemark in
      if let address = Address(fromPlacemark: placemark) {
        place.address = address
        enteredAddress = address.printableAddress
        place.latitude = placemark.coordinate.latitude
        place.longitude = placemark.coordinate.longitude
      }
    }

    Task { await locationHandler.addConditionToMonitor(condition: place.region, id: place.id.uuidString) }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return DetailSectionView(place: previewer.activePlace)
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
      .environmentObject(LocationHandler.shared)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
