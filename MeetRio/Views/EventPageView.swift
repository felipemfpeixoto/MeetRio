////
////  EventPageView.swift
////  MeetRio
////
////  Created by Luiz Seibel on 13/08/24.
////
//
//import Foundation
//import SwiftUI
//import MapKit
//
//struct EventPageView: View {
//    
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    
//    let event: EventDetails
//
//    let eventUrl: String = "https://maps.apple.com/?address=Rua%20Almirante%20Alexandrino,%20501,%20Santa%20Teresa,%20Rio%20De%20Janeiro%20-%20RJ,%2025025-450,%20Brasil&auid=11551346407795582506&ll=-22.921681,-43.185845&lsp=9902&q=Samba%20dos%20Guimar%C3%A3es"
//    
//    
//    // Review
//    var reviewList: [Review] = [Review(rate: 4, date: Date.now, description: "Muito bom, gostei bastante do local. bem refrigerado e comida boa. Porém a música deixa a desejar."), Review(rate: 2, date: Date.now, description: "Não gostei, achei muito ruim.")]
//    
//    @State var isSheetOpen: Bool = false
//    
//    //MARK: Inicio do código
//    var body: some View {
//        ScrollView{
//            VStack(spacing: 25){
//                ZStack{
//                    Rectangle()
//                        .foregroundStyle(Color.black)
//                        .frame(width: .infinity, height: screenHeight / 3.5)
//                    EventImage
//                        .offset(y: 50)
//                }
//
//                Header
//                    .padding(.top, 25)
//                MapView(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude), appleMapsURL: URL(string: "\(eventUrl)")!)
//                PeopleGoing
//                if !(event.description == ""){
//                    EventDescription
//                }
//                Safety
//                Reviews
//                    .padding(.bottom, 60)
//            }
//        }
//        .sheet(isPresented: $isSheetOpen){
//            ReviewView()
//        }
//        
//    }
//    
//    var EventImage: some View{
//        RoundedRectangle(cornerRadius: 20.0)
//            .frame(width: screenWidth * 0.80, height: screenHeight * 0.23)
//            .foregroundColor(.green)
//            .overlay(
//                Image("defaultImage")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: screenWidth * 0.80, height: screenHeight * 0.23)
//                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
//            )
//            .background{
//                ZStack{
//                    
//                    RoundedRectangle(cornerRadius: 20.0)
//                        .frame(width: screenWidth * 0.80, height: screenHeight * 0.23)
//                        .rotationEffect(.degrees(5))
//                        .offset(CGSize(width: -10.0, height: 0.0))
//                        .foregroundColor(.gray)
//                       
//                    
//                    RoundedRectangle(cornerRadius: 20.0)
//                        .frame(width: screenWidth * 0.80, height: screenHeight * 0.23)
//                        .rotationEffect(.degrees(-10))
//                        .foregroundColor(Color(UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1)))
//      
//                }
//            }
//            
//    }
//    
//    var Header: some View{
//        HStack{
//            VStack(alignment: .leading){
//                Text("\(event.name)")
//                    .font(.title2)
//                Text("\(event.address.neighborhood)")
//                    .fontWeight(.light)
//            }
//            .padding(.horizontal, 30)
//            Spacer()
//        }
//        
//    }
//    
//    var PeopleGoing: some View{
//        VStack{
//            HStack{
//                Text("Who is algo going")
//                    .font(.title3)
//                    .padding(.horizontal, 30)
//                Spacer()
//            }
//            
//            
//            ScrollView(.horizontal, showsIndicators: false){
//                HStack{
//                    ForEach((1...5), id: \.self){_ in
//                        PersonWhoGoes()
//                            .padding(.leading, 1)
//                        
//                    }
//                }
//            }
//            
//        }
//        
//        
//    }
//    
//    var EventDescription: some View{
//        
//        
//        VStack(alignment: .leading){
//            Text("Description")
//                .font(.title3)
//                .padding(.bottom)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            Text("\(event.description)")
//                .fontWeight(.light)
//            
//        }
//        .padding(.horizontal, 30)
//        
//    }
//    
//    var Safety: some View{
//        VStack{
//            HStack{
//                Text("Safety")
//                    .font(.title3)
//                    .padding(.horizontal, 30)
//                Spacer()
//            }
//            
//            RoundedRectangle(cornerRadius: 20.0)
//                .frame(width: screenWidth * 0.85, height: screenHeight * 0.09)
//                .foregroundColor(.white)
//                .shadow(radius: 5, y: 5)
//                .overlay{
//                    VStack{
//                        Text(String(format: "%.1f", event.safetyRate))
//                            .font(.callout)
//                            .fontWeight(.bold)
//                        HStack(spacing: 0.0){
//                            
//                            ForEach((0..<Int(event.safetyRate)), id: \.self){_ in
//                                Image(systemName: "star.fill")
//                                    .font(.caption2)
//                            }
//                            
//                            if event.safetyRate.truncatingRemainder(dividingBy: 1) != 0 {
//                                Image(systemName: "star.leadinghalf.filled")
//                                    .font(.caption2)
//                            }
//                        }
//                    }
//                }
//        }
//    }
//    
//    var Reviews: some View{
//        VStack{
//            HStack{
//                Text("Reviews")
//                
//                Spacer()
//                Button(action: {
//                    // TODO: Fazer ação do botão para adicionar Review em um evento
//                    isSheetOpen.toggle()
//                }, label: {
//                    Image(systemName: "plus.circle")
//                        .foregroundStyle(Color.black)
//                })
//               
//                
//            }
//            .font(.title3)
//            .padding(.horizontal)
//            
//            ScrollView(.horizontal, showsIndicators: false){
//                HStack{
//                    ForEach(reviewList, id: \.self){ el in
//                        
//                        RoundedRectangle(cornerRadius: 20.0)
//                            .frame(width: screenWidth * 0.85, height: screenHeight * 0.20)
//                            .foregroundColor(.white)
//                            .shadow(radius: 5, y: 5)
//                            .overlay {
//                                VStack(alignment: .leading, spacing: 10) {
//                                    HStack {
//                                        HStack(spacing: 0.0){
//                                            
//                                            ForEach((0..<Int(el.rate)), id: \.self){_ in
//                                                Image(systemName: "star.fill")
//                                                    .font(.caption2)
//                                            }
//                                            
//                                            if el.rate.truncatingRemainder(dividingBy: 1) != 0 {
//                                                Image(systemName: "star.leadinghalf.filled")
//                                                    .font(.caption2)
//                                            }
//                                        }
//                                        
//                                        Text("\(dateToString(date: el.date))")
//                                            .font(.caption)
//                                    }
//                                    .padding(.vertical, 5)
//                                    
//                                    Text("\(el.description)")
//                                        .font(.footnote)
//                                        .lineLimit(3)
//                                        .truncationMode(.tail)
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                    Spacer()
//                                }
//                                .padding()
//                            }
//                            .padding()
//                    }
//                }
//                
//            }
//            
//        }
//        .padding(.horizontal)
//    }
//    
//    
//    func dateToString(date: Date) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM yyyy" // Formato para "Maio 2024"
//        let dateString = dateFormatter.string(from: date)
//        
//        return dateString
//    }
//}
//
//
//
//
//
//#Preview {
//    EventPageView(event: EventDetails(
//        name: "SIBC",
//        description: "O evento mais badalado do momento. Venha ao SIBC!",
//        dateDetails: DateDetails(startDate: Date(), endDate: Date(), isRecurring: false),
//        address: AddressDetails(street: "Avenida Padre Leonel Franca", number: "215", neighborhood: "Gávea", postalCode: "11111111"),
//        location: LocationDetails(latitude: -23, longitude: -43),
//        safetyRate: 5
//        ))
//}
//
//
//
