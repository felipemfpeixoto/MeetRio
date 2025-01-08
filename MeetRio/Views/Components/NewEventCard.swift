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


enum Sizes {
    case normal, large
}

// TODO: (0) PAREI AQUI
struct NewEventCard: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    @State var going: Bool = false
    
    @Binding var selectedFavorite: EventDetails?
    
    @Binding var clicouGoing: Bool
    
    var size: Sizes = .normal
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let event: EventDetails
    
    let calendar = Calendar.current
    
    @State var isLoading: Bool = false
    
    var isLargeSize: Bool {
        return sizeCategory.numericValue >= 5
    }
    
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
            if Hospede.loggedCase == .registered {
                Task {
                    let userID = Fornecedor.shared.userVariable!.id
                    do {
                        let going = try await GoingEvent.getGoingEvent(eventID: event.id, userID: userID)
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
        CachedAsyncImage(url: URL(string: event.photoURL ?? ""), transaction: Transaction(animation: .easeInOut.speed(1.5))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure(_):
                Image("defaultImageCard")
                    .resizable()
                    .scaledToFill()
            default:
                ZStack {
                    Image("defaultImageCard")
                        .resizable()
                        .scaledToFill()
                    Color.black.opacity(0.5)
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.3)
                        .padding(.bottom)
                }
            }
        }
        .frame(
            width: size == .normal ? screenWidth / 1.4 : screenWidth / 1.2,
            height: size == .normal ? screenWidth / 1.8 : screenWidth / 1.5
        )
        .overlay{
            dateComponent
                .padding()
        }
        
        .overlay(alignment: .bottom){ background }
        
        .overlay(alignment: .bottomLeading){ tags }
    
        .overlay(alignment: .bottomTrailing){ dateDetails }
        
        .overlay(alignment: .topTrailing){
            HStack{
                if size == .large {
                    EventCategory
                        .padding(.horizontal)
                }
                if Hospede.loggedCase == .registered {
                    buttonGoing
                }
            }.padding()
        }
    }
    
    @ViewBuilder
    var EventCategory: some View {
        
        var eventName: String {
            if event.eventCategory.eventType.rawValue == "bemBrazil" {
                return "Bem Brazil"
            }
            else if event.eventCategory.eventType.rawValue == "nightLife" {
                return "NightLife"
            }
            else{
                return event.eventCategory.eventType.rawValue
            }
        }
        
        Text(eventName)
            .font(.callout)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(BlurView(style: .systemUltraThinMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(x: 10)
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
                .lineLimit(1)
                //.minimumScaleFactor(0.7)
                .padding(.bottom, 3)
            Text(event.address?.neighborhood ?? "")

        }
        .offset(y: -3)
        .padding([.bottom, .horizontal])
        .foregroundStyle(.white)
            
    }
    
    @ViewBuilder
    var tags: some View {
        if !isLargeSize {
            HStack {
                ForEach(event.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.footnote)
                }
            }
            .padding()
            .foregroundStyle(.white)
        }
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
                            Text("\(EventDetails.returnDayOfWeek(day: event.dayWeek!))")
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
            let eventID = event.id
            guard let userID = Fornecedor.shared.userVariable?.id else {
                // Mostre um alerta ou toast informando que o usuário ou o evento não foi carregado corretamente
                print("Erro: Usuário ou evento não carregado corretamente.")
                return
            }
            
            // Desativa o botão durante o carregamento
            isLoading = true
            
            // Verifica se o usuário está marcando ou desmarcando presença
            
            // TODO: (1) Testar
            if !going {
                going = true
                Task {
                    let _ = try await GoingEvent(eventID: userID, userID: event.id, isNewGoingEvent: true)
                    PostHogSDK.shared.capture("MarcouPresenca(PageiOS18)")
                }
                // Liga o TOAST
                ToastVariables.shared.isOnAdd = true
            } else {
                going = false
                Task {
                    let goingEvent = try await GoingEvent(eventID: event.id, userID: userID)
                    
                    try await goingEvent.deleteItem()
                    
                    PostHogSDK.shared.capture("DesmarcouPresenca(PageiOS18)")
                }
            }
            
            isLoading = false
            
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
        .disabled(Fornecedor.shared.userVariable == nil || isLoading)
    }
}

#Preview("Normal Registered") {
    NewEventCard(selectedFavorite: .constant(nil), clicouGoing: .constant(false), event: MockData.Event)
}

#Preview("Large Registered") {
    NewEventCard(selectedFavorite: .constant(nil), clicouGoing: .constant(false), size: .large, event: MockData.Event)
}

#Preview("Normal Anonymous") {
    NewEventCard(selectedFavorite: .constant(nil), clicouGoing: .constant(false), event: MockData.Event)
}

#Preview("Large Anonymous") {
    NewEventCard(selectedFavorite: .constant(nil), clicouGoing: .constant(false), size: .large, event: MockData.Event)
}

extension ContentSizeCategory {
    var numericValue: Int {
        switch self {
        case .extraSmall: return 0
        case .small: return 1
        case .medium: return 2
        case .large: return 3
        case .extraLarge: return 4
        case .extraExtraLarge: return 5
        case .extraExtraExtraLarge: return 6
        case .accessibilityMedium: return 7
        case .accessibilityLarge: return 8
        case .accessibilityExtraLarge: return 9
        case .accessibilityExtraExtraLarge: return 10
        case .accessibilityExtraExtraExtraLarge: return 11
        @unknown default: return 3
        }
    }
}
