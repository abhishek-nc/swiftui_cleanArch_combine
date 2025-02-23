//
//  Booking.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//

import Foundation

struct BookingResponse: Codable {
    let bookings: [Booking]
}

struct Booking: Codable, Identifiable {
  let checkin: Date
  let id: Int64
  let booker: User
  let checkout: Date
  let hotel: Hotel
  
  // Custom coding keys to handle date conversion
  enum CodingKeys: String, CodingKey {
    case id, booker, hotel, checkin, checkout
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(Int64.self, forKey: .id)
    booker = try container.decode(User.self, forKey: .booker)
    hotel = try container.decode(Hotel.self, forKey: .hotel)
    
    let dateFormatter = ISO8601DateFormatter()
    
    let checkinString = try container.decode(String.self, forKey: .checkin)
    guard let checkinDate = dateFormatter.date(from: checkinString) else {
      throw DecodingError.dataCorruptedError(forKey: .checkin, in: container, debugDescription: "Invalid date format")
    }
    checkin = checkinDate
    
    let checkoutString = try container.decode(String.self, forKey: .checkout)
    guard let checkoutDate = dateFormatter.date(from: checkoutString) else {
      throw DecodingError.dataCorruptedError(forKey: .checkout, in: container, debugDescription: "Invalid date format")
    }
    checkout = checkoutDate
  }
}

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
}

struct Hotel: Codable {
    let id: Int64
    let cityName: String
    let name: String
    let heroImageUrl: String
}
