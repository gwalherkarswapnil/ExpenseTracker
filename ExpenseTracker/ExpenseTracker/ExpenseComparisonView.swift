//
//  ExpenseComparisonView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
import Charts
import SwiftData

import SwiftUI
import Charts
import SwiftData

struct ExpenseComparisonView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]  // This will fetch all expenses
    
    @State private var selectedPeriod: Period = .monthly
    @State private var expenseData: [ExpenseData] = []
    
    enum Period: String, CaseIterable, Identifiable {
        case daily = "Daily"
        case monthly = "Monthly"
        case quaterly = "Quaterly"
        case yearly = "Yearly"
        
        var id: String { self.rawValue }
    }
    
    struct ExpenseData {
        let period: String
        let thisPeriodTotal: Double
        let lastPeriodTotal: Double
    }
    
    var body: some View {
        VStack {
            Text("Expense Comparison")
                .font(.headline)
                .padding(.top)
            
            Picker("Period", selection: $selectedPeriod) {
                ForEach(Period.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedPeriod) { _ in
                loadExpenseData()
            }
            
            Chart {
                ForEach(expenseData, id: \.period) { data in
                    BarMark(
                        x: .value("Period", data.period),
                        y: .value("This Period", data.thisPeriodTotal)
                    )
                    .foregroundStyle(.blue)
                    .annotation(position: .top) {
                        Text(String(format: "%.2f", data.thisPeriodTotal))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    BarMark(
                        x: .value("Period", data.period),
                        y: .value("Last Period", data.lastPeriodTotal)
                    )
                    .foregroundStyle(.red)
                    .annotation(position: .top) {
                        Text(String(format: "%.2f", data.lastPeriodTotal))
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(height: 300)
            .padding()
            
            HStack {
                Circle().fill(Color.blue).frame(width: 10, height: 10)
                Text("This Period")
                    .font(.caption)
                Spacer()
                Circle().fill(Color.red).frame(width: 10, height: 10)
                Text("Last Period")
                    .font(.caption)
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .padding()
        .onAppear {
            loadExpenseData()
        }
    }
    
    // Method to load and group expenses by the selected period
    private func loadExpenseData() {
        // Group expenses based on the selected period
        let groupedExpenses = groupExpensesByPeriod(expenses, period: selectedPeriod)
        let thisPeriodData = calculateTotalExpenses(for: groupedExpenses.thisPeriod)
        let lastPeriodData = calculateTotalExpenses(for: groupedExpenses.lastPeriod)
        
        // Update expenseData for the chart
        expenseData = zip(thisPeriodData, lastPeriodData).map { (this, last) in
            ExpenseData(period: this.period, thisPeriodTotal: this.total, lastPeriodTotal: last.total)
        }
    }
    
    // Group expenses based on the period type
    private func groupExpensesByPeriod(_ expenses: [Expense], period: Period) -> (thisPeriod: [Date: [Expense]], lastPeriod: [Date: [Expense]]) {
        let calendar = Calendar.current
        let currentDate = Date()
        
        switch period {
        case .daily:
            let thisPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, inSameDayAs: currentDate) }, by: { calendar.startOfDay(for: $0.date) })
            let lastPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: currentDate)!) }, by: { calendar.startOfDay(for: $0.date) })
            return (thisPeriod, lastPeriod)
            
        case .monthly:
            let thisPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, equalTo: currentDate, toGranularity: .month) }, by: { calendar.dateInterval(of: .day, for: $0.date)!.start })
            let lastPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, equalTo: calendar.date(byAdding: .month, value: -1, to: currentDate)!, toGranularity: .month) }, by: { calendar.dateInterval(of: .day, for: $0.date)!.start })
            return (thisPeriod, lastPeriod)
        case .quaterly:
            let thisPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, equalTo: currentDate, toGranularity: .month) }, by: { calendar.dateInterval(of: .day, for: $0.date)!.start })
            let lastPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, equalTo: calendar.date(byAdding: .month, value: -1, to: currentDate)!, toGranularity: .month) }, by: { calendar.dateInterval(of: .day, for: $0.date)!.start })
            return (thisPeriod, lastPeriod)
        case .yearly:
            let thisPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, equalTo: currentDate, toGranularity: .year) }, by: { calendar.dateInterval(of: .month, for: $0.date)!.start })
            let lastPeriod = Dictionary(grouping: expenses.filter { calendar.isDate($0.date, equalTo: calendar.date(byAdding: .year, value: -1, to: currentDate)!, toGranularity: .year) }, by: { calendar.dateInterval(of: .month, for: $0.date)!.start })
            return (thisPeriod, lastPeriod)
        }
    }
    
    // Calculate total expenses for each period
    private func calculateTotalExpenses(for groupedExpenses: [Date: [Expense]]) -> [(period: String, total: Double)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return groupedExpenses.map { (date, expenses) in
            let total = expenses.reduce(0) { $0 + $1.amount }
            return (period: dateFormatter.string(from: date), total: total)
        }
        .sorted { $0.period < $1.period } // Sort by period
    }
}

#Preview {
    ExpenseComparisonView()
}
