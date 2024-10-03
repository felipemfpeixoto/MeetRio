//
//  NewEventCard.swift
//  MeetRio
//
//  Created by Luiz Seibel on 23/08/24.
//

import Foundation
import SwiftUI
import PostHog
import CachedAsyncImage

struct NewEventCard: View {
    
    @State var going: Bool = false
    
    @Binding var selectedFavorite: EventDetails?
    
    @Binding var loggedCase: LoginCase
    
    @Binding var clicouGoing: Bool
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let event: EventDetails
    
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
        VStack {
            eventImage
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .onAppear {
            if loggedCase == .registered {
                Task {
                    guard let userID = UserManager.shared.hospede?.id else { return }
                    do {
                        let going = try await FirestoreManager.shared.imGoing(userID, eventID: event.id!)
                        self.going = going
                    } catch {
                        print("Erro ao tentar marcar o evento como 'indo': \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var eventImage: some View {
        CachedAsyncImage(url: URL(string: event.photoURL!),
                         transaction: Transaction(animation: .easeInOut)
        ) {phase in
            switch phase {
            case .empty:
                Color.blue
                    .frame(width: screenWidth/1.4, height: screenWidth/1.8)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth/1.4, height: screenWidth/1.8)
                    .overlay{
                        dateComponent
                            .padding()
                    }
                    
                    .overlay(alignment: .bottom){ background }
                    .overlay(alignment: .bottomLeading){ tags }
                
                    .overlay(alignment: .bottomTrailing){ dateDetails }
                    
                    .overlay(alignment: .topTrailing){
                        if loggedCase == .registered {
                            buttonGoing
                                .padding()
                        }
                    }
                
            case .failure(let error):
                Color.red
                    .frame(width: screenWidth/1.4, height: screenWidth/1.8)
            default:
                EmptyView()
            }
        
            
        }
        
        // Falta Default
    }
    
    @ViewBuilder
    var background: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: self.screenWidth / 5)
            .background(
                ZStack {
                    BlurView(style: .systemUltraThinMaterial)
                }
            )
            .overlay(alignment: .leading){ details }
                
        .clipped()
    }
    
    @ViewBuilder
    var details: some View {
        VStack(alignment: .leading, spacing: -5){
            Text(event.name)
                .fontWeight(.semibold)
                .padding(.bottom, 3)
            Text(event.address.neighborhood)
                
                
            
            
        }
        .offset(y: -3)
        .padding([.bottom, .horizontal])
        .foregroundStyle(.white)
            
    }
    
    @ViewBuilder
    var tags: some View {
        HStack{
            ForEach(event.tags, id: \.self){ tag in
                Text("#\(tag)")
                    .font(.footnote)
            }
        }
        .padding()
        .foregroundStyle(.white)
    }

    @ViewBuilder
    var dateDetails: some View {
        if (event.dateDetails != nil){
            HStack{
                Image(systemName: "clock")
                    .offset(x: 3)
                Text(event.formattedHour(from: event.dateDetails!.startHour))
            }
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding()
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
                        if event.dayWeek != nil {
                            Text(event.dayWeek!.prefix(3))
                            Text("\(event.returnDayOfWeek(day: event.dayWeek!))")
                                .fontWeight(.semibold)
                            
                        }
                        else{
                            Text("\(event.formattedDayOfWeek())")
                            Text("\(event.formattedDay())")
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundStyle(.black)
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
            going.toggle()
            
            guard let userID = UserManager.shared.hospede?.id, let eventID = event.id else {
                // Mostre um alerta ou toast informando que o usuário ou o evento não foi carregado corretamente
                showAlert(title: "Erro", message: "Usuário ou evento não carregado corretamente.")
                return
            }
            
            // Desativa o botão durante o carregamento
            isLoading = true
            
            // Verifica se o usuário está marcando ou desmarcando presença
//            if !going {
//                marcarPresenca(userID: userID, eventID: eventID)
//            } else {
//                desmarcarPresenca(userID: userID, eventID: eventID)
//            }
        }, label: {
            if isLoading {
                ProgressView()
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                    )
            } else {
                Image(systemName: going ? "checkmark.seal.fill" :"checkmark.seal")
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                    )
            }
        })
        //.disabled(UserManager.shared.hospede?.id == nil || event.id == nil || isLoading)
    }
    
    func marcarPresenca(userID: String, eventID: String) {
        Task {
            do {
                try await FirestoreManager.shared.createGoingEvent(userID, eventID)
                going = true
                selectedFavorite = event
                PostHogSDK.shared.capture("MarcouPresenca")
            } catch {
                print("Erro ao marcar presença: \(error)")
                going = false // Reverte o estado se falhar
                showAlert(title: "Erro", message: "Não foi possível marcar sua presença.")
            }
            isLoading.toggle()
        }
    }

    func desmarcarPresenca(userID: String, eventID: String) {
        Task {
            do {
                try await FirestoreManager.shared.deleteGoingEvent(userID, eventID)
                going = false
                selectedFavorite = nil
            } catch {
                print("Erro ao desmarcar presença: \(error)")
                going = true // Reverte o estado se falhar
                showAlert(title: "Erro", message: "Não foi possível desmarcar sua presença.")
            }
            isLoading.toggle()
        }
    }

    // Exemplo de função para exibir um alerta
    func showAlert(title: String, message: String) {
        // Aqui você pode implementar a lógica para exibir um alerta ou um toast
        // Por exemplo, em SwiftUI você pode usar um Alert:
        print("\(title): \(message)") // Apenas um print como exemplo
    }
}

#Preview {
    NewEventCard(selectedFavorite: .constant(nil), loggedCase: .constant(.registered), clicouGoing: .constant(false), event: EventDetails(apiResponse: MockData.eventDetails))
}
