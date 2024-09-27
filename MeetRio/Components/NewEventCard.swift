//
//  NewEventCard.swift
//  MeetRio
//
//  Created by Luiz Seibel on 23/08/24.
//

import Foundation
import SwiftUI
import PostHog

struct NewEventCard: View {
    
    @State var going: Bool = false
    
    @Binding var selectedFavorite: EventDetails?
    
    @Binding var loggedCase: LoginCase
    
    @Binding var clicouGoing: Bool
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let event: EventDetails
    
//    let hour = "11am"
    let tags:[String] = ["Drink", "Beach"]
    let calendar = Calendar.current
    
    @State var isLoading: Bool = false
    
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
        Image(uiImage: UIImage(data: (event.photo ?? UIImage(named: "defaultImage")!.pngData())!)!)
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth/1.4, height: screenWidth/1.8)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay{
                ZStack{
                    VStack{
                        HStack{
                            Spacer()
                            if loggedCase == .registered{
                                buttonGoing
                                    .padding()
                            }
                        }
                        Spacer()
                        RoundedRectangle(cornerRadius: 20.0)
                            .frame(width: screenWidth/1.6, height: 20)
                            .blur(radius: 15.0)
                            .opacity(0.3)
                            .padding()
                    }
                    
                    HStack{
                        VStack(alignment: .leading){
                            Spacer()
                            dateComponent
                            Text(event.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                            
                            Text(event.address.street)
                                
                            HStack{
                                ForEach(tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                    
                                }
                                
                                Spacer()
                                
//                                Image(systemName: "clock")
//                                    .fontWeight(.semibold)
//                                Text(hour)
//                                    .fontWeight(.semibold)
                            }.font(.caption)
                            
                        }
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding()
                }
            }
            .onAppear{
                if loggedCase == .registered {
                    Task {
                        do {
                            guard let userID = UserManager.shared.hospede?.id else {
//                                print("ID do usuário ou evento está nulo.")
//                                print(UserManager.shared.hospede as Any)
                                return
                            }
                            let going = try await FirestoreManager.shared.imGoing(userID, eventID: event.id!)
                            self.going = going
//                            print("Status de 'indo' atualizado: \(going)")
                        } catch {
                            print("Erro ao tentar marcar o evento como 'indo': \(error.localizedDescription)")
                        }
                    }
                }
            }
    }
    
    var dateComponent: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
                    VStack(spacing: 0.0) {
                        Text("\(event.dateDetails.prefix(3))")
                            .fontWeight(.semibold)
                            
//                        Text("\(calendar.component(.day, from: event.dateDetails.startDate))")
                    }.foregroundStyle(.black)
                }
                .frame(width: 48, height: 50)
                Spacer()
            }
            Spacer()
        }
        .frame(height: 35)
    }
    
    var buttonGoing: some View {
        Button(action: {
            isLoading = true
            guard let userID = UserManager.shared.hospede?.id, let eventID = event.id else {
                // Mostre um alerta ou toast informando que o usuário ou o evento não foi carregado corretamente
                return
            }
            
            if !going {
                Task {
                    do {
                        try await FirestoreManager.shared.createGoingEvent(userID, eventID)
                        going = true
                        selectedFavorite = event
                        PostHogSDK.shared.capture("MarcouPresenca")
                    } catch {
                        print("Erro ao marcar presença: \(error)")
                        going = false // Reverte o estado se falhar
                        // Mostre um alerta ou toast sobre o erro
                    }
                    isLoading.toggle()
                }
            } else {
                Task {
                    do {
                        try await FirestoreManager.shared.deleteGoingEvent(userID, eventID)
                        going = false
                        selectedFavorite = nil
                    } catch {
                        print("Erro ao desmarcar presença: \(error)")
                        going = true // Reverte o estado se falhar
                        // Mostre um alerta ou toast sobre o erro
                    }
                    isLoading.toggle()
                }
            }
            
            
            
        }, label: {
            if isLoading {
                ProgressView()
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                        )
            } else {
                Image(systemName: going ? "checkmark.seal.fill" : "checkmark.seal")
                    .foregroundStyle(going ? .green : .black)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                    )
            }
        })
        .disabled(UserManager.shared.hospede?.id == nil || event.id == nil || isLoading)
    }

}

//#Preview {
//    NewEventCard()
//}
