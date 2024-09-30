//
//  NewEventPageView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 26/08/24.
//

import Foundation
import SwiftUI
import MapKit
import PostHog
import Translation


struct NewEventPageView: View{
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var loggedCase: LoginCase
    
    let event: EventDetails
    
    let calendar = Calendar.current
    
    let day = "Sun"
        let day2 = "13"
        let tags: [String] = ["Drinks"]
        let hour = "16pm"
    
    let weekdays = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat"
    ]
    
    @State private var showingCredits = true
    @State var going: Bool = false
    
    let myEvent = CalendarEvent(
        name: "Reunião de Equipe",
        startDate: Date(), // Data de início atual
        endDate: Date().addingTimeInterval(3600), // Evento com duração de 1 hora
        locationName: "Escritório Central",
        latitude: 37.33072,
        longitude: -122.02962,
        street: "1 Infinite Loop",
        city: "Cupertino",
        state: "CA",
        postalCode: "95014",
        country: "United States",
        isoCountryCode: "US"
    )
    
    var body: some View{
        VStack {
            header
                .padding()
            Button(action: {
                myEvent.reciveAndDonateInteraction(eventData: myEvent)
            }, label: {
                Text("Adicionar Evento")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })
            Spacer()
            if event.description != ""{
                footer
                    .padding()
            }
            Spacer()
        }
        .background {
            background
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showingCredits) {
            EventPageDetaislView(event: event)
                .presentationDetents([.fraction(0.12), .large])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled(true)
                .presentationBackgroundInteraction(.enabled)
                .background(EmptyView())
        }
        .onAppear{
            if loggedCase == .registered{
                Task{
                    going = try await FirestoreManager.shared.imGoing(UserManager.shared.hospede!.id!, eventID: event.id!)
                }
            }
            PostHogSDK.shared.capture("ViuDetalhesEvento")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    dismiss()
                }, label: {
                    
                    Image(systemName: "chevron.left")
                    Text("Back")
                        
                })
                .foregroundStyle(.white)
            }
        }
    }
    
    var header: some View{
        VStack(alignment: .leading, spacing: 2){
            HStack{
                dateComponent
                Spacer()
                if loggedCase == .registered{
                    buttonGoing
                }
            }
            
            Text(event.name)
                .font(.title.weight(.semibold))
            
            Text(event.address.street)
                .font(.title2)
            
            eventTags
                .fontWeight(.light)
            
//            eventHour
            
            
        }
        .foregroundStyle(.white)
        
    }
    
    var footer: some View{
        
        VStack(alignment: .leading){
            Text("About")
                .font(.title2.bold())
            Text(event.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.width * 0.95 ,height: UIScreen.main.bounds.height/3)
        .multilineTextAlignment(.leading)
    }
    
    var background: some View{
        ZStack {
            Image(uiImage: UIImage(data: (event.photo ?? UIImage(named: "defaultImage")!.pngData())!)!)
                .resizable()
                .scaledToFill()
            Color.black
                .opacity(0.5)
        }
        .frame(height: UIScreen.main.bounds.height)
    }
    
    
    //MARK: Components
    
    var eventHour: some View{
        HStack{
            Image(systemName: "clock")
                .fontWeight(.semibold)
            Text(hour)
                .fontWeight(.semibold)
        }
    }
    
    var eventTags: some View{
        HStack{
            ForEach(tags, id: \.self) { tag in
                Text("#\(tag)")
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
    
    var buttonGoing: some View{
        Button(action: {
            //TODO: Atualizar a instancia do evento e mostrar na tela o TOAST
            if !going{
                Task {
                    let userID = UserManager.shared.hospede!.id
                    try await FirestoreManager.shared.createGoingEvent(userID!, event.id!)
                    going = true
                    PostHogSDK.shared.capture("MarcouPresenca")
                }
            } else {
                Task {
                    let userID = UserManager.shared.hospede!.id
                    try await FirestoreManager.shared.deleteGoingEvent(userID!, event.id!)
                    going = false
                }
            }
        }, label: {
            Image(systemName: going ? "checkmark.seal.fill" : "checkmark.seal")
                .foregroundStyle(going ? .green : .black)
                .font(.title3)
                .padding(7)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                )
        })
    }
    
}

@available(iOS 18, *)
struct NewEventPageViewIOS18: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var loggedCase: LoginCase
    
    let event: EventDetails
    
    let calendar = Calendar.current
    
    let day = "Sun"
        let day2 = "13"
        let tags: [String] = ["Drinks"]
        let hour = "16pm"
    
    let weekdays = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat"
    ]
    
    @State private var showingCredits = true
    @State var going: Bool = false
    
    @State var translationManager: TranslationManager = TranslationManager() // declarando com o tipo mais abstrato que conforme com a versão do ios necessária
    
    let myEvent = CalendarEvent(
        name: "Reunião de Equipe",
        startDate: Date(), // Data de início atual
        endDate: Date().addingTimeInterval(3600), // Evento com duração de 1 hora
        locationName: "Escritório Central",
        latitude: 37.33072,
        longitude: -122.02962,
        street: "1 Infinite Loop",
        city: "Cupertino",
        state: "CA",
        postalCode: "95014",
        country: "United States",
        isoCountryCode: "US"
    )
    
    var body: some View{
        VStack {
            header
                .padding()
            Button(action: {
                myEvent.reciveAndDonateInteraction(eventData: myEvent)
            }, label: {
                Text("Adicionar Evento")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })
            Spacer()
            if event.description != ""{
                footer
                    .padding()

            }
            Spacer()
        }
        .background {
            background
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showingCredits) {
            EventPageDetaislViewIOS18(event: event, translationManager: translationManager)
                .presentationDetents([.fraction(0.12), .large])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled(true)
                .presentationBackgroundInteraction(.enabled)
                .background(EmptyView())
        }
        .onAppear{
            if loggedCase == .registered{
                Task{
                    going = try await FirestoreManager.shared.imGoing(UserManager.shared.hospede!.id!, eventID: event.id!)
                }
            }
            PostHogSDK.shared.capture("ViuDetalhesEvento")
            translationManager.translatedTexts[0] = event.description
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    
                    Image(systemName: "chevron.left")
                    Text("Back")
                        
                })
                .foregroundStyle(.white)
            }
        }
        .translationTask(translationManager.configuration) { session in
            // Use the session the task provides to translate the text.
            await translationManager.translateAllAtOnce(using: session, $showingCredits)
        }
    }
    
    var header: some View{
        VStack(alignment: .leading, spacing: 2){
            HStack{
                dateComponent
                Spacer()
                VStack {
                    if loggedCase == .registered{
                        buttonGoing
                    }
                    Button {
                        Task {
                            if translationManager.languageAvailable == .supported {
                                showingCredits.toggle()
                            }
                            triggerTranslation()
                        }
                    } label: {
                        Image(systemName: "translate")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
            }
            
            Text(event.name)
                .font(.title.weight(.semibold))
            
            Text(event.address.street)
                .font(.title2)
            
            eventTags
                .fontWeight(.light)
            
//            eventHour
        }
        .foregroundStyle(.white)
        
    }
    
    var footer: some View {
        VStack(alignment: .leading){
            Text("About")
                .font(.title2.bold())
            Text(translationManager.translatedTexts[0] ?? event.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.width * 0.95 ,height: UIScreen.main.bounds.height/3)
        .multilineTextAlignment(.leading)
    }
    
    var background: some View{
        ZStack {
            Image(uiImage: UIImage(data: (event.photo ?? UIImage(named: "defaultImage")!.pngData())!)!)
                .resizable()
                .scaledToFill()
            Color.black
                .opacity(0.5)
        }
        .frame(height: UIScreen.main.bounds.height)
    }
    
    //MARK: Components
    
    var eventHour: some View{
        HStack{
            Image(systemName: "clock")
                .fontWeight(.semibold)
            Text(hour)
                .fontWeight(.semibold)
        }
    }
    
    var eventTags: some View{
        HStack{
            ForEach(tags, id: \.self) { tag in
                Text("#\(tag)")
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
    
    var buttonGoing: some View{
        Button(action: {
            //TODO: Atualizar a instancia do evento e mostrar na tela o TOAST
            if !going{
                Task {
                    let userID = UserManager.shared.hospede!.id
                    try await FirestoreManager.shared.createGoingEvent(userID!, event.id!)
                    going = true
                    PostHogSDK.shared.capture("MarcouPresenca")
                }
            } else {
                Task {
                    let userID = UserManager.shared.hospede!.id
                    try await FirestoreManager.shared.deleteGoingEvent(userID!, event.id!)
                    going = false
                }
            }
        }, label: {
            Image(systemName: going ? "checkmark.seal.fill" : "checkmark.seal")
                .foregroundStyle(going ? .green : .black)
                .font(.title3)
                .padding(7)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                )
        })
    }
    
    private func triggerTranslation() {
        if translationManager.configuration == nil {
            // Set the language pairing.
            translationManager.configuration = TranslationSession.Configuration(source: Locale.Language(identifier: "en"), target: Locale.Language(identifier: Locale.preferredLanguages.first!))
        } else {
            // Invalidate the previous configuration.
            translationManager.configuration?.invalidate()
        }
    }
    
}
