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

struct EventPageDetaislView: View{
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var isSheetOpen: Bool = false
    @State var isAlsoGoing: [Hospede] = []
    
    let event: EventDetails
    
    var reviewList: [Review] = [Review(rate: 4, date: Date.now, description: "Muito bom, gostei bastante do local. bem refrigerado e comida boa. Porém a música deixa a desejar."), Review(rate: 2, date: Date.now, description: "Não gostei, achei muito ruim.")]
    
    @State var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                PeopleGoing
                    .padding(.top, 30)
                if let buyURL = event.buyURL {
                    buyButton
                        .padding()
                }
                location
                
                tips
                
//                Reviews
            }
            .onAppear {
                Task {
                    isLoading = true
                    isAlsoGoing = try await FirestoreManager.shared.getGoingEvent(event.id!)
                    isLoading = false
                }
            }
//            .sheet(isPresented: $isSheetOpen){
//                ReviewView()
//            }
        }
    }
    
    var PeopleGoing: some View{
        VStack{
            HStack{
                Text("Who is algo going")
                    .font(.title2.bold())
                    .padding(.horizontal, 27)
                Spacer()
                
//                Button(action: {
//                    //TODO: COLOCAR UM NAVIGATION PARA VER TODOS QUE VAO
//                }, label: {
//                    Text("See all")
//                        .foregroundStyle(.gray)
//                        .padding(.horizontal)
//                })
            }
            
            if isLoading {
                ProgressView()
            } else {
                if isAlsoGoing.count == 0 {
                    Text("No one is going yet")
                } else {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(isAlsoGoing, id: \.self.id){ hospede in
                                PersonWhoGoes(hospede: hospede)
                                    .padding(.leading, 1)
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    var buyButton: some View {
        Button(action: {
            PostHogSDK.shared.capture("ClicouComprar")
            if let url = URL(string: event.buyURL!) {
                UIApplication.shared.open(url)
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.black)
                Text("BUY NOW")
                    .foregroundStyle(.marcaTexto)
                    .font(Font.custom("Bricolage Grotesque", size: 23))
                    .fontWeight(.semibold)
            }
        }
        .frame(height: 55)
    }
    
    var location: some View{
        VStack(alignment: .leading){
            Text("Location")
                .font(.title2.bold())
            
            MapView(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude), appleMapsURL: URL(string: "\(event.url)"))
            
            Text(event.address.details ?? "")
            Text("\(event.address.street), \(event.address.number)")
                .fontWeight(.light)
        }
    }
    
    var tips: some View{
        VStack(alignment: .leading){
            Text("Tips")
                .padding(.horizontal, 15)
                .font(.title2.bold())
            
            Text(event.tips ?? "")
                .fontWeight(.regular)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
        }
    }
    
    
    var Reviews: some View{
        VStack{
            HStack{
                Text("Reviews")
                    .fontWeight(.bold)
                
                Spacer()
                Button(action: {
                    // TODO: Fazer ação do botão para adicionar Review em um evento
                    isSheetOpen.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Color.black)
                })
               
                
            }
            .font(.title2)
            .padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(reviewList, id: \.self){ el in
                        RoundedRectangle(cornerRadius: 20.0)
                            .frame(width: screenWidth * 0.85, height: screenHeight * 0.20)
                            .foregroundColor(.white)
                            .shadow(radius: 5, y: 5)
                            .overlay {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        HStack(spacing: 0.0){
                                            
                                            ForEach((0..<Int(el.rate)), id: \.self){_ in
                                                Image(systemName: "star.fill")
                                                    .font(.caption2)
                                            }
                                            
                                            if el.rate.truncatingRemainder(dividingBy: 1) != 0 {
                                                Image(systemName: "star.leadinghalf.filled")
                                                    .font(.caption2)
                                            }
                                        }
                                        
                                        Text("\(dateToString(date: el.date))")
                                            .font(.caption)
                                    }
                                    .padding(.vertical, 5)
                                    
                                    Text("\(el.description)")
                                        .font(.footnote)
                                        .lineLimit(3)
                                        .truncationMode(.tail)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                }
                                .padding()
                            }
                            .padding()
                    }
                }
                
            }
            
        }
        .padding(.horizontal)
    }
    
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy" // Formato para "Maio 2024"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
}




@available(iOS 18, *)
struct EventPageDetaislViewIOS18: View{
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var isSheetOpen: Bool = false
    @State var isAlsoGoing: [Hospede] = []
    
    let event: EventDetails
    
