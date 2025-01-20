//
//  EventsSlider.swift
//  MeetRio
//
//  Created by Luiz Seibel on 23/08/24.
//

import Foundation
import SwiftUI
import PostHog

struct EventsSlider: View {
    
    let title: String
    let eventCategory: String
    
    @Binding var isLoading: Bool
    @Binding var searchText: String
    @Binding var deuRefresh: Bool
    @Binding var clicouGoing: Bool
    
    @State private var events: [EventDetails] = []
    @State private var viuPrimeira: Bool = false
    
    var body: some View {
        VStack(spacing: 0.0){
            header
            if isLoading {
                eventsSliderPlaceholder
            } else {
                eventsSliderView
            }
        }
        .onChange(of: deuRefresh) {
            Task {
                try await Fornecedor.allEvents.getAllElements()
            }
        }
        .onAppear {
            if !viuPrimeira {
                Task {
                    try await Fornecedor.allEvents.getAllElements()
                    viuPrimeira = true
                }
            }
        }
    }
    
    var header: some View {
        HStack{
            Text(title)
                .font(Font.custom("Bricolage Grotesque", size: 24))
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
    }
    
    var eventsSliderView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                let sortedEvents = searchResults.sorted(by: <)
                
                ForEach(sortedEvents) { event in
                    
                    if event.eventCategory.eventType.rawValue == eventCategory /*|| (event.dateDetails?.hasEventPassed == false)*/ {
                        if #available(iOS 18, *) {
                            NavigationLink(destination: NewEventPageViewIOS18(event: event, hostelPhoneNumber: nil)) {
                                NewEventCard(
                                    clicouGoing: $clicouGoing,
                                    event: event
                                )
                            }
                            
                        } else {
                            NavigationLink(destination: NewEventPageView(event: event, hostelPhoneNumber: nil)) {
                                NewEventCard(
                                    clicouGoing: $clicouGoing,
                                    event: event
                                )
                            }
                           
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
        .frame(height: UIScreen.main.bounds.width / 1.8)
        .padding(.horizontal)
    }
    
    var searchResults: [EventDetails] {
        var filteredEvents = Fornecedor.allEvents
        
        if !searchText.isEmpty {
            filteredEvents = filteredEvents.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filteredEvents
    }
}

#Preview {
    EventsSlider(title: "Teste", eventCategory: "Nightlife", isLoading: .constant(false), searchText: .constant(""), deuRefresh: .constant(false), clicouGoing: .constant(false))
}




