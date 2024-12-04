//
//  Arrays.swift
//  MeetRio
//
//  Created by Luiz Seibel on 03/12/24.
//

import Foundation

enum ArraysError: Error {
    case invalidItemType(expected: String, received: String)
    case itemNotFound
    case unknownError(description: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidItemType(let expected, let received):
            return "Tipo inválido. Esperado: \(expected), recebido: \(received)."
        case .itemNotFound:
            return "Item não encontrado no array."
        case .unknownError(let description):
            return "Erro desconhecido: \(description)"
        }
    }
}