    var reviewList: [Review] = [Review(rate: 4, date: Date.now, description: "Muito bom, gostei bastante do local. bem refrigerado e comida boa. Porém a música deixa a desejar."), Review(rate: 2, date: Date.now, description: "Não gostei, achei muito ruim.")]
    
    @State var isLoading = false
    let translationManager: TranslationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                PeopleGoing
                    .padding(.top, 30)
                if let buyURL = event.buyURL {
                    buyButton
                        .padding()
                }
                location
                
                tips
                
//                Reviews
            }
            .onAppear {
                Task {
                    isLoading = true
                    isAlsoGoing = try await FirestoreManager.shared.getGoingEvent(event.id!)
                    isLoading = false
                }
                translationManager.translatedTexts[1] = event.tips
            }
//            .sheet(isPresented: $isSheetOpen){
//                ReviewView()
//            }
        }
    }
    
    var PeopleGoing: some View{
        VStack{
            HStack{
                Text("Who is algo going")
                    .font(.title2.bold())
                    .padding(.horizontal, 27)
                Spacer()
                
//                Button(action: {
//                    //TODO: COLOCAR UM NAVIGATION PARA VER TODOS QUE VAO
//                }, label: {
//                    Text("See all")
//                        .foregroundStyle(.gray)
//                        .padding(.horizontal)
//                })
            }
            
            if isLoading {
                ProgressView()
            } else {
                if isAlsoGoing.count == 0 {
                    Text("No one is going yet")
                } else {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(isAlsoGoing, id: \.self.id){ hospede in
                                PersonWhoGoes(hospede: hospede)
                                    .padding(.leading, 1)
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    var buyButton: some View {
        Button(action: {
            PostHogSDK.shared.capture("ClicouComprar")
            if let url = URL(string: event.buyURL!) {
                UIApplication.shared.open(url)
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.black)
                Text("BUY NOW")
                    .foregroundStyle(.marcaTexto)
                    .font(Font.custom("Bricolage Grotesque", size: 23))
                    .fontWeight(.semibold)
            }
        }
        .frame(height: 55)
    }
    
    var location: some View{
        VStack(alignment: .leading){
            Text("Location")
                .font(.title2.bold())
            
            MapView(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude), appleMapsURL: URL(string: "\(event.url)"))
            
            Text(event.address.details ?? "")
            Text("\(event.address.street), \(event.address.number)")
                .fontWeight(.light)
        }
    }
    
    var tips: some View{
        VStack(alignment: .leading){
            Text("Tips")
                .padding(.horizontal, 15)
                .font(.title2.bold())
            
            Text(translationManager.translatedTexts[1] ?? event.tips ?? "")
                .fontWeight(.regular)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
        }
    }
    
    
    var Reviews: some View{
        VStack{
            HStack{
                Text("Reviews")
                    .fontWeight(.bold)
                
                Spacer()
                Button(action: {
                    // TODO: Fazer ação do botão para adicionar Review em um evento
                    isSheetOpen.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Color.black)
                })
               
                
            }
            .font(.title2)
            .padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(reviewList, id: \.self){ el in
                        RoundedRectangle(cornerRadius: 20.0)
                            .frame(width: screenWidth * 0.85, height: screenHeight * 0.20)
                            .foregroundColor(.white)
                            .shadow(radius: 5, y: 5)
                            .overlay {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        HStack(spacing: 0.0){
                                            
                                            ForEach((0..<Int(el.rate)), id: \.self){_ in
                                                Image(systemName: "star.fill")
                                                    .font(.caption2)
                                            }
                                            
                                            if el.rate.truncatingRemainder(dividingBy: 1) != 0 {
                                                Image(systemName: "star.leadinghalf.filled")
                                                    .font(.caption2)
                                            }
                                        }
                                        
                                        Text("\(dateToString(date: el.date))")
                                            .font(.caption)
                                    }
                                    .padding(.vertical, 5)
                                    
                                    Text("\(el.description)")
                                        .font(.footnote)
                                        .lineLimit(3)
                                        .truncationMode(.tail)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                }
                                .padding()
                            }
                            .padding()
                    }
                }
                
            }
            
        }
        .padding(.horizontal)
    }
    
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy" // Formato para "Maio 2024"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
}
//
//#Preview{
//    EventPageDetaislView(event: EventDetails(name: "Mengo", description: "tengo", dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false), address: AddressDetails(street: "Rua", number: "2", details: "", referencePoint: nil, neighborhood: "Gávea", postalCode: "2211"), location: LocationDetails(latitude: -22.0, longitude: -49.0), safetyRate: 5))
//}
