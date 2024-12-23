//
//  AuthenticationView.swift
//  MeetRio
//
//  Created by Felipe on 15/08/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import PostHog


struct AuthenticationView: View {
    
    @Binding var isShowing: Bool
    @Binding var arbiuPrimeiraVez: Bool
    
    @State var isLoading = false
    @State var didNavigate = false
    @State var userID: String?
    @State var showWarning: Bool = false
    @State var didLogin: Int?
    
    @State var email: String = ""
    @State var password: String = ""
    
    @Binding var didStartSignUpFlow: Bool
    
    @Binding var willLoad: Bool

    var body: some View {
        GeometryReader { _ in
            ZStack {
                backgroundContainer
                if UIScreen.main.bounds.height <= 667 {
                    ScrollView {
                        contentStack
                    }
                    loadingOverlay
                } else {
                    contentStack
                        .padding(.horizontal)
                        .padding(.bottom)
                    loadingOverlay
                }
            }
            .navigationBarBackButtonHidden(isLoading ? true : false)
            .tint(.white)
//            .navigationDestination(isPresented: $didNavigate) {
//                Picture_NameSelectionView(isShowingFullScreenCover: $isShowing, arbiuPrimeiraVez: $arbiuPrimeiraVez, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad, userID: userID ?? "")
//            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            UIApplication.shared.endEditing()
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

    var contentStack: some View {
        VStack(spacing: 24) {
            Spacer()
            titleContainer
            textFieldsContainer
                .tint(.blue)
            orContainer
            anonymouslySigninButton
//            googleSignInButtonContainer
//            appleSignInButtonContainer
            Spacer()
            Spacer()
            Spacer()
            VStack(spacing: 5) {
//                forgotPasswordContainer // Não ta funcionando ainda
//                signUpContainer
            }.padding(.bottom)
            Spacer()
        }
        .padding()
    }

    var loadingOverlay: some View {
        ZStack{
            if isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
            } else {
                EmptyView()
            }
        }
    }

    var titleContainer: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Log In to Your Account")
                    .font(Font.custom("Bricolage Grotesque", size: 26))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            Spacer()
        }
    }

    var textFieldsContainer: some View {
        VStack {
            if showWarning {
                Text(warningText())
                    .foregroundStyle(.marcaTexto)
                    .font(Font.custom("Bricolage Grotesque", size: 18))
            }
            VStack(spacing: 17) {
                TextField("Email", text: $email)
                    .textFieldStyle()
                SecureField("Password", text: $password)
                    .textFieldStyle()
                signInButton
                    .padding(.top)
            }
        }
    }

    var orContainer: some View {
        HStack(spacing: 40) {
            Rectangle()
                .foregroundStyle(.white)
                .frame(height: 1)
            Text("or")
                .font(.system(size: 18).weight(.medium))
                .foregroundStyle(.white)
            Rectangle()
                .foregroundStyle(.white)
                .frame(height: 1)
        }
    }

    var signInButton: some View {
        Button(action: signInAction, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 44)
                    .foregroundStyle(.pretin)
                    .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
                Text("Done")
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
        })
    }

    var anonymouslySigninButton: some View {
        Button {
            Task {
                do {
                    isLoading = true
                    
                    try await Fornecedor.shared.anonymousLogin()
                    
                    isShowing = false
                    isLoading = false
                    arbiuPrimeiraVez = false
                    PostHogSDK.shared.capture("LoginAnonimo") // Captura o evento de login anônimo
                } catch { // TODO: (3) Melhorar esse catch para mostrar um alerta que o login anonimo deu um erro
                    print(error)
                    isLoading = false
                }
            }
        } label: {
            Text("Enter without login")
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
        .accessibilityIdentifier("signInAnonymous")
        .frame(height: 15)

    }
    
//    var forgotPasswordContainer: some View {
//        NavigationLink(destination: ResetPasswordView()) {
//            Text("Set or Reset your password")
//                .font(.system(size: 15))
//                .fontWeight(.semibold)
//                .foregroundStyle(.white)
//        }
//    }

//    var signUpContainer: some View {
//        HStack {
//            NavigationLink(destination: SignUpView(isShowing: $isShowing, arbiuPrimeiraVez: $arbiuPrimeiraVez, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad)) {
//                    Text("Doesn't have an account?")
//                        .foregroundStyle(.white)
//                    + Text(" Sign Up")
//                        .fontWeight(.bold)
//                        .foregroundStyle(.white)
//            }
//        }.font(.system(size: 15))
//    }

    // MARK: - Helper Methods
    private func warningText() -> String {
        switch didLogin {
        case 0:
            return "Please provide an email and password"
        case 2:
            return "Please provide a password"
        case 3:
            return "Please provide an email"
        default:
            return "Email or password incorrect"
        }
    }
    
    // MARK: Formatar essa função para estar de acordo com a nova modelagem
    private func signInAction() {
//        Task {
//            do {
//                UIApplication.shared.endEditing()
//                isLoading = true
//                showWarning = false
//                didLogin = nil
//                didLogin = try await vm.signIn() // Chama a função de login existente no ViewModel
//                if didLogin == 1 {
//                    arbiuPrimeiraVez = false
//                    isShowing = false
//                    isLoading = false
//                    PostHogSDK.shared.capture("LoginEmail&Senha") // Captura o evento de login com email e senha
//                    postLoginSuccess()
//                }
//            } catch {
//                let emailEmpty = vm.email.isEmpty
//                let passwordEmpty = vm.password.isEmpty
//                if emailEmpty && passwordEmpty {
//                    print("email e senha vazios")
//                    didLogin = 0
//                } else if emailEmpty {
//                    didLogin = 3
//                } else if passwordEmpty {
//                    didLogin = 2
//                }
//                showWarning = true
//                isLoading = false
//            }
//        }
    }
}

extension View {
    func textFieldStyle() -> some View {
        self
            .font(.system(size: 18))
            .padding(.horizontal)
            .frame(height: 44)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
            .autocapitalization(.none)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AuthenticationView(isShowing: .constant(true), arbiuPrimeiraVez: .constant(true), didStartSignUpFlow: .constant(false), willLoad: .constant(false))
}



