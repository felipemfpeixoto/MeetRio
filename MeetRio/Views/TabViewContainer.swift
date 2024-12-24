//
//  TabViewContainer.swift
//  MeetRio
//
//  Created by Felipe on 11/08/24.
//

import SwiftUI

enum SelectedScreen {
    case calendar, home, hostel, yourEvents, event
}



struct TabViewContainer: View {
    @Binding var isAuthenticated: Bool
    
    @State var openFirst = true
    
    @State var selectedScreen: SelectedScreen = .home
    
    @Binding var willLoad: Bool
    
    @Binding var arbiuPrimeiraVez: Bool
    
    var body: some View {
        
        ZStack{
            TabView(selection: $selectedScreen) {
                
                HomeView(selectedScreen: $selectedScreen, isAuthenticated: $isAuthenticated, deuRefresh: $willLoad, arbiuPrimeiraVez: $arbiuPrimeiraVez)
                    .tabItem {
                        Image(systemName: "wineglass")
                            .environment(\.symbolVariants, .none)
                        Text("Events")
                    }
                    .tag(SelectedScreen.home)
                    
                
//                YourEventsView(loggedCase: $loggedCase)
                Text("YourEventsView")
                    .tabItem {
                        Image(systemName: "checkmark.seal")
                            .environment(\.symbolVariants, .none)
                        Text("Your Events")
                    }
                    .tag(SelectedScreen.yourEvents)
                
//                HostelView()
                Text("HostelView")
                    .tabItem {
                        Image(systemName: "bed.double")
                            .environment(\.symbolVariants, .none)
                        Text("Your Hostel")
                    }
                    .tag(SelectedScreen.hostel)
                    
            }
            .accentColor(.black)
            
            .onAppear {
                UITabBar.appearance().backgroundColor = UIColor.white
            }
        }
        
    }
}

#Preview{
    TabViewContainer(isAuthenticated: .constant(true), willLoad: .constant(false), arbiuPrimeiraVez: .constant(true))
}
