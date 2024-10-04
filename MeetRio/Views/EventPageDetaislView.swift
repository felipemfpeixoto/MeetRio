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
import CachedAsyncImage

struct EventPageDetaislView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var isSheetOpen: Bool = false
    @State var isAlsoGoing: [Hospede] = []
    
    let event: EventDetails
    let reviewList: [Review] = [Review(rate: 4, date: Date.now, description: "Muito bom, gostei bastante do local."), Review(rate: 2, date: Date.now, description: "Não gostei.")]
    
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            Color("BackgroundWhite")
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 15) {
                    
                    HStack{
                        if let buyURL = event.buyURL {
                            BuyButtonView(buyURL: buyURL)
                        }
                        
                        // Compartilhar evento
                        shareEvent()
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                    PeopleGoingView(isLoading: isLoading, isAlsoGoing: isAlsoGoing)
                        .padding()
                    
                    if event.otherPictureURLs != nil{
                        OtherPhotos(photos: event.otherPictureURLs!)
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
        ZStack{
            Color("BackgroundWhite")
                .ignoresSafeArea()
            scrollView
        }
    }
    
    func loadPeopleGoingAndTranslateTips() {
        Task {
            isLoading = true
            isAlsoGoing = try await FirestoreManager.shared.getGoingEvent(event.id!)
            isLoading = false
            // MARK: EU APENAS COMENTEI PQ AS TIPS AGORA SÃO BULLETS
            translationManager.translatedTexts[1] = event.tips.first
        }
    }
    
    @ViewBuilder
    var scrollView: some View{
        ScrollView {
            VStack(spacing: 15) {
                
                HStack{
                    if let buyURL = event.buyURL {
                        BuyButtonView(buyURL: buyURL)
                    }
                    
                    // Compartilhar evento
                    shareEvent()
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                content
                
            }
            .onAppear {
                loadPeopleGoingAndTranslateTips()
            }
        }
    }
    
    @ViewBuilder
    var content: some View{
        PeopleGoingView(isLoading: isLoading, isAlsoGoing: isAlsoGoing)
            .padding()
        
        if event.otherPictureURLs != nil{
            OtherPhotos(photos: event.otherPictureURLs!)
                .padding()
        }
        
        LocationView(event: event)
            .padding()
        
        TipsView(tips: event.tips)
            .padding()
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


struct OtherPhotos: View {
    let photos: [String]

    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
    
        VStack {
            TabView {
                ForEach(0..<photos.count, id: \.self) { index in
                    ZStack {
                        CachedAsyncImage(url: URL(string: photos[index]), transaction: Transaction(animation: .easeInOut.speed(1.5))){ phase in
                            
                            switch phase{
                            case .empty:
                                ZStack{
                                    Color.gray
                                        .opacity(0.2)
                                    ProgressView()
                                }
                                .frame(width: screenWidth * 0.9, height: 210)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .padding(.horizontal, 10)
                                
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth * 0.9, height: 210)
                                    .cornerRadius(20)
                                    .shadow(radius: 5)
                                    .padding(.horizontal, 10)
                                
                            case .failure(let error):
                                EmptyView()
                                    .onAppear(){
                                        print(error)
                                    }
                            default:
                                EmptyView()
                                
                            }
                            
                            
                            VStack {
                                Spacer()
                                HStack(spacing: 8) {
                                    ForEach(0..<photos.count, id: \.self) { dotIndex in
                                        Circle()
                                            .fill(dotIndex == index ? Color.white : Color.gray.opacity(0.7))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.bottom, 40)
                            }
                            
                        }
                    }
                    
                    
                    
                }
                

                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 230)
        }
    }
}

struct shareEvent: View{
    var body: some View {
        Image(systemName: "square.and.arrow.up")
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct BuyButtonView: View {
    let buyURL: String?
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text("Tickets")
//                .font(Font.custom("Bricolage Grotesque", size: 23).bold())
//                .padding(.bottom, 5)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
            Button(action: {
                PostHogSDK.shared.capture("ClicouComprar")
                if let url = URL(string: buyURL!) {
                    UIApplication.shared.open(url)
                }
            }, label: {
                HStack{
                    Image(systemName: "ticket")
                    Text("Buy now")
                    
                }
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color("DarkGreen"))
                )
                .frame(maxWidth: .infinity, alignment: .leading)
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
            
            Text(event.name)
                .foregroundStyle(Color("DarkGreen"))
                .fontWeight(.bold)
            
            Text("\(event.address.street), \(event.address.number) - \(event.address.neighborhood)")
                .fontWeight(.regular)
                .padding(.bottom, 10)
            
            MapView(coordinate: CLLocationCoordinate2D(latitude: event.address.location.latitude, longitude: event.address.location.longitude), appleMapsURL: URL(string: event.address.location.mapURL ?? ""))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
        }
    }
}


struct TipsView: View {
    let tips: [String] // Agora recebe uma lista de dicas
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Tips")
                .font(Font.custom("Bricolage Grotesque", size: 23).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<tips.count, id: \.self) { index in
                        HStack(spacing: 10) {
                            Image(systemName: iconForTip(tip: tips[index]))
                                .foregroundStyle(Color.green)
                            Text(tips[index])
                                .fontWeight(.regular)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 2, y: 2)
                        )
                        .padding(.vertical)
                        .padding(.horizontal, 5)
                        .offset(y: -15)
                    }
                }
            }
        }
        .padding(.horizontal, 5)
    }
    
    // Função para retornar o ícone apropriado para cada dica
    private func iconForTip(tip: String) -> String {
        if tip.contains("noite") || tip.contains("dormir") {
            return "moon.fill"
        } else if tip.contains("comida") || tip.contains("Drinks") {
            return "wineglass.fill"
        } else {
            return "chair.fill"
        }
    }
}

//#Preview{
//    
////    if #available(iOS 18.0, *) {
////        EventPageDetaislViewIOS18(
////            event: EventDetails(apiResponse: MockData.eventDetails), translationManager: TranslationManager()
////        )
////    }
//    // ou
//    //EventPageDetaislView(event: MockData.eventDetails)
//}
