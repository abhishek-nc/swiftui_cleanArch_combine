//
//  TripListViewModel.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//
import Combine
import Foundation

enum TripListViewEvent {
    case viewDidLoad
    case didSelect(trip: Booking)
}

enum TripStatus:String, CaseIterable {
  case upcoming = "Upcoming trips"
  case past = "Past trips"
}

/*
 ViewModels hold view-specific data and handle UI logic, acting as a bridge between the Model and the View. They expose data through @Published properties, driving UI updates, and respond to user actions, triggering Model changes or coordinating with a Coordinator.  This separation improves testability and code organization.
 */

protocol TripListViewModeling: ObservableObject {
  var accountId: Int { get }
  var upcomingBookingChain: [BookingChain] { get }
  var pastBookingChain: [BookingChain] { get }
  var isLoading: Bool { get }
  var errorMessage: String? { get }
  var viewEventSubject: PassthroughSubject<TripListViewEvent, Never> { get }
  
  func subscribeToViewEvents()
  func fetchBookings()
  func findBookingChain(for status: TripStatus) -> [BookingChain]
  func findAvailableBookingStates() -> [String]
}

class TripListViewModel: TripListViewModeling {
  var accountId: Int
  @Published var upcomingBookingChain: [BookingChain] = []
  @Published var pastBookingChain: [BookingChain] = []
  @Published var isLoading: Bool = true
  @Published var errorMessage: String? = nil
  private var cancellables: Set<AnyCancellable> = []
  
  private var bookingManager: BookingManaging
  weak var serviceProvider: TripListServiceProviding?
  let viewEventSubject = PassthroughSubject<TripListViewEvent, Never>()
  
  init(accountId: Int, serviceProvider: TripListServiceProviding, bookingManager: BookingManaging) {
    self.serviceProvider = serviceProvider
    self.accountId = accountId
    self.bookingManager = bookingManager
    subscribeToViewEvents()
  }
  
  /*
   Listen to view events
   */
  func subscribeToViewEvents() {
    viewEventSubject
      .sink { event in
        switch event {
        case .viewDidLoad:
          self.fetchBookings()
          
        case .didSelect(_): break
          //forward to coordinator for showing booking details
        }
      }
      .store(in: &cancellables)
  }
}

extension TripListViewModel {
  /*
   Fetch bookings from service provider
   */
  func fetchBookings() {
    //Show loader
    isLoading = true
    self.serviceProvider?.fetchBookings(for: accountId)
      .receive(on: RunLoop.main)
      .map{ $0 ?? [] }
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished : break
        case .failure(let error):
          //Error handling
          self.errorMessage = error.errorDescription
        }
        self.isLoading = false
      }, receiveValue:{ bookings in
        
        //Group and chain bookings
        let bookingMap = self.bookingManager.groupBookingsByStatus(bookings)
        self.pastBookingChain = self.bookingManager.findBookingChains(bookingMap[.past] ?? [])
        self.upcomingBookingChain = self.bookingManager.findBookingChains(bookingMap[.upcoming] ?? [])
        
        //Empty booking
        if bookings.isEmpty {
          self.errorMessage = "No Bookings Made"
        }
      })
      .store(in: &self.cancellables)
  }
  
  /*
   Find Bookingchain for status
   */
  func findBookingChain(for status: TripStatus) -> [BookingChain] {
    switch status {
    case .past : pastBookingChain
    case .upcoming : upcomingBookingChain
    }
  }
  
  /*
   Find booking status eligible for user
   */
  func findAvailableBookingStates() -> [String] {
    var bookingStates: [String] = []
    for item in TripStatus.allCases {
      if !findBookingChain(for: item).isEmpty {
        bookingStates.append(item.rawValue)
      }
    }
    return bookingStates
  }
}
