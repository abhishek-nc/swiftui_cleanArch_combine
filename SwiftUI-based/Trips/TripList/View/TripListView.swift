//
//  TripListView.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//
import BookingUI
import Foundation
import SwiftUI
/*
 List view which is responsible for showing upcoming and past booking chains which interacts with viewModel
 */
struct TripListView<ViewModel>: View where ViewModel:TripListViewModeling {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    //Change: some view with function
    if viewModel.isLoading {
      //Loading view
      ProgressView()
        .progressViewStyle(.circular)
        .frame(maxWidth: .infinity, alignment: .center)
        .scaleEffect(1.5)
    } else if let message = viewModel.errorMessage {
      //Error handling
      Text(message)
        .foregroundColor(.red)
        .frame(maxWidth: .infinity, alignment: .center) // Center the error message
    } else {
      //Change: Lazy loading, pagiantion,
      List {
        //Avaialable Booking states
        ForEach(viewModel.findAvailableBookingStates(), id: \.self) { section in
          Section(header:Text(section)
            .font(BUI.Font.headline2.swiftUIFont)
            .foregroundColor(.primary)
            .textCase(nil)
            .padding(.leading,16)
          ) {
            //Booking chains, //Change: dispatch on global queue
            ForEach(viewModel.findBookingChain(for: TripStatus(rawValue: section) ?? .past), id: \.id) { booking in
              BookingChainCardView(bookingChain: booking)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
          }
          .padding(.top, 8)
          .listRowSeparator(.hidden)
          .listSectionSpacing(16)
          .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        //Change: how do you debug views and code, breakpoints
      }
      .listStyle(.plain)
    }
  }
}


/*
 embedding in Uikit/swiftui
 
 passing data between swiftui and uikit
 
 profiling and debugging SwiftUI apps
 
 */
