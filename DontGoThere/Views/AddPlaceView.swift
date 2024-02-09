//
//  AddView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftUI

struct AddPlaceView: View {
  
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
  
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  
  @State private var name = ""
  @State private var notes = ""
  @State private var review = ""
  
  @State private var addDate = Date.now
  @State private var expiryValue = 3
  
  @State private var timeUnit = TimeUnit(unit: .months)
  @State private var shouldAutoCalcExpiry = true
  @State private var expiryIsInDays = false
  @State private var expiryIsInWeeks = false
  @State private var expiryIsInMonths = true
  @State private var expiryIsInYears = false
  
  @State private var expiryDate = Date.now
  
  var imageNames = [String]()
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Place's name...", text: $name)
          TextField("Some short notes...", text: $notes)
        }
        
        Section {
          DatePicker("Added", selection: $addDate, displayedComponents: .date)
            .disabled(true)
            .font(.headline)
            .foregroundStyle(.secondary)
          
          HStack {
            Text("Expires")
              .font(.headline)
              .foregroundStyle(.secondary)
            
            Spacer()
            Toggle(isOn: $shouldAutoCalcExpiry) {
              Text("Auto")
            }
            .toggleStyle(CheckboxToggleStyle())
            Spacer()
            
            DatePicker("Expires", selection: $expiryDate, displayedComponents: .date)
              .labelsHidden()
              .disabled(shouldAutoCalcExpiry)
          }
          
          if !shouldAutoCalcExpiry {
            HStack {
              Text("Set to expire in")
                .font(.headline)
                .foregroundStyle(.secondary)
              
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
            }
            .disabled(shouldAutoCalcExpiry)
          }
        }
        
        
      }
    }
    .onAppear {
      updateExpiryValue()
    }
  }
  
  func updateExpiryValue() {
    expiryDate = addDate.addingTimeInterval(TimeInterval(expiryValue * timeUnit.expiryInterval))
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
  AddPlaceView()
}
