//
//  TripCoordinator.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//

import Combine
import Foundation

/*
 Coordinators : 
 Helps manage navigation and dependencies, decoupling views from these concerns. They orchestrate complex flows, improving testability and maintainability.  This leads to a cleaner, more scalable architecture.
 */

protocol TripListCoordinating {
  var viewModel: TripListViewModel { get set }
  var serviceProvider: TripListServiceProviding { get }
}

class TripListCoordinator: ObservableObject, TripListCoordinating {
  @Published var viewModel: TripListViewModel //change: should have been TripListViewModeling
  var serviceProvider: TripListServiceProviding
  
  
  // MARK: Initializatio
  init(accountId: Int, serviceProvider: TripListServiceProviding, bookingManger: BookingManaging) {
    self.serviceProvider = serviceProvider
    self.viewModel = TripListViewModel(accountId: accountId, serviceProvider: serviceProvider, bookingManager: bookingManger)
  }
  
  // MARK: Methods
  func showTripDetails() {
  }
}
