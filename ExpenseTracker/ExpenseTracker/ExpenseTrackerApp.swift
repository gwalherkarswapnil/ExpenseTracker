//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
import SwiftData

import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ExpenseTrackerApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
              LoginView(theme: Theme(backgroundColor: .blue, primaryColor: .accentColor, secondaryColor: .white))
              //HomeContentView()
                  .preferredColorScheme(.light)
          }
          .modelContainer(sharedModelContainer)
      }
}
