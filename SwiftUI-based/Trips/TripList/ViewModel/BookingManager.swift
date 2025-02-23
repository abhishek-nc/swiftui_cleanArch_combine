//
//  BookingManager.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//

import Foundation

protocol BookingManaging {
    func groupBookingsByStatus(_ bookings: [Booking]) -> [TripStatus: [Booking]]
    func findBookingChains(_ bookings: [Booking]) -> [BookingChain]
    func getBookingChainTitle(for bookings: [Booking]) -> String
    func getBookingChainDates(for bookings: [Booking]) -> String
}

// MARK: - Business Logic
struct BookingManager: BookingManaging {
  
  // Group bookings by status
  func groupBookingsByStatus(_ bookings: [Booking]) -> [TripStatus: [Booking]] {
    let now = Date()
    return Dictionary(grouping: bookings) { booking in
      booking.checkout < now ? .past : .upcoming
    }
  }
  
  // Find chains of consecutive bookings
  func findBookingChains(_ bookings: [Booking]) -> [BookingChain] {
    // Sort bookings by check-in date
    let sortedBookings = bookings.sorted { $0.checkin < $1.checkin }
        
    var chains: [BookingChain] = []
    var currentChain: [Booking] = []
    
    for booking in sortedBookings {
      if let lastBooking = currentChain.last {
        // Consider bookings as chained if they start on the same day
        // (using calendar to ignore time components)
        if Calendar.current.isDate(booking.checkin, inSameDayAs: lastBooking.checkout) {
          currentChain.append(booking)
        } else {
          // If there's a gap, start a new chain
          if !currentChain.isEmpty {
            chains.append(createBookingChain(bookings: currentChain))
          }
          currentChain = [booking]
        }
      } else {
        // Start first chain
        currentChain = [booking]
      }
    }
    
    // Add the last chain if it exists
    if !currentChain.isEmpty {
      chains.append(createBookingChain(bookings: currentChain))
    }
    
    return chains
  }
  
  func createBookingChain(bookings:[Booking]) -> BookingChain {
    let bookingChainDates = self.getBookingChainDates(for: bookings)
    let bookingChainTitle = self.getBookingChainTitle(for: bookings)
    return BookingChain(bookings: bookings, title: bookingChainTitle, dateRange: bookingChainDates)
  }
  
  func getBookingChainTitle(for bookings: [Booking]) -> String {
    let sortedBookings = bookings.sorted { $0.checkin < $1.checkin }
    let uniqueCities = sortedBookings
      .map { $0.hotel.cityName }
      .reduce(into: [String]()) { result, city in
        if !result.contains([city])  {
          result.append(city)
        }
      }
    
    switch uniqueCities.count {
    case 0:
      return "Trip details unavailable"
    case 1:
      return "Trip to \(uniqueCities[0])"
    case 2:
      return "Trip to \(uniqueCities[0]) and \(uniqueCities[1])"
    default:
      let allButLast = uniqueCities.dropLast().joined(separator: ", ")
      let last = uniqueCities.last!
      return "Trip to \(allButLast), and \(last)"
    }
  }
  
  func getBookingChainDates(for bookings: [Booking]) -> String {
    let sortedBookings = bookings.sorted { $0.checkin < $1.checkin }
    guard let firstBooking = sortedBookings.first,
          let lastBooking = sortedBookings.last else {
      return "No dates available"
    }
    
    let calendar = Calendar.current
    let startYear = calendar.component(.year, from: firstBooking.checkin)
    let endYear = calendar.component(.year, from: lastBooking.checkout)
    
    // Format for day
    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "dd"
    let startDay = dayFormatter.string(from: firstBooking.checkin)
    let endDay = dayFormatter.string(from: lastBooking.checkout)
    
    // Custom month formatter for abbreviated months
    let getMonthAbbr = { (date: Date) -> String in
      let month = calendar.component(.month, from: date)
      let abbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                           "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
      return abbreviations[month - 1]
    }
    
    let startMonth = getMonthAbbr(firstBooking.checkin)
    let endMonth = getMonthAbbr(lastBooking.checkout)
    
    // Build date range string based on whether dates are in same month/year
    if startYear == endYear {
      if startMonth == endMonth {
        return "\(startDay) - \(endDay) \(startMonth) \(startYear)"
      } else {
        return "\(startDay) \(startMonth) - \(endDay) \(endMonth) \(startYear)"
      }
    } else {
      return "\(startDay) \(startMonth) \(startYear) - \(endDay) \(endMonth) \(endYear)"
    }
  }
}
