//
//  TripListServiceProvider.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//

import BookingService
import Combine
import Foundation

/*
 ServiceProvider:-
 Service providers encapsulate business logic and data access, abstracting network requests or database interactions.  They provide data to ViewModels, keeping data fetching and processing separate from UI concerns.  This promotes code reusability, testability, and a clean architecture.
 */
protocol TripListServiceProviding: AnyObject {
  var remoteClient: Network { get }
  func fetchBookings(for userId: Int) -> AnyPublisher<[Booking]?, BookingAPIError>
}

class TripListServiceProvider: TripListServiceProviding {
  
  var remoteClient: Network
  
  init(remoteClient: Network) {
    self.remoteClient = remoteClient
  }
    
  //Change: could have been  func fetch() async throws -> [Booking]
  func fetchBookings(for accountId: Int) -> AnyPublisher<[Booking]?, BookingAPIError> {
    remoteClient.fetchBookings(userId: accountId)
      .decode(type: BookingResponse.self, decoder: JSONDecoder())
      .map{$0.bookings}
      .mapError{$0 as? BookingAPIError ?? .serverError}
      .eraseToAnyPublisher()
  }
}
