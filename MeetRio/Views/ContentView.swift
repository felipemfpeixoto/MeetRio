//
//  ContentView.swift
//  MeetRio
//
//  Created by Felipe on 30/07/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // TODO: Mudar a lógica, para que não seja mais necessário atualizar a variável na mão, mas sim fazer com que ela seja um "listener" do Fornecedor.shared.userVariable, para que essa variávela seja atualizada quando o userVariable for nil
    @State var showingSignInView: Bool = false
    
    @State var isLoading = true
    @State var didAppear = true
    
    @State var willLoad: Bool = false
    
    @State var abriuPrimeiraVez = true
    
    @State var wasLoggedIn = false
    
    @Binding var didStartSignUpFlow: Bool
    
    var body: some View {
        ZStack {
//            TabViewContainer(isAuthenticated: $showingSignInView, willLoad: $willLoad, arbiuPrimeiraVez: $abriuPrimeiraVez)
            VStack {
                if Hospede.loggedCase == .anonymous {
                    Text("Logou: \(Hospede.loggedCase)")
                } else if Hospede.loggedCase == .registered {
                    Text("Logou: \(Hospede.loggedCase)")
                    Text("Name: \(Fornecedor.shared.userVariable!.name)")
                }
                Button {
                    Task {
                        do {
                            try await Fornecedor.shared.userSignOut()
                            showingSignInView.toggle()
                        } catch {
                            print("Erro ao dar o logout do anonimo: \(error)")
                        }
                    }
                } label: {
                    Text("Sign Out")
                        .foregroundStyle(Color.white)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.blue)
                }
            }
            launchScreen
        }
        // MARK: Não entendi por que esse onChange existe
//        .onChange(of: loggedCase) {
//            if loggedCase != .none {
//                Task {
//                    await FirestoreManager.shared.getAllEvents()
//                }
//            }
//        }
        .task {
            do {
                try await Fornecedor.shared.loadAuthUser()
                self.showingSignInView = Fornecedor.shared.userVariable == nil
                if !showingSignInView {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        if abriuPrimeiraVez {
                            willLoad.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                                abriuPrimeiraVez = false
                            }
                        }
                    }
                }
            } catch {
                print(error)
                showingSignInView.toggle()
            }
        }
        .fullScreenCover(isPresented: $showingSignInView, content: {
            WelcomeSignInView(isShowing: $showingSignInView, arbiuPrimeiraVez: $abriuPrimeiraVez, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad)
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
        // MARK: Não entendi por que esse onChange existe
//        .onChange(of: loggedCase) { newCase in
//            if newCase != .none {
//                withAnimation(Animation.easeInOut(duration: 0.75)) {
//                    isLoading = false
//                }
//            }
//        }
    }
}


#Preview {
    ContentView(didStartSignUpFlow: .constant(false))
}

