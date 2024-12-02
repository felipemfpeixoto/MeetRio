//
//  AuthProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol AuthProtocol {
    func getAuthUser() async throws

    // Login methods
    func signIn() async throws
    func signOut() async throws
    func resetPassword() async throws
    
    // Account Manager
    func createAccount() async throws
    func deleteAccount() async throws
}
