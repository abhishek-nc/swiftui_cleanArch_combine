//
//  BookingChainCardView.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//
import BookingUI
import Foundation
import SwiftUI
/*
 Card view which represents booking chain
 */
struct BookingChainCardView: View {
  let bookingChain: BookingChain
    
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Image
      AsyncImage(url: URL(string: bookingChain.banner)) { phase in
        switch phase {
        case .empty:
          ProgressView()
            .frame(maxWidth: .infinity, alignment: .center)
        case .success(let image):
          image
            .resizable()
            .aspectRatio(16/9, contentMode: .fill)
        case .failure(_):
          // Image error handling
          VStack {
            Image(systemName: "photo")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundColor(.black)
              .frame(width: 50, height: 50)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.gray.opacity(0.3))
        @unknown default:
          EmptyView()
        }
      }
      .frame(height: 200)
      .clipped()
      
      // Trip Info
      VStack(alignment: .leading, spacing: 0) {
        Text(bookingChain.title)
          .font(BUI.Font.headline3.swiftUIFont)
          .foregroundColor(BUI.Color.foreground.swiftUIColor)
          .padding(.bottom, 8)
          .onAppear {
                          print("title appeared: \(bookingChain.title)")
                      }
        
        // Date range
        Text(bookingChain.dateRange)
          .font(BUI.Font.body2.swiftUIFont)
          .foregroundColor(BUI.Color.foreground.swiftUIColor)
          .onAppear {
                          print("dateRange appeared: \(bookingChain.dateRange)")
                      }
        
        // Booking count
        Text(bookingChain.count.description)
          .font(BUI.Font.body2.swiftUIFont)
          .foregroundColor(BUI.Color.foreground.swiftUIColor)
      }
      .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
      
    }
    .background(BUI.Color.backgroundElevationTwo.swiftUIColor)
    .cornerRadius(8)
    .shadow(
      color: Color.black.opacity(0.16),
      radius: 8,
      x: 0,
      y: 0
    )
  }
}

