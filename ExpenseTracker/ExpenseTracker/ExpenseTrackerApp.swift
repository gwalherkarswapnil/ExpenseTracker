//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Swapnil on 28/10/24.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
          let scheme = Schema([
              // entities here
              Expense.self,
              Category.self
          ])
          
          let modelConfiguration = ModelConfiguration(schema: scheme,
                                                      isStoredInMemoryOnly: false)
          do {
              return try ModelContainer(for: scheme, configurations: modelConfiguration)
          } catch {
              fatalError("Could not create model container \(error)")
          }
      
      }()
      
      var body: some Scene {
          WindowGroup {
              HomeContentView()
                  .preferredColorScheme(.light)
          }
          .modelContainer(sharedModelContainer)
      }
}
