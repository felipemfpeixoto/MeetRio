//
//  EventsSlider.swift
//  MeetRio
//
//  Created by Luiz Seibel on 23/08/24.
//

import Foundation
import SwiftUI
import PostHog
import CachedAsyncImage

struct EventsSliderHostel: View {
    
    let hostelID: String
    
    @State var hostel: Hostel?
    
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
                    hostel = try await Hostel.getItem(for: hostelID)
                    viuPrimeira = true
                }
            }
        }
    }
    
    var header: some View {
        HStack(spacing: 16) {
            
            CachedAsyncImage(url: URL(string: hostel?.imageURL ?? "xxx"), transaction: Transaction(animation: .easeInOut.speed(1.5))) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                case .failure(_):
                    Image("defaultImageCard")
                        .resizable()
                default:
                    ZStack {
                        Image("defaultImageCard")
                            .resizable()
                        Color.black.opacity(0.5)
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.3)
                    }
                }
            }
            .scaledToFill()
            .frame(width: 41, height: 41)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.5), radius: 3, y: 3)
            
            VStack(alignment: .leading) {
                Text("Guest at")
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                    .fontWeight(.medium)
                
                Text(hostel?.name ?? "")
                    .font(Font.custom("Bricolage Grotesque", size: 20))
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
    }
    
    var eventsSliderView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                let sortedEvents = searchResults.sorted(by: <)
                
                ForEach(sortedEvents) { event in
                    
                    if event.eventCategory.eventType.rawValue == "hostel" /*|| (event.dateDetails?.hasEventPassed == false)*/ {
                        if #available(iOS 18, *) {
                            NavigationLink(destination: NewEventPageViewIOS18(event: event)) {
                                NewEventCard(
                                    clicouGoing: $clicouGoing,
                                    event: event
                                )
                            }
                            
                        } else {
                            NavigationLink(destination: NewEventPageView(event: event)) {
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
            filteredEvents = filteredEvents.filter {
                $0.eventCategory.eventType.rawValue == "hostel"
                && $0.eventCategory.hostelID == hostelID
            }
        }
        
        return filteredEvents
    }
}

#Preview {
    EventsSliderHostel(
        hostelID: "47O8cVGWD0OmpMqyY2BQV2fxdMj1",
        isLoading: .constant(false),
        searchText: .constant(""),
        deuRefresh: .constant(false),
        clicouGoing: .constant(false)
    )
}




