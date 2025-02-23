//
//  BookingChain.swift
//  Trips
//
//  Created by Abhishek N C on 13/02/25.
//
import Foundation

struct BookingChain {
  let id = UUID()
  let bookings: [Booking]
  
  // Updated title with "Trip to" prefix of cities
  var title: String
  
  // Count of bookings in the chain
  var count: String {
    let bookingString = bookings.count == 1 ? "booking" : "bookings"
    return bookings.count.description + " " + bookingString
  }
  
  // Date range of trip
  var dateRange: String
  
  // Image url
  var banner: String {
    return bookings.first?.hotel.heroImageUrl ?? ""
  }
}
