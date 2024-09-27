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
            launchSreen
//            Button {
//                Task {
//                    try await botaTudo()
//                }
//            } label: {
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundStyle(.blue)
//                Text("Bota")
//            }
//            .frame(height: 55)

        }
        .onAppear {
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                print("(ContentView - OnAppear) AuthUser = \(authUser?.uid)")
                self.showingSignInView = authUser == nil
                if !showingSignInView {
                    Task {
                        try await UserManager.shared.getUser(userID: authUser?.uid ?? "")
                        print(authUser?.uid)
                        print("(ContentView - OnAppear) Peguei o user")
                        
                        let authUser2 = vm.loadAuthUser()
                        if authUser2?.isAnonymous == false{
                            loggedCase = .registered
                        }
                        else if authUser2?.isAnonymous == true{
                            loggedCase = .anonymous
                        }
                        else{
                            loggedCase = .none
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            withAnimation(Animation.linear(duration: 0.25)) {
                                isLoading.toggle()
                            }
                            if abriuPrimeiraVez {
                                willLoad.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                                    abriuPrimeiraVez = false
                                }
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
                isLoading = true
                didAppear = true
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                    abriuPrimeiraVez = false
                }
            }
        }
        // Bloco responsável por carregar os eventos após o usuário fazer login
        .onChange(of: showingSignInView) {
            if !showingSignInView {
                print("Mudou willLoad no onchange da showSignInView")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    willLoad.toggle()
                }
            }
        }
    }
    
    var launchSreen: some View {
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
//        .opacity(isLoading ? 1 : 0)
        .offset(x: isLoading ? 0 : -UIScreen.main.bounds.width)
        .onAppear {
            withAnimation(Animation.bouncy(duration: 0.75)) {
                didAppear.toggle()
            }
        }
    }
    
//    func botaTudo() async throws {
//        for event in eventsBD {
//            try FirestoreManager.shared.db.collection("Events").addDocument(from: event)
//            print("Botou \(event.name)")
//        }
//    }
}

//#Preview {
//    ContentView()
//}

