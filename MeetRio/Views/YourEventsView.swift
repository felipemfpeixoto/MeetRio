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
    
    @Binding var loggedCase: LoginCase
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var searchText = ""
    @State var selected: EventDetails? = nil
    @State private var shouldNavigate = false
    @State private var selectedEvent: EventDetails?
    
    @State private var isVisible = false
    
    @State var yourEvents: [EventDetails] = []
    
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
                } else if yourEvents.isEmpty{
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
            
            
            .onChange(of: needsAtt){
                //MARK: Código meio zoado
                Task {
                    yourEvents = try await FirestoreManager.shared.userGoingEvents(UserManager.shared.hospede?.id ?? "")
                }
                needsAtt.toggle()
            }
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
                
                
                // Daqui para baixo é só frufru para ficar mais polido na entrega final
                GeometryReader { geometry in
                    Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                }
                .frame(height: 1)
            }.padding(.bottom, 96)
            .onPreferenceChange(ViewOffsetKey.self) { value in
                isVisible = value < (UIScreen.main.bounds.height - 1)
            }
        }
        .refreshable {
            Task {
                isLoading = true
                yourEvents = try await FirestoreManager.shared.userGoingEvents(UserManager.shared.hospede?.id ?? "")
                isLoading = false
            }
        }
    }

    var searchResults: [EventDetails] {
        var filteredEvents = yourEvents
        
        if !searchText.isEmpty {
            filteredEvents = filteredEvents.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
//        // TODO: Depois tem que mudar esse binding de sheetViewModel
//        if sheetViewModel.selectedSafetyRating > 0 {
//            filteredEvents = filteredEvents.filter {
//                Int($0.safetyRate) == sheetViewModel.selectedSafetyRating
//            }
//        }
        
        return filteredEvents
    }
}

//#Preview {
//    YourEventsView()
//        .environmentObject(SheetViewModel())
//}
