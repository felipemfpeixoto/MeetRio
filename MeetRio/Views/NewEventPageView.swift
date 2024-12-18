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
import CachedAsyncImage

// Componente para o layout comum entre as duas versões
struct EventPageContent: View {
    
    let event: EventDetails
    @Binding var loggedCase: LoginCase
    @Binding var going: Bool
    @Binding var calendarBool: Bool
    
    @Binding var translatedTexts: [String?]
    
    
    var body: some View {
        VStack {
            header
                .padding()
            
            if event.description != "" {
                footer
                    .padding()
            }
            Spacer()
        }
        .background {
            background
                .ignoresSafeArea()
                .offset(y: -30)
        }
        // POSTHOG
        .onAppear{
            switch event.eventCategory{
            case "nightLife":
                PostHogSDK.shared.capture("ClicouEvento(Nightlife)")
            case "bemBrazil":
                PostHogSDK.shared.capture("ClicouEvento(BemBrazil)")
            default:
                break
            }
        }
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                dateComponent
                Spacer()
            }
            
            Text(event.name)
                .font(Font.custom("Bricolage Grotesque", size: 26).weight(.semibold))
                .padding(.top)
            
            Text(event.address.street)
                .font(.title2)
            
            eventComponents
                .padding(.vertical)

            eventTags
            
