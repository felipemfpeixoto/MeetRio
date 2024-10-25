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
    var confirmPassword: String = ""
    
    var userID: String = ""
    
    var name: String = ""
    var picture: Data?
    
    var country: CountryDetails?
    
    @MainActor
    func signUp(hospede: Hospede) async throws -> Bool {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
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
    
    func validateData() -> Bool {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            return false
        }
        return true
    }
    
    func matchPassword() -> Bool {
        if password == confirmPassword && !password.isEmpty {
            return true
        }
        return false
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
        GeometryReader { geo in
            ZStack {
                backgroundContainer
                VStack(spacing: 48) {
                    titleContainer
                    textFieldsContainer
                    continueButton
                    Spacer()
                }
                .ignoresSafeArea(.keyboard)
                .padding()
                .padding(.top)
                .tint(.blue)
                VStack {
                    Spacer()
                    Image("MeetRioLogoPeq")
                        .padding(.bottom, geo.size.height / 6)
                }
                if isLoading {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.4)
                    ProgressView()
                        .tint(.white)
                }
            }
            .onAppear {
                print(geo.size.height)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
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
        }
        .ignoresSafeArea()
    }
    
    var titleContainer: some View {
        HStack {
            Text("Create an Account")
                .font(Font.custom("Bricolage Grotesque", size: 26))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Spacer()
        }
    }
    
    var textFieldsContainer: some View {
        VStack(spacing: 50) {
            VStack(spacing: 16) {
                if isShowingWarningEmail {
                    Text("This email is already used by another account, please try again")
                        .font(.system(size: 14))
                        .foregroundStyle(.marcaTexto)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                }
                TextField("Email...", text: $vm.email)
                    .textFieldStyle()
                
                SecureField("Password...", text: $vm.password)
                    .textFieldStyle()
                
                SecureField("Confirm password...", text: $vm.confirmPassword)
                    .textFieldStyle()
                
                if vm.password.count < 6 {
                    Text("The password must be 6 characters long")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                } else if vm.password != vm.confirmPassword {
                    Text("The passwords must match")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
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
                        dismissKeyboard()
                        isLoading = true
                        let didCreateUser = try await vm.signUp(hospede: Hospede(name: "", country: CountryDetails(name: "", flag: "")))
                        if didCreateUser {
                            didStartSignUpFlow = true
                            PostHogSDK.shared.capture("SignUpEmail&Senha")
//                            loggedCase = .registered
                            didNavigate.toggle()
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
                        .foregroundStyle(vm.validateData() && vm.matchPassword() ? .black : .white)
                    Text("Create")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
            }
            .opacity(vm.validateData() && vm.matchPassword() ? 1 : 0.5)
            .frame(height: 44)
            .disabled(!(vm.validateData() && vm.matchPassword()))
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SignUpView(isShowing: .constant(true), arbiuPrimeiraVez: .constant(true), loggedCase: .constant(.none), didStartSignUpFlow: .constant(true), willLoad: .constant(false))
}
