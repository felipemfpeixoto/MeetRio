//
//  SignUpView.swift
//  MeetRio
//
//  Created by Felipe on 15/08/24.
//

import SwiftUI
import PostHog

@Observable
final class SignUpEmailViewModel {
    
    var email: String = ""
    var password: String = ""
    
    var userID: String = ""
    
    var name: String = ""
    var picture: Data?
    
    var country: CountryDetails?
    
    @MainActor
    func signUp(hospede: Hospede) async throws -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            return false
        }
        
        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        if returnedUserData != nil {
            self.userID = returnedUserData!.uid
            return true
        }
        return false
    }
    
    @MainActor
    func getUserWithEmail() async throws {
        
    }
}

struct SignUpView: View {
    
    @State private var vm = SignUpEmailViewModel()
    
    @Binding var isShowing: Bool
    @Binding var arbiuPrimeiraVez: Bool
    
    @State var didNavigate = false
    
    @State var isShowingWarningEmail = false
    @State var isShowingWarningPassword = false
    @State var isLoading = false
    
    @Binding var loggedCase: LoginCase
    
    @Binding var didStartSignUpFlow: Bool
    
    @Binding var willLoad: Bool
    
    var body: some View {
        ZStack {
            backgroundContainer
            VStack(spacing: 120) {
                textFieldsContainer
                continueButton
            }.padding()
            if isLoading {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.4)
                ProgressView()
                    .tint(.white)
            }
        }
        .navigationDestination(isPresented: $didNavigate) {
            Picture_NameSelectionView(isShowingFullScreenCover: $isShowing, arbiuPrimeiraVez: $arbiuPrimeiraVez, loggedCase: $loggedCase, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad, userID: vm.userID)
        }
    }
    
    var backgroundContainer: some View {
        ZStack {
            Image("cristoBackground")
                .resizable()
                .scaledToFill()
            LinearGradient(gradient: Gradient(colors: [.black, .clear, .black]), startPoint: .top, endPoint: .bottom)
                .opacity(0.4)
            Rectangle()
                .opacity(0.15)
        }
        .ignoresSafeArea()
    }
    
    var textFieldsContainer: some View {
        VStack(spacing: 50) {
            HStack {
                Text("Create an Account")
                    .font(Font.custom("Bricolage Grotesque", size: 26))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
            }
            VStack {
                if isShowingWarningEmail {
                    Text("This email is already used by another account, please try again")
                        .font(.system(size: 14))
                        .foregroundStyle(.marcaTexto)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                }
                TextField("Email...", text: $vm.email)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
                    .autocapitalization(.none)
                
                SecureField("Password...", text: $vm.password)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
                
                if vm.password.count < 6 {
                    Text("The password must be 6 characters long")
                        .font(.system(size: 14))
                        .foregroundStyle(.marcaTexto)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
    var continueButton: some View {
        ZStack {
            Button {
                Task {
                    do {
                        isLoading = true
                        let didCreateUser = try await vm.signUp(hospede: Hospede(name: "", country: CountryDetails(name: "", flag: ""), picture: Data()))
                        if didCreateUser {
                            didNavigate.toggle()
                            didStartSignUpFlow = true
                            PostHogSDK.shared.capture("SignUpEmail&Senha")
//                            loggedCase = .registered
                        } else {
                            isShowingWarningEmail.toggle()
                            isLoading = false
                        }
                    } catch {
                        isShowingWarningEmail.toggle()
                        isLoading = false
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.marcaTexto)
                    Text("Continue")
                        .foregroundStyle(.black)
                }
            }.frame(height: 55)
        }
    }
}

//#Preview {
//    SignUpView(isShowing: .constant(true), arbiuPrimeiraVez: .constant(true))
//}
