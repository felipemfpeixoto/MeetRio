//
//  YourEventsView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 22/08/24.
//

import Foundation
import SwiftUI

struct YourEventsView: View{
    @EnvironmentObject var sheetViewModel: SheetViewModel
    
    @State var yourEvents: [EventDetails]?
    
    @Binding var loggedCase: LoginCase
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var searchText = ""
    @State var selected: EventDetails? = nil
    @State private var shouldNavigate = false
    @State private var selectedEvent: EventDetails?
    
    @State private var isVisible = false
 
    @State var needsAtt: Bool = false
    @State var isLoading: Bool = false
    
    
    var body: some View {
        ZStack{
            VStack {
                header
                    .onAppear{
                        needsAtt.toggle()
                    }
                // TODO: Depois tem que mudar esse binding de sheetViewModel
                CustomSearchBar(searchText: $searchText, filterButton: $sheetViewModel.isShowing, showFilter: false)
                    .padding(.top, -35)
                    .padding(.horizontal)
                Spacer()
            }.ignoresSafeArea()
            VStack{
                if isLoading {
                    ProgressView()
                } else if let yourEvents, yourEvents.isEmpty {
                    Text("No events yet")
                } else {
                    ListView
                    // Frufru para ficar mais polido na entrega final
                    if isVisible {
                        Color.clear.frame(height: screenHeight/10)
                    }
                }
            }
            .padding(.top, screenHeight/5)
        }
        .onAppear {
            yourEvents = YourEventsModel.shared.events
        }
        
    }

    
    var header: some View{
        VStack{
            Image("skyImage")
                .resizable()
                .frame(width: screenWidth, height: screenHeight / 5)
                .overlay{
                    HStack {

                        Text("Your ")
                            .font(.title)
                            .fontWeight(.bold)
                            
                        +
                        Text("events")
                            .font(.title.italic())
                            .fontWeight(.light)
  
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 35)
                    .padding(.top, 50)
                        
                }
        }
    }
    
    var ListView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(searchResults, id: \.name) { event in
                    if #available(iOS 18, *) {
                        NavigationLink(destination: NewEventPageViewIOS18(loggedCase: $loggedCase, event: event)) {
                            LateralCard(event: event, needAtt: $needsAtt)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                    } else {
                        NavigationLink(destination: NewEventPageView(loggedCase: $loggedCase, event: event)) {
                            LateralCard(event: event, needAtt: $needsAtt)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                    }
                }
            }
        }
    }

    var searchResults: [EventDetails] {
        if let yourEvents {
            var filteredEvents = yourEvents
            
            if !searchText.isEmpty {
                filteredEvents = filteredEvents.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
            
            return filteredEvents
        }
        return []
    }
}

#Preview {
    YourEventsView(loggedCase: .constant(.registered))
        .environmentObject(SheetViewModel())
}
