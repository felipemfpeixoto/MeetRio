//
//  EventsSlider.swift
//  MeetRio
//
//  Created by Luiz Seibel on 23/08/24.
//

import Foundation
import SwiftUI

struct EventsSlider: View{
    
    let title: String
    
    let eventCategory: String?
    
    @Binding var isLoading: Bool
    
    @Binding var searchText: String
    
    @Binding var selectedFavorite: EventDetails?
    
    @State var events: [EventDetails] = []
    
    @Binding var deuRefresh: Bool
    
    @Binding var loggedCase: LoginCase
    
    @Binding var clicouGoing: Bool
    
    @State var viuPrimeira: Bool = false
    
    var body: some View{
        VStack(spacing: 0.0){
            header
            if isLoading {
                eventsSliderPlaceholder
            } else {
                eventsSliderView
            }
        }
//        .onAppear {
//            if !viuPrimeira {
//                Task {
//                    print("Fez o get")
//                    try await fazOget()
//                    viuPrimeira = true
//                }
//            }
//        }
        .onChange(of: deuRefresh) {
            Task {
                print("Fez o get no onChange")
                try await fazOget()
            }
        }
    }
    
    var header: some View{
        HStack{
            Text(title)
                .font(Font.custom("Bricolage Grotesque", size: 24))
                .fontWeight(.bold)
            Spacer()
        }.padding()
    }
    
    var eventsSliderView: some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(searchResults){ event in
                    if #available(iOS 18, *) {
                        NavigationLink(destination: NewEventPageViewIOS18(loggedCase: $loggedCase, event: event)) {
                            NewEventCard(selectedFavorite: $selectedFavorite, loggedCase: $loggedCase, clicouGoing: $clicouGoing, event: event)
                        }
                    } else {
                        NavigationLink(destination: NewEventPageView(loggedCase: $loggedCase, event: event)) {
                            NewEventCard(selectedFavorite: $selectedFavorite, loggedCase: $loggedCase, clicouGoing: $clicouGoing, event: event)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var eventsSliderPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.gray.opacity(0.3))
            VStack {
                ProgressView()
                    .tint(.black)
                Text("Loading Events")
                    .font(Font.custom("Bricolage Grotesque", size: 20).weight(.semibold))
                    .foregroundStyle(.black)
            }
        }
        .frame(height: UIScreen.main.bounds.width/1.8)
        .padding(.horizontal)
    }
    
    var searchResults: [EventDetails] {
        var filteredEvents = events
        
        if !searchText.isEmpty {
            filteredEvents = filteredEvents.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filteredEvents
    }
    
    func fazOget() async throws {
        do {
            isLoading = true
            events = try await FirestoreManager.shared.getLabeledEvents(eventCategory ?? "")
            isLoading = false
        } catch {
            print("Deu merda: ", error)
        }
    }
}

//#Preview {
//    EventsSlider(title: "Hostel events", eventCategory: EventCategory.bemBrazil.rawValue, isLoading: .constant(false), searchText: .constant(""))
//}
