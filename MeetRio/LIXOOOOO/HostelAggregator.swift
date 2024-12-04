//
//  File.swift
//  MeetRio
//
//  Created by Felipe on 22/11/24.
//

import Foundation

@Observable
class HostelAggregatorLIXO: Codable {
    var allHostels: [Hostel] = []
    
    init() {
        Task {
            do {
                // Obtém os documentos da coleção "Hostels" no Firestore
                let snapshot = try await FirestoreManager.shared.db.collection("Hostels").getDocuments()
                // Mapeia os documentos para o modelo Hostel
                self.allHostels = snapshot.documents.compactMap { document in
                    try? document.data(as: Hostel.self) // Assume que Hostel conforma com Decodable e FirestoreDecoder
                }
            } catch {
                print("Erro ao carregar hostels: \(error)")
                self.allHostels = [] // Retorna um array vazio em caso de erro
            }
        }
    }
}
