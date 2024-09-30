//
//  EventsSlider.swift
//  MeetRio
//
//  Created by Luiz Seibel on 23/08/24.
//

import Foundation
import SwiftUI

struct EventsSlider: View {
    
    let title: String
    let eventCategory: String?
    
    @Binding var isLoading: Bool
    @Binding var searchText: String
    @Binding var selectedFavorite: EventDetails?
    @Binding var deuRefresh: Bool
    @Binding var loggedCase: LoginCase
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
                Task {
                    await loadEventsFromCacheOrDB()
                }
            }
        }
        .onAppear {
            if !viuPrimeira {
                Task {
                    await loadEventsFromCacheOrDB()
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
                ForEach(searchResults) { event in
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
        .frame(height: UIScreen.main.bounds.width / 1.8)
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
        guard let category = eventCategory else {
            events = []
            return
        }
        
        do {
            isLoading = true
            let fetchedEvents = try await EventManager.shared.fetchEvents(forCategory: category)
            self.events = fetchedEvents
            isLoading = false
        } catch {
            print("Erro ao buscar eventos: \(error)")
            isLoading = false
        }
    }
    
    func loadEventsFromCacheOrDB() async {
        // Tenta carregar os eventos do cache
        if let cachedEvents = EventCache.shared.getEvents(forCategory: "Festival") {
            print("Carregando eventos do cache")
            self.events = cachedEvents
            self.isLoading = false
            print(cachedEvents, self.events)
        } else {
            // Se o cache estiver vazio, busca os eventos do banco de dados (Firebase, por exemplo)
            print("Cache vazio, buscando eventos do banco de dados")
            do {
                let fetchedEvents = try await FirestoreManager.shared.getLabeledEvents("bemBrazil")
                self.events = fetchedEvents
                self.isLoading = false
                // Atualiza o cache com os eventos buscados
                EventCache.shared.setEvents(fetchedEvents, forCategory: "bemBrazil")
            } catch {
                print("Erro ao buscar eventos do banco de dados: \(error)")
                self.isLoading = false
            }
        }
    }
}

//#Preview {
//    EventsSlider(title: "Hostel events", eventCategory: EventCategory.bemBrazil.rawValue, isLoading: .constant(false), searchText: .constant(""))
//}