            calendarButton
                .padding(.vertical)
          
        }
        .foregroundStyle(.white)
    }

    var footer: some View {
        VStack(alignment: .leading) {
            Text("About")
                .font(.title2.bold())
            Text(translatedTexts[0] ?? event.description)
                .font(.system(size: 16))
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.leading)
        .padding(.bottom, 42)
    }

    var background: some View {
        ZStack {
            CachedAsyncImage(url: URL(string: event.photoURL!), transaction: Transaction(animation: .easeInOut.speed(1.5))) { phase in
                switch phase {
                case .success(let image):
                    ZStack{
                        image
                            .resizable()
                            .scaledToFill()
                        Color.black.opacity(0.35)
                    }
                    
                case .failure(_):
                    Color.oceanBlue
                default:
                    Color.oceanBlue
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height)
    }

    //MARK: Components
    
    var calendarButton: some View {
        Button(action: {
            calendarBool = true
            
            let myEvent: CalendarEvent
            
            if let startDateTime = event.dateDetails?.startDateTime,
               let endDateTime = event.dateDetails?.endDateTime{
                
                let endHour = event.dateDetails?.endHour
                let startHour = event.dateDetails?.startHour
                
                myEvent = CalendarEvent(
                    name: event.name,
                    startDate: event.mergeData(date: startDateTime, withHour: startHour!),
                    endDate: event.mergeData(date: endDateTime, withHour: endHour!),
                    locationName: event.name,
                    latitude: event.address.location.latitude,
                    longitude: event.address.location.longitude,
                    street: event.address.street,
                    city: "Rio de Janeiro",
                    state: "RJ",
                    postalCode: event.address.cep ?? "",
                    country: "Brazil",
                    isoCountryCode: "BR"
                )
            }
            else{
                myEvent = CalendarEvent(
                    name: event.name,
                    startDate: Calendar.current.startOfDay(for: EventDetails.returnDayOfWeekDate(day: event.dayWeek!) ?? Date()),
                    endDate: Calendar.current.startOfDay(for: EventDetails.returnDayOfWeekDate(day: event.dayWeek!) ?? Date()).addingTimeInterval(60 * 60 * 23.99),
                    locationName: event.name,
                    latitude: event.address.location.latitude,
                    longitude: event.address.location.longitude,
                    street: event.address.street,
                    city: "Rio de Janeiro",
                    state: "RJ",
                    postalCode: event.address.cep ?? "",
                    country: "Brazil",
                    isoCountryCode: "BR"
                )
            }
            
            myEvent.reciveAndDonateInteraction()
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                calendarBool = false
//            }
            
        }, label: {
            HStack {
                Image(systemName: "calendar.badge.plus")
                
                Text("Add to\nCalendar")
                    .multilineTextAlignment(.leading)
                    .fontWeight(.medium)
                    .font(.caption2)
                
                Image(systemName: calendarBool ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(calendarBool ? Color("DarkGreen") : .white)
                    .background {
                        Circle()
                            .foregroundStyle(.white)
                            .padding(3)
                            .opacity(calendarBool ? 1.0 : 0.0)
                            .scaleEffect(calendarBool ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.3), value: calendarBool)
                    }
                    .clipShape(Circle())
                    .font(.title3)
                    .padding(.leading)
            }
            .foregroundStyle(.white)
            .font(.title3)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.gray)
            }
        })
    }

    var eventComponents: some View {
        HStack(spacing: 10){
            ageClassification
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.black)
                }
                

            if event.dateDetails != nil {
                eventHour
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color("DarkGreen"))
                    }
            }
            
            shareEvent(event: event)
                .offset(y: -3)
            
        }
    }

    var ageClassification: some View {
        Text("+18")
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
    }

    var eventHour: some View {
        
        HStack {
            Image(systemName: "clock")
            Text(event.formattedHour(from: event.dateDetails!.startHour))
            +
            Text(" - ")
            +
            Text(event.formattedHour(from: event.dateDetails!.endHour))
        }
        .fontWeight(.semibold)
        .padding(10)
    }

    var eventTags: some View {
        HStack {
            ForEach(event.tags, id: \.self) { tag in
                Text("#\(tag)")
                    .font(.callout)
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
}

@available(iOS 18.0, *)
struct NewEventPageViewIOS18: View {

    @Environment(\.dismiss) var dismiss
    @Binding var loggedCase: LoginCase
    var event: EventDetails
    @State var going: Bool = false
    @State var calendarBool: Bool = false
    @State var translationManager: TranslationManager = TranslationManager()
    @State var changeSheet: Bool = true // Controla a exibição da sheet do evento
    @State var showTranslationSheet: Bool = false // Controla a exibição da sheet de tradução
    
    @State var isNotDismissable = true
    
    @State var changeSheetShare = false

    var body: some View {
        VStack{
            content
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    print("Clicou no botão de voltar")
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18))
                        Text("Back")
                            .font(.system(size: 18))
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                }
            }
        }
        .toolbarBackgroundVisibility(.hidden)
        .background(Color("BackgroundWhite").edgesIgnoringSafeArea(.all))
    }

    
    var content: some View {
        ScrollView{
            EventPageContent(event: event, loggedCase: $loggedCase, going: $going, calendarBool: $calendarBool, translatedTexts: $translationManager.translatedTexts)
                .overlay(alignment: .topTrailing) {
                    VStack {
                        if loggedCase == .registered {
                            buttonGoing
                        }
                        translationButton
                    }.padding()
                }
                .onAppear {
                    if loggedCase == .registered {
                        Task {
                            going = try await FirestoreManager.shared.imGoing(UserManager.shared.hospede!.id!, eventID: event.id!)
                        }
                    }
                   
                    translationManager.translatedTexts[0] = event.description
                }
                .translationTask(translationManager.configuration) { session in
                    // Use the session the task provides to translate the text.
                    await translationManager.translateAllAtOnce(using: session, isShowing: $changeSheet)
                }
            
            EventPageDetaislView(event: event, isPresented: $changeSheetShare)
                .offset(y: -30)
        }
    }
    
    var buttonGoing: some View {
        Button(action: {
            if !going {
                YourEventsModel.shared.addEvent(event)
                going = true
                Task {
                    let userID = UserManager.shared.hospede!.id
                    await FirestoreManager.shared.createGoingEvent(userID!, event.id!)
                    PostHogSDK.shared.capture("MarcouPresenca(PageiOS18)")
                }
                // Liga o TOAST
                ToastVariables.shared.isOnAdd = true
            } else {
                YourEventsModel.shared.removeEvent(event)
                going = false
                Task {
                    let userID = UserManager.shared.hospede!.id
                    await FirestoreManager.shared.deleteGoingEvent(userID!, event.id!)
                    PostHogSDK.shared.capture("DesmarcouPresenca(PageiOS18)")
                }
                // Desliga o TOAST
                ToastVariables.shared.isOnRemove = true
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
    
//    @available(iOS 18, *) -> Forma para parar de repetir código a toa
    var translationButton: some View {
        Button {
            Task {
                if await translationManager.languageAvailable == .supported {
                    changeSheet = false
                }
                triggerTranslation()
            }
        } label: {
            Image(systemName: "translate")
                .font(.title)
                .foregroundStyle(.white)
        }
    }

    private func triggerTranslation() {
        if translationManager.configuration == nil {
            translationManager.configuration = TranslationSession.Configuration(
                source: Locale.Language(identifier: "en"),
                target: Locale.Language(identifier: Locale.preferredLanguages.first!)
            )
        } else {
            translationManager.configuration?.invalidate()
        }
    }
    
    private func saiDaView() {
        changeSheet = false
        isNotDismissable = false
        dismiss()
    }
}



//TODO: FAZER AS ATUALIZACOES.
struct NewEventPageView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var loggedCase: LoginCase
    let event: EventDetails
    @State var going: Bool = false
    @State var calendarBool: Bool = false
    
    @State var isPresenting = true
    
    @State var changeSheetShare = false
    

    var body: some View {
        ScrollView{
            EventPageContent(event: event, loggedCase: $loggedCase, going: $going, calendarBool: $calendarBool, translatedTexts: .constant([nil, nil]))
            EventPageDetaislView(event: event, isPresented: $changeSheetShare)
                .offset(y: -30)
            
        }
        .background(Color("BackgroundWhite").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    print("Clicou no botão de voltar")
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18))
                        Text("Back")
                            .font(.system(size: 18))
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                }
            }
        }
        
        .onChange(of: changeSheetShare){
            if changeSheetShare{
                isPresenting = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    event.shareEvent { success in
                        if success {
                            print("Compartilhamento concluído com sucesso!")
                        } else {
                            print("Compartilhamento cancelado ou falhou.")
                        }
                        isPresenting = true
                        changeSheetShare = false
                    }

                }

            }
        }
        .overlay(alignment: .topTrailing) {
            VStack {
                if loggedCase == .registered {
                    buttonGoing
                }
            }.padding()
        }
        .onAppear {
            if loggedCase == .registered {
                Task {
                    going = try await FirestoreManager.shared.imGoing(UserManager.shared.hospede!.id!, eventID: event.id!)
                }
            }
            
        }
    }
    
    var buttonGoing: some View {
        Button(action: {
            if !going {
                YourEventsModel.shared.addEvent(event)
                going = true
                Task {
                    let userID = UserManager.shared.hospede!.id
                    await FirestoreManager.shared.createGoingEvent(userID!, event.id!)
                    PostHogSDK.shared.capture("MarcouPresenca(Page)")
                }
                
                // Liga o TOAST
                ToastVariables.shared.isOnAdd = true
            } else {
                YourEventsModel.shared.removeEvent(event)
                going = false
                Task {
                    let userID = UserManager.shared.hospede!.id
                    await FirestoreManager.shared.deleteGoingEvent(userID!, event.id!)
                    PostHogSDK.shared.capture("DesmarcouPresenca(Page)")
                }
                
                // Liga o TOAST
                ToastVariables.shared.isOnRemove = true
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
    
    private func saiDaView() {
        isPresenting = false
        dismiss()
    }
}


//BottomSheetView(isShowing: $isPresenting, someView: EventPageDetaislView(event: event, isPresented: $changeSheetShare), overlayedColor: Color.clear)
