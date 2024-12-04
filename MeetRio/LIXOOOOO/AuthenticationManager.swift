//
//  AuthenticationManager.swift
//  MeetRio
//
//  Created by Felipe on 15/08/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModelLIXO {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User?) {
        self.uid = user?.uid ?? ""
        self.email = user?.email ?? ""
        self.photoUrl = user?.photoURL?.absoluteString
        self.isAnonymous = user?.isAnonymous ?? false
    }
}

@Observable
final class AuthenticationManagerLIXO {
    
    static let shared = AuthenticationManager()
    
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        UserManager.shared.hospede = nil
    }
    
    func delete(_ willDeleteAll: Bool = true) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        if willDeleteAll {
            await FirestoreManager.shared.removeGoingEvent(user.uid)
            await FirestoreManager.shared.deleteHospede(user.uid)
        }
        let csManager = UploadViewModeManager()
        try await csManager.deleteImage(userID: user.uid)
        
        try await user.delete()
    }
}

// MARK: SIGN IN EMAIL
extension AuthenticationManagerLIXO {
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel? {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print(authDataResult)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            print("Deu merda aqui: ", error)
        }
        return nil
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
}

// MARK: SIGN IN SSO
extension AuthenticationManagerLIXO {
    
    @discardableResult
    func sigInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    @discardableResult
    func sigInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

@Observable
final class SettingsViewModelLIXO {
    // Adicionar lógica para criar atributo email no settingsViewModel, sem precisar fazer aquilo tudo para pegar o email do usuário
    
    @MainActor
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func delete() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func loadAuthUser() -> AuthDataResultModel?{
        let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
        return authUser
    }
}

// MARK: SIGN IN ANONYMOUS

extension AuthenticationManagerLIXO{
    
    @discardableResult
    func signInAnonymous() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func linkEmail(email: String, password: String) async throws -> AuthDataResultModel{
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkCredential(credential: credential)
    }
    
    func linkGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkCredential(credential: credential)
    }
    
    func linkApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel{
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token, rawNonce: tokens.nonce)
        return try await linkCredential(credential: credential)
    }
    
    private func linkCredential(credential: AuthCredential) async throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badURL)
        }
        
        let authDataResult = try await user.link(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
