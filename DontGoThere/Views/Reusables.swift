//
//  Reusables.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/17/24.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      withAnimation {
        configuration.isOn.toggle()
      }
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
        configuration.label
      }
    })
    .buttonStyle(.plain)
  }
}



struct TimeValuePickerView: View {
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

  @State private var timeUnit = TimeUnit(unit: .months)
  @State private var expiryValue = 1
  @State private var expiryIsInDays = false
  @State private var expiryIsInWeeks = false
  @State private var expiryIsInMonths = true
  @State private var expiryIsInYears = false
  
  @Binding var timeIntervalValue: Int
  
  let labelText: String
  let pickerTitle: String

  
  var body: some View {
    HStack {
      Text(labelText)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.leading)
      
      Picker(pickerTitle, selection: $expiryValue) {
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
    .onAppear {
      updateExpiryValue()
    }
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
  
  func updateExpiryValue() {
    timeIntervalValue = timeUnit.expiryInterval * expiryValue
  }

}

#Preview {
  TimeValuePickerView(timeIntervalValue: .constant(0), labelText: "LABEL", pickerTitle: "VALUE")
}

