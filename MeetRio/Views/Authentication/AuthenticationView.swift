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

@Observable
final class SignInEmailViewModel {
    
    @MainActor let signInAppleHelper = SignInAppleHelper()
    
    var email: String = ""
    var password: String = ""
    
    
    func signIn() async throws -> Int {
        let user = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        try await UserManager.shared.getUser(userID: user.uid)
        // chamar o get user do UserManager, caso não possua o documento no db, criar um e começar a navegação de criar o perfil
        return 1
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func googleSignIn() async throws -> String {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let result = try await AuthenticationManager.shared.sigInWithGoogle(tokens: tokens)
        return result.uid
    }
    
    @MainActor
    func signInWithApple() async throws -> String {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let result = try await AuthenticationManager.shared.sigInWithApple(tokens: tokens)
        return result.uid
    }
    
    func signInAnonymous() async throws{
        try await AuthenticationManager.shared.signInAnonymous()
    }
}


struct AuthenticationView: View {
    @State private var vm2 = SettingsViewModel()
    @State private var vm = SignInEmailViewModel()
    @Binding var loggedCase: LoginCase
    @Binding var isShowing: Bool
    @Binding var arbiuPrimeiraVez: Bool
    @State var isLoading = false
    @State var didNavigate = false
    @State var userID: String?
    @State var showWarning: Bool = false
    @State var didLogin: Int?
    
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
            .tint(.white)
            .navigationDestination(isPresented: $didNavigate) {
                Picture_NameSelectionView(isShowingFullScreenCover: $isShowing, arbiuPrimeiraVez: $arbiuPrimeiraVez, loggedCase: $loggedCase, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad, userID: userID ?? "")
            }
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
                forgotPasswordContainer // Não ta funcionando ainda
                signUpContainer
            }
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
                TextField("Email", text: $vm.email)
                    .textFieldStyle()
                SecureField("Password", text: $vm.password)
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
                    .frame(width: .infinity ,height: 44)
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
        Button(action: signInAnonymous, label: {
            Text("Enter without login")
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        })
        .frame(height: 15)
    }

    var googleSignInButtonContainer: some View {
        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal), action: googleSignIn)
    }

    var appleSignInButtonContainer: some View {
        Button(action: signInWithApple, label: {
            SignInWithAppleButtonViewRepresentable(type: .default, style: .white)
                .allowsHitTesting(false)
        })
        .frame(height: 55)
    }
    
    var forgotPasswordContainer: some View {
        Text("Set or Reset your password")
            .font(.system(size: 15))
            .fontWeight(.semibold)
            .foregroundStyle(.white)
    }

    var signUpContainer: some View {
        HStack {
            NavigationLink(destination: SignUpView(isShowing: $isShowing, arbiuPrimeiraVez: $arbiuPrimeiraVez, loggedCase: $loggedCase, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad)) {
                    Text("Doesn't have an account?")
                        .foregroundStyle(.white)
                    + Text(" Sign Up")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
            }
        }.font(.system(size: 15))
    }

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

    private func signInAction() {
        Task {
            do {
                isLoading = true
                showWarning = false
                didLogin = nil
                didLogin = try await vm.signIn() // Chama a função de login existente no ViewModel
                if didLogin == 1 {
                    arbiuPrimeiraVez = false
                    isShowing = false
                    isLoading = false
                    PostHogSDK.shared.capture("LoginEmail&Senha") // Captura o evento de login com email e senha
                    postLoginSuccess()
                }
            } catch {
                let emailEmpty = vm.email.isEmpty
                let passwordEmpty = vm.password.isEmpty
                if emailEmpty && passwordEmpty {
                    print("email e senha vazios")
                    didLogin = 0
                } else if emailEmpty {
                    didLogin = 3
                } else if passwordEmpty {
                    didLogin = 2
                }
                showWarning = true
                isLoading = false
            }
        }
    }

    private func signInAnonymous() {
        Task {
            do {
                isLoading = true
                try await vm.signInAnonymous() // Chama a função de login anônimo no ViewModel
                isShowing = false
                isLoading = false
                arbiuPrimeiraVez = false
                PostHogSDK.shared.capture("LoginAnonimo") // Captura o evento de login anônimo
                postLoginSuccess()
            } catch {
                print(error)
                isLoading = false
            }
        }
    }

    private func googleSignIn() {
        Task {
            do {
                print("Entrou")
                isLoading = true
                self.userID = try await vm.googleSignIn() // Chama a função de login com Google no ViewModel
                print("userID: ", userID)
                let hospede = try? await FirestoreManager.shared.db.collection("Hospedes").document(userID!).getDocument(as: Hospede.self)
                print(hospede)
                
                if let hospede {
                    isShowing = false
                    PostHogSDK.shared.capture("LoginGoogle") // Captura o evento de login com Google
                    postLoginSuccess()
                } else {
                    didNavigate = true
                    print("Fiz login com a google pela primeira vez")
                    PostHogSDK.shared.capture("LoginGoogle_primeiraVez") // Captura o evento de primeiro login com Google
                }
                isLoading = false
            } catch {
                print("Deu erro ao fazer log in com google: ", error)
                isLoading = false
                PostHogSDK.shared.capture("LoginGoogle_error") // Captura o erro de login com Google
            }
        }
    }

    private func signInWithApple() {
        Task {
            do {
                isLoading = true
                self.userID = try await vm.signInWithApple() // Chama a função de login com Apple no ViewModel
                let hospede = try? await FirestoreManager.shared.db.collection("Hospedes").document(userID!).getDocument(as: Hospede.self)
                if let hospede {
                    isShowing = false
                    PostHogSDK.shared.capture("LoginApple") // Captura o evento de login com Apple
                    postLoginSuccess()
                } else {
                    didNavigate = true
                    isLoading = false
                    print("Fiz login com a apple pela primeira vez")
                    PostHogSDK.shared.capture("LoginApple_primeiraVez") // Captura o evento de primeiro login com Apple
                }
            } catch {
                print("Deu erro ao fazer log in com apple: ", error)
                isLoading = false
                PostHogSDK.shared.capture("LoginApple_error") // Captura o erro de login com Apple
            }
        }
    }
    
    private func postLoginSuccess() {
        Task {
            do {
                // Recupera o usuário autenticado através do AuthenticationManager
                let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
                
                // Recupera informações adicionais do usuário com UserManager
                let userDetails: () = try await UserManager.shared.getUser(userID: authUser.uid)
                
                // Carrega as informações do usuário autenticado (substitua vm2 por seu ViewModel correto se necessário)
                guard let authUser2 = try? vm2.loadAuthUser() else {
                    loggedCase = .none
                    print("Falha ao carregar informações do usuário do ViewModel.")
                    return
                }
                
                // Atualiza o estado loggedCase com base no status de anonimato do usuário
                if authUser2.isAnonymous {
                    loggedCase = .anonymous
                } else {
                    loggedCase = .registered
                }

                // Adicione aqui mais lógica de pós-login, se necessário
                print("Login bem-sucedido e estado do usuário atualizado para \(loggedCase).")
            } catch {
                print("Erro ao processar o login bem-sucedido: \(error)")
                loggedCase = .none
            }
        }
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
    AuthenticationView(loggedCase: .constant(.none), isShowing: .constant(true), arbiuPrimeiraVez: .constant(true), didStartSignUpFlow: .constant(false), willLoad: .constant(false))
}



