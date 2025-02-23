import SwiftUI
import BookingService

@main
struct TripsApp: App {
  
  var body: some Scene {
    WindowGroup {
      showBookings()
    }
  }
}

extension TripsApp {
  
  func showBookings() -> some View {
    let networkEngine = Network(networkLinkConditioner: .highBandwidth)
    let bookingManager = BookingManager()
    let triplistServiceProvider = TripListServiceProvider(remoteClient: networkEngine)
    let triplistCoordinator = TripListCoordinator(accountId: 48098, serviceProvider: triplistServiceProvider, bookingManger: bookingManager)
    return TripBaseView(coordinator: triplistCoordinator)
  }
  
}

/*
 Architecture
  
 Coordinator:-
 Coordinators helps manage navigation and dependencies, decoupling views from these concerns. They orchestrate complex flows, improving testability and maintainability.  This leads to a cleaner, more scalable architecture.
 
 ViewModel:-
  ViewModels hold view-specific data and handle UI logic, acting as a bridge between the Model and the View. They expose data through @Published properties, driving UI updates, and respond to user actions, triggering Model changes or coordinating with a Coordinator.  This separation improves testability and code organization.
 
 ServiceProvider:-
 Service providers encapsulate business logic and data access, abstracting network requests or database interactions.  They provide data to ViewModels, keeping data fetching and processing separate from UI concerns.  This promotes code reusability, testability, and a clean architecture.
 
 Entities:-
 All structs, class definations form entities that constitutes data
 
 Views:-
 All swiftui views
 
 */

/*
 Note:
 Image urls for all the provided user accounts, had a SSL issue in loading, may or may not work depending on the system
 */
