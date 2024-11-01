//
//  EventSearch.swift
//  MeetRio
//
//  Created by Luiz Seibel on 01/11/24.
//

import Foundation
import SwiftUI

struct EventSearch: View {
    
    @Binding var searchText: String
    @Binding var loggedCase: LoginCase
    @Binding var selectedFavorite: EventDetails?
    @Binding var clicouGoing: Bool
    
    @State private var events: [EventDetails] = []
    
    
    var body: some View {
        VStack{
            let sortedEvents = searchResults.sorted(by: <)
            
            if sortedEvents.isEmpty {
                EventNotFound()
                    .padding(.top, 80)
            }
            else{
                ScrollView{
                    ForEach(sortedEvents) { event in
                        if event.eventCategory != "bemBrazil" || (event.dateDetails?.hasEventPassed == false) {
                            if event.eventCategory != "bemBrazil" || (event.dateDetails?.hasEventPassed == false) {
                                if #available(iOS 18, *) {
                                    NavigationLink(destination: NewEventPageViewIOS18(loggedCase: $loggedCase, event: event)) {
                                        NewEventCard(
                                            selectedFavorite: $selectedFavorite,
                                            loggedCase: $loggedCase,
                                            clicouGoing: $clicouGoing,
                                            size: .large,
                                            event: event
                                        )
                                    }
                                    .padding(.bottom)
                                } else {
                                    NavigationLink(destination: NewEventPageView(loggedCase: $loggedCase, event: event)) {
                                        NewEventCard(
                                            selectedFavorite: $selectedFavorite,
                                            loggedCase: $loggedCase,
                                            clicouGoing: $clicouGoing,
                                            size: .large,
                                            event: event
                                        )
                                    }
                                    .padding(.bottom)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        .onAppear{
            events = EventCache.shared.getAllEvents()
        }
        
    }
        
    
    
    var searchResults: [EventDetails] {
        var filteredEvents = events
        
        if !searchText.isEmpty {
            filteredEvents = filteredEvents.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filteredEvents
    }
}
#Preview {
    EventSearch(searchText: .constant(""), loggedCase: .constant(.registered), selectedFavorite: .constant(nil), clicouGoing: .constant(false))
}
