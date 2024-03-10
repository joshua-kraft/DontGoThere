//
//  PlacesList.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/15/24.
//

import SwiftData
import SwiftUI

struct PlacesList: View {
  @Environment(\.modelContext) var modelContext
  @Query(sort: \Place.name) var places: [Place]

  let listTyoe: String
  let searchString: String

  var body: some View {
    if places.isEmpty {
      if searchString.isEmpty {
        ContentUnavailableView {
          DontGoThereUnavailableLabel("No \(listTyoe) Places")
        } description: {
          if listTyoe == "Active" {
            Text("You don't have any active places. ")
            + Text("Add a new one by tapping the add icon in the toolbar or going to the PlaceMap.")
          } else {
            Text("You don't have any archived places. ")
            + Text("Places archive themselves after their expiration date. ")
            + Text("They also archive themselves after the max notification count you set is reached. ")
            + Text("Or, you can archive them yourself.")
          }
        }
      } else {
        ContentUnavailableView.search
          .imageScale(.large)
      }
    } else {
      List {
        ForEach(places) { place in
          NavigationLink(value: place) {
            HStack {
              VStack(alignment: .leading) {
                Text(place.name)
                  .font(.headline)
                Text(place.displayNotes)
                  .font(.subheadline)
              }

              Spacer()

              VStack(alignment: .trailing) {
                Text("Added: \(place.formattedAddDate)")
                  .font(.footnote)
                Text("\(place.isArchived ? "Expired:" : "Expires") \(place.formattedExpirationDate)")
                  .font(.footnote)
              }
            }
          }
          .swipeActions {
            if place.isArchived {
              Button("Delete", systemImage: "trash", role: .destructive) {
                modelContext.delete(place)
              }
              Button("Unarchive", systemImage: "archivebox", role: .destructive) {
                withAnimation {
                  place.isArchived.toggle()
                }
              }
              .tint(.green)
            } else {
              Button("Archive", systemImage: "archivebox", role: .destructive) {
                withAnimation {
                  place.isArchived.toggle()
                }
              }
              .tint(.orange)

              Button("Delete", systemImage: "trash", role: .destructive) {
                modelContext.delete(place)
              }
            }
          }
          .tag(place)
        }
        .onDelete(perform: deletePlaces)
      }
    }
  }

  func deletePlaces(at offsets: IndexSet) {
    for offset in offsets {
      let place = places[offset]
      modelContext.delete(place)
    }
  }

  init(filteredBy searchString: String = "", sortedBy sortOrder: [SortDescriptor<Place>] = [], archived: Bool = false) {
    _places = Query(filter: #Predicate { place in
      if archived == place.isArchived {
        if searchString.isEmpty {
          return true
        } else {
          return place.name.localizedStandardContains(searchString)
          || place.review.localizedStandardContains(searchString)
        }
      } else {
        return false
      }
    }, sort: sortOrder)

    self.listTyoe = archived ? "Archived" : "Active"
    self.searchString = searchString
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return PlacesList()
      .modelContainer(previewer.container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
