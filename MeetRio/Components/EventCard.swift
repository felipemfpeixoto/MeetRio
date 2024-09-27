//
//  EventCard.swift
//  MeetRio
//
//  Created by Felipe on 10/08/24.
//

import SwiftUI
import Foundation

struct EventCard: View {
    
    let event: EventDetails
    
    let dateFormatter = DateFormatter()
    
    let calendar = Calendar.current
    
    @Binding var selected: EventDetails?
    
    let weekdays = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat"
    ]
    
    var body: some View {
        ZStack {
            imageComponent
            bottomComponent
            dateComponent
            buttonContainer
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
        .onAppear {
            dateFormatter.dateFormat = "EEE"
            dateFormatter.locale = Locale(identifier: "pt_BR")
        }
    }
    
    var imageComponent: some View {
        ZStack {
            if event.photo != nil {
                Image(uiImage: UIImage(data: event.photo!)!)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Image("defaultImage")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    var bottomComponent: some View {
        VStack {
            Spacer()
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                HStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(event.name)
                            .font(Font.custom("Nunito", size: 20).weight(.semibold))
                        Text(event.address.neighborhood)
                            .font(Font.custom("Nunito", size: 20))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .padding()
            }
            .frame(height: 95)
        }
    }
    
    var dateComponent: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
                    VStack(spacing: -5) {
                        Text("\(event.dateDetails)")
                            .font(Font.custom("Nunito", size: 20).weight(.semibold))
                            .foregroundStyle(.black)
//                        Text("\(calendar.component(.day, from: event.dateDetails.startDate))")
//                            .font(Font.custom("Nunito", size: 20).weight(.semibold))
                    }
                }
                .frame(width: 58, height: 58)
                Spacer()
            }
            Spacer()
        }
        .frame(height: 80)
        .padding()
    }
    
    var buttonContainer: some View { //  Acho que isso n ta legal nn
        VStack {
            Spacer()
            HStack(spacing: 5) {
                Spacer()
                
                    Button {
                        withAnimation(Animation.easeInOut(duration: 0.5)) {
                            selected = event
                        }
                    } label: {
                        Image(systemName: "star")
                            .foregroundStyle(.black)
                            .font(.title2)
                    }
                Image(systemName: "checkmark.seal")
                    .foregroundStyle(.black)
                    .font(.title2)
            }
        }
        .frame(height: 160)
        .padding()
    }
}

//#Preview {
//    EventCard(event: EventDetails(
//        name: "SIBC",
//        description: "",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Avenida Padre Leonel Franca", number: "215", neighborhood: "Gávea", postalCode: "11111111"),
//        location: LocationDetails(latitude: -23, longitude: -43),
//        eventCategory: EventCategory.bemBrazil.rawValue, safetyRate: 5, tips: "oi", url: "oi"
//        ),
//        selected: .constant(nil)
//    )
//}
