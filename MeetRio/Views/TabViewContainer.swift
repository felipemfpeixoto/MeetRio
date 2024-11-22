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

enum LoginCase {
    case anonymous, registered, none
}

struct TabViewContainer: View {
    @State private var vm = SettingsViewModel()
    
    @StateObject var sheetViewModel = SheetViewModel()
    
    let fsManager = FirestoreManager.shared
    @Binding var isAuthenticated: Bool
    
    @State var openFirst = true
    
    @State var selectedScreen: SelectedScreen = .home
    
    @Binding var loggedCase: LoginCase
    
    @Binding var willLoad: Bool
    
    @Binding var arbiuPrimeiraVez: Bool
    
    var body: some View {
        
        ZStack{
            TabView(selection: $selectedScreen) {
                
                HomeView(selectedScreen: $selectedScreen, isAuthenticated: $isAuthenticated, deuRefresh: $willLoad, loggedCase: $loggedCase, arbiuPrimeiraVez: $arbiuPrimeiraVez)
                    .tabItem {
                        Image(systemName: "wineglass")
                            .environment(\.symbolVariants, .none)
                        Text("Events")
                    }
                    .tag(SelectedScreen.home)
                    
                
                YourEventsView(loggedCase: $loggedCase)
                    .tabItem {
                        Image(systemName: "checkmark.seal")
                            .environment(\.symbolVariants, .none)
                        Text("Your Events")
                    }
                    .tag(SelectedScreen.yourEvents)
                    .environmentObject(sheetViewModel)
                
                HostelView()
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
    TabViewContainer(isAuthenticated: .constant(true), loggedCase: .constant(.registered), willLoad: .constant(false), arbiuPrimeiraVez: .constant(true))
}
