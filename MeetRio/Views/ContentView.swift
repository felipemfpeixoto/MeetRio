//
//  ContentView.swift
//  MeetRio
//
//  Created by Felipe on 30/07/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var vm = SettingsViewModel()
    
    @State var loggedCase: LoginCase = .none
    
    @State var showingSignInView: Bool = false
    @State var isLoading = true
    @State var didAppear = true
    
    @State var willLoad: Bool = false
    
    @State var abriuPrimeiraVez = true
    
    @State var wasLoggedIn = false
    
    @Binding var didStartSignUpFlow: Bool
    
    var body: some View {
        ZStack {
            TabViewContainer(isAuthenticated: $showingSignInView, loggedCase: $loggedCase, willLoad: $willLoad, arbiuPrimeiraVez: $abriuPrimeiraVez)
            launchScreen
        }
        .onChange(of: loggedCase) {
            if loggedCase != .none {
                Task {
                    await FirestoreManager.shared.getAllEvents()
                }
            }
        }
        .onAppear() {
            let authUser = try? Fornecedor.loadAuthUser()
            self.showingSignInView = authUser == nil
            if !showingSignInView {
                Task {
                    try await UserManager.shared.getUser(userID: authUser?.uid ?? "")
                    
                    let authUser2 = vm.loadAuthUser()
                    if authUser2?.isAnonymous == false{
                        loggedCase = .registered
                        print("Autentiquei como Registrado")
                    }
                    else if authUser2?.isAnonymous == true{
                        loggedCase = .anonymous
                        print("Autentiquei como anônimo")
                    }
                    else{
                        loggedCase = .none
                        print("Autentiquei como none")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    if abriuPrimeiraVez {
                        willLoad.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                            abriuPrimeiraVez = false
                        }
                    }
                }
            }

        }
        .fullScreenCover(isPresented: $showingSignInView, content: {
            WelcomeSignInView(isShowing: $showingSignInView, arbiuPrimeiraVez: $abriuPrimeiraVez, loggedCase: $loggedCase, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad)
        })
        .onChange(of: abriuPrimeiraVez){ newValue, oldOne in
        
            if abriuPrimeiraVez {
                withAnimation(Animation.bouncy(duration: 0.75)) {
                    isLoading = true
                    didAppear = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                    abriuPrimeiraVez = false
                }
            }
        }
        .onChange(of: showingSignInView) {
            if !showingSignInView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    willLoad.toggle()
                }
            }
        }
    }
    
    var launchScreen: some View {
        ZStack {
            if abriuPrimeiraVez {
                Color.black
                    .ignoresSafeArea()
                Image("meetRioLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width/1.5)
                    .offset(x: didAppear ? -UIScreen.main.bounds.width : 0)
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                }
            }
        }
        .offset(x: isLoading ? 0 : -UIScreen.main.bounds.width)
        .onAppear {
            withAnimation(Animation.bouncy(duration: 0.75)) {
                didAppear.toggle()
            }
        }
        .onChange(of: loggedCase) { newCase in
            if newCase != .none {
                withAnimation(Animation.easeInOut(duration: 0.75)) {
                    isLoading = false
                }
            }
        }
    }
}


#Preview {
    ContentView(didStartSignUpFlow: .constant(false))
}

