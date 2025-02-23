//
//  TripBaseView.swift
//  Trips
//
//  Created by Abhishek N C on 12/02/25.
//
import BookingUI
import Foundation
import SwiftUI
/*
 Base view which holds coordinator for internal navigation, actions with DI
 */
struct TripBaseView<Coordinator>: View where Coordinator: TripListCoordinating & ObservableObject {
  @StateObject var coordinator: Coordinator
  
  var body: some View {
    NavigationView {
      TripListView(viewModel: coordinator.viewModel)
          .navigationTitle("My bookings")
          .font(BUI.Font.headline1.swiftUIFont)
          .foregroundColor(BUI.Color.background.swiftUIColor)
          .padding(.bottom, 32)
          .navigationBarTitleDisplayMode(.inline)
    }
    .onAppear {
      coordinator.viewModel.viewEventSubject.send(.viewDidLoad)
    }
  }
}
