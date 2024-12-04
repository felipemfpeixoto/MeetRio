//
//  UserManager.swift
//  MeetRio
//
//  Created by Felipe on 20/08/24.
//

import Foundation
import FirebaseFirestore

// Classe responsável por guardar todas as infos do usuário e seu hostel
@Observable
final class UserManagerLIXO {
    static let shared = UserManager()
    private init() {}
    
    var hospede: Hospede?
    var hostel: Hostel?
    
    func createNewUser(userID: String, hospede: Hospede) async throws {
        do {
            try FirestoreManager.shared.db.collection("Hospedes").document(userID).setData(from: hospede)
            self.hospede = hospede
            self.hospede?.id = userID
            print("Perfil de hóspede com id \(userID) criado com sucesso")
        } catch {
            print("Deu merda ao criar o oerfil de hospede: ", error)
        }
    }
    
    func getUser(userID: String) async throws {
        do {
            let hospede = try await FirestoreManager.shared.db.collection("Hospedes").document(userID).getDocument(as: Hospede.self)
            self.hospede = hospede
            
            let hostelCE = try HostelCodableExtensions.load()
            self.hostel = Hostel(hostelCE: hostelCE)
        } catch {
            print("Perfil de hospede com id \(userID) não encontrado: ", error)
        }
        return
    }
    
    func updateHostel() async throws {
        if hostel != nil {
            do {
                self.hostel = try await FirestoreManager.shared.db.collection("Hostels").document(String(self.hostel!.id!)).getDocument(as: Hostel.self)
                await self.hostel!.getAllEvents()
            } catch {
                print("Erro ao atualizar hostel: \(error.localizedDescription)")
            }
        } else {
            print("Hostel Vazio em UserManager")
        }
    }
}
