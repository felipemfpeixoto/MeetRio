//
//  SearchScreenView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 20/08/24.
//

import Foundation
import SwiftUI

struct SearchScreenView: View{
    
    @EnvironmentObject var sheetViewModel: SheetViewModel
    @Binding var loggedCase: LoginCase
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var searchText = ""
    @State var selected: EventDetails? = nil
    @State private var shouldNavigate = false
    @State private var selectedEvent: EventDetails?
    
    @State private var isVisible = false
    
    var body: some View {
        VStack{
            header
            
            CustomSearchBar(searchText: $searchText, filterButton: $sheetViewModel.isShowing)
            
            ListView
            
            // Frufru para ficar mais polido na entrega final
            if isVisible {
                Color.clear.frame(height: screenHeight/10)
            }
            
        }.ignoresSafeArea()
    }

    
    var header: some View{
        VStack{
            Rectangle()
                .foregroundStyle(Color.black)
                .frame(width: screenWidth, height: screenHeight / 7)
                .overlay{
                    HStack {

                        Text("Search ")
                            .font(.title)
                            .fontWeight(.bold)
                            
                        +
                        Text("event")
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
                    NavigationLink(destination: NewEventPageView(loggedCase: $loggedCase, event: event)) {
                        EventCard(event: event, selected: $selected)
                    }
                }
                // Daqui para baixo é só frufru para ficar mais polido na entrega final
                GeometryReader { geometry in
                    Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                }
                .frame(height: 1)
            }
            .onPreferenceChange(ViewOffsetKey.self) { value in
                isVisible = value < (UIScreen.main.bounds.height - 1)
            }
        }
    }


    var searchResults: [EventDetails] {
        var filteredEvents = events
        
        if !searchText.isEmpty {
            filteredEvents = filteredEvents.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        
//        if sheetViewModel.selectedSafetyRating > 0 {
//            filteredEvents = filteredEvents.filter {
//                Int($0.safetyRate) == sheetViewModel.selectedSafetyRating
//            }
//        }
//        
        return filteredEvents
    }
}

#Preview {
    SearchScreenView(loggedCase: .constant(.registered))
        .environmentObject(SheetViewModel())
}


// Frufru para ficar mais polido na entrega final
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
