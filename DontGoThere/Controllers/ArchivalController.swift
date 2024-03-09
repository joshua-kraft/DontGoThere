//
//  ArchivalController.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//

import Foundation
import SwiftData

@Observable
class ArchivalController: ObservableObject {
  var modelContext: ModelContext
  var places = [Place]()
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    fetchData()
    print(places.count)
  }
  
  func fetchData() {
    do {
      let descriptor = FetchDescriptor<Place>()
      places = try modelContext.fetch(descriptor)
    } catch {
      print("Fetch failed: \(error.localizedDescription)")
    }
  }
}
