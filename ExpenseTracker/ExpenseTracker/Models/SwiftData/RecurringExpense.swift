//
//  RecurringExpense.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import Foundation
import SwiftData


@Model
final class RecurringExpense {
    var amount: Double
  //  var frequency: Frequency
    var note: String
    var startDate: Date
    var endDate: Date?

    init(amount: Double, frequency: Frequency, note: String, startDate: Date, endDate: Date?) {
        self.amount = amount
        self.note = note
        self.startDate = startDate
        self.endDate = endDate
    }
}
