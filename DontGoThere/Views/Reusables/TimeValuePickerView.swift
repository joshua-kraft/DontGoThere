//
//  TimeValuePickerView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/17/24.
//

import SwiftUI

struct TimeValuePickerView: View {
  
  enum TimeUnit: String, CaseIterable {
    case days = "Day(s)"
    case weeks = "Week(s)"
    case months = "Month(s)"
    case years = "Year(s)"
  }

  @State private var expiryValue = 1
  @State private var expiryUnit = TimeUnit.months
  @State private var expiryIsInDays = false
  @State private var expiryIsInWeeks = false
  @State private var expiryIsInMonths = true
  @State private var expiryIsInYears = false
  
  @Binding var timeIntervalValue: Double
  
  let labelText: String
  let pickerTitle: String

  
  var body: some View {
    HStack {
      Text(labelText)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.leading)
      
      Spacer()
      
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
      
      Spacer()
      
      Picker("Temporal Unit", selection: $expiryUnit) {
        ForEach(TimeUnit.allCases, id: \.self) { unit in
          Text(unit.rawValue)
        }
      }
      .labelsHidden()
      .onChange(of: expiryUnit) {
        updateExpiryValue()
      }
    }
    .padding(.bottom, 4)
    .onAppear {
      updateExpiryValue()
    }
  }
    
  func updateExpiryValue() {
    timeIntervalValue = {
      switch expiryUnit {
      case .days:
        return 1 * 86400 * Double(expiryValue)
      case .weeks:
        return 7 * 86400 * Double(expiryValue)
      case .months:
        return 30 * 86400 * Double(expiryValue)
      case .years:
        return 365 * 86400 * Double(expiryValue)
      }
    }()
    
  }

}

#Preview {
  TimeValuePickerView(timeIntervalValue: .constant(0), labelText: "LABEL", pickerTitle: "VALUE")
}

