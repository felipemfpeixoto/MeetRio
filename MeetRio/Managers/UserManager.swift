//
//  UserManager.swift
//  MeetRio
//
//  Created by Felipe on 20/08/24.
//

import Foundation
import FirebaseFirestore

@Observable
final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    var hospede: Hospede?
    
    func createNewUser(userID: String, hospede: Hospede) async throws {
        do {
            try FirestoreManager.shared.db.collection("Hospedes").document(userID).setData(from: hospede)
            self.hospede = hospede
            self.hospede?.id = userID
            print("Deu tudo certo: \(self.hospede)")
        } catch {
            print("Deu merda ao criar o usuário: ", error)
        }
    }
    
    func getUser(userID: String) async throws {
        do {
            let hospede = try await FirestoreManager.shared.db.collection("Hospedes").document(userID).getDocument(as: Hospede.self)
            self.hospede = hospede
        } catch {
            print("Usuário não encontrado: ", error)
        }
        return
    }
}
