//
//  TimeValuePickerView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/17/24.
//

import SwiftUI

struct TimeValuePickerView: View {
  
  @State private var expiryValue = 1
  @State private var expiryUnit = TimeUnit.months

  @Binding var timeValue: Int
  @Binding var timeUnit: TimeUnit
  @Binding var timeInterval: Double
  
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
  }
    
  func updateExpiryValue() {
    timeUnit = expiryUnit
    timeValue = expiryValue
    timeInterval = {
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
  TimeValuePickerView(timeValue: .constant(1), timeUnit: .constant(.months), timeInterval: .constant(0), labelText: "LABEL", pickerTitle: "PICKER")
}

