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
}

struct SignUpView: View {
    
    // MARK: Variáveis do login
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @Binding var isShowing: Bool
    @Binding var arbiuPrimeiraVez: Bool
    
    @State var didNavigate = false
    
    @State var isShowingWarningEmail = false
    @State var isShowingWarningPassword = false
    @State var isLoading = false
    
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
            PictureNameSelectionView(isShowingFullScreenCover: $isShowing, arbiuPrimeiraVez: $arbiuPrimeiraVez, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad)
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
                TextField("Email...", text: $email)
                    .textFieldStyle()
                
                SecureField("Password...", text: $password)
                    .textFieldStyle()
                
                SecureField("Confirm password...", text: $confirmPassword)
                    .textFieldStyle()
                
                if password.count < 6 {
                    Text("The password must be 6 characters long")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                } else if password != confirmPassword {
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
                        
                        try await Fornecedor.shared.createUser(email: email, password: password)
                        
                        didStartSignUpFlow = true
                        PostHogSDK.shared.capture("SignUpEmail&Senha")
                        didNavigate.toggle()
                    } catch {
                        isShowingWarningEmail.toggle()
                        isLoading = false
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(validateData() && matchPassword() ? .black : .white)
                    Text("Create")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
            }
            .opacity(validateData() && matchPassword() ? 1 : 0.5)
            .frame(height: 44)
            .disabled(!(validateData() && matchPassword()))
        }
    }
    
    func validateData() -> Bool {
        return !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    func matchPassword() -> Bool {
        return password == confirmPassword && !password.isEmpty
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SignUpView(isShowing: .constant(true), arbiuPrimeiraVez: .constant(true), didStartSignUpFlow: .constant(true), willLoad: .constant(false))
}
