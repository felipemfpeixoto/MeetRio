//
//  TesteView.swift
//  MeetRio
//
//  Created by Felipe on 25/09/24.
//

import SwiftUI
import Translation

struct TesteView: View {
    
    let teste = Teste()
    
    var body: some View {
        ZStack {
            Button {
                Task {
                    // manda pro fb
                    try FirestoreManager.shared.db.collection("Teste").addDocument(from: teste)
                }
            } label: {
                Text("Manda")
            }

        }
    }
}

@Observable
class Teste: Codable {
    var name = "Felipe"
    var lastName = "Peixoto"
}

#Preview {
        TesteView()
}
