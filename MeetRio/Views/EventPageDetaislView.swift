//
//  eventPageDetaislView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 26/08/24.
//

import Foundation
import SwiftUI
import CoreLocation
import PostHog

struct EventPageDetaislView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var isSheetOpen: Bool = false
    @State var isAlsoGoing: [Hospede] = []
    
    let event: EventDetails
    let reviewList: [Review] = [Review(rate: 4, date: Date.now, description: "Muito bom, gostei bastante do local."), Review(rate: 2, date: Date.now, description: "Não gostei.")]
    
    @State var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                PeopleGoingView(isLoading: isLoading, isAlsoGoing: isAlsoGoing)
                    .padding([.horizontal, .bottom])
                    .padding(.top, 30)
                
                if event.buyURL != nil {
                    BuyButtonView(buyURL: event.buyURL)
                        .padding()
                }
                
                LocationView(event: event)
                    .padding()
                
                TipsView(tips: event.tips)
                    .padding()
            }
            .onAppear {
                loadPeopleGoing()
            }
        }
    }
    
    func loadPeopleGoing() {
        Task {
            isLoading = true
            isAlsoGoing = try await FirestoreManager.shared.getGoingEvent(event.id!)
            isLoading = false
        }
    }
}

@available(iOS 18, *)
struct EventPageDetaislViewIOS18: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var isSheetOpen: Bool = false
    @State var isAlsoGoing: [Hospede] = []
    
    let event: EventDetails
    let reviewList: [Review] = [Review(rate: 4, date: Date.now, description: "Muito bom, gostei bastante do local."), Review(rate: 2, date: Date.now, description: "Não gostei.")]
    
    @State var isLoading = false
    let translationManager: TranslationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                PeopleGoingView(isLoading: isLoading, isAlsoGoing: isAlsoGoing)
                    .padding([.horizontal, .bottom])
                    .padding(.top, 30)
                
                if let buyURL = event.buyURL {
                    BuyButtonView(buyURL: buyURL)
                        .padding()
                }
                
                LocationView(event: event)
                    .padding()
                
                TipsView(tips: event.tips)
                    .padding()
            }
            .onAppear {
                loadPeopleGoingAndTranslateTips()
            }
        }
    }
    
    func loadPeopleGoingAndTranslateTips() {
        Task {
            isLoading = true
            isAlsoGoing = try await FirestoreManager.shared.getGoingEvent(event.id!)
            isLoading = false
            translationManager.translatedTexts[1] = event.tips
        }
    }
}

struct PeopleGoingView: View {
    let isLoading: Bool
    let isAlsoGoing: [Hospede]
    
    var body: some View {
        VStack {
            Text("Who is also going")
                .font(Font.custom("Bricolage Grotesque", size: 23).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isLoading {
                ProgressView()
            } else if isAlsoGoing.isEmpty {
                Text("No one is going yet")
                    .padding(.top, 5)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(isAlsoGoing, id: \.self.id) { hospede in
                            PersonWhoGoes(hospede: hospede)
                                .padding(.leading, 1)
                        }
                    }
                }
            }
        }
    }
}


struct BuyButtonView: View {
    let buyURL: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tickets")
                .font(Font.custom("Bricolage Grotesque", size: 23).bold())
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                PostHogSDK.shared.capture("ClicouComprar")
                if let url = URL(string: buyURL!) {
                    UIApplication.shared.open(url)
                }
            }, label: {
                Text("Buy now")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10.0)
                            .foregroundStyle(Color("Blue1"))
                    )
            })
        }
    }
}


struct LocationView: View {
    let event: EventDetails
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Location")
                .font(Font.custom("Bricolage Grotesque", size: 23).bold())
                .padding(.bottom, 5)
            
            Text(event.address.details ?? "")
                .foregroundStyle(Color("DarkBlue"))
                .fontWeight(.bold)
            
            Text("\(event.address.street), \(event.address.number)")
                .fontWeight(.regular)
                .padding(.bottom, 10)
            
            MapView(coordinate: CLLocationCoordinate2D(latitude: event.address.location.latitude, longitude: event.address.location.longitude), appleMapsURL: URL(string: event.address.location.mapURL ?? ""))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
        }
    }
}


struct TipsView: View {
    let tips: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tips")
                .font(Font.custom("Bricolage Grotesque", size: 23).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2.bold())
            
            Text(tips ?? "")
                .fontWeight(.regular)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
        }
    }
}


//#Preview{
//    if #available(iOS 18.0, *) {
//        EventPageDetaislViewIOS18(
//            event: EventDetails(
//                id: "12345",
//                name: "Festival de Música",
//                photo: UIImage(named: "festival.jpg")?.pngData(),
//                description: "Um evento incrível de música ao vivo com várias atrações!",
//                dateDetails: "Sábado, 14 de Outubro de 2024 - 18h",
//                address: AddressDetails(street: "Avenida dos Artistas", number: "0", details: "Ipanema Beach Hostel", neighborhood: "Rio de Janeiro"),
//                location: LocationDetails(
//                    latitude: -22.9068,
//                    longitude: -43.1729
//                ),
//                eventCategory: "Música",
//                safetyRate: 4.8,
//                tags: ["Música", "Festival", "Ao Vivo", "Diversão"],
//                tips: "Leve protetor solar e chegue cedo para garantir bons lugares.",
//                url: "https://www.festivaldemusica.com",
//                buyURL: "https://www.festivaldemusica.com/comprar"
//            ), translationManager: TranslationManager()
//        )
//    }
//}

