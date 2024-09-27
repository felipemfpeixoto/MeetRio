//
//  AddedToFavoriteCard.swift
//  MeetRio
//
//  Created by Felipe on 14/08/24.
//

import SwiftUI

struct AddedToFavoriteCard: View {
    
    let eventImage: Data
    
    @Binding var selectedScreen: SelectedScreen
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.black)
            HStack {
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.white)
                    Image(uiImage: UIImage(data: eventImage)!)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 63, height: 45)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
                
                Spacer()
                
                Text("Action performed")
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
                
                Spacer()
                
                Button(action: {
                    // navegar para a tela de favorite events
                    selectedScreen = .yourEvents
                }, label: {
                    Text("View")
                        .foregroundStyle(.white)
                        .font(.system(size: 15).weight(.semibold))
                })
                
            }.padding(.horizontal)
        }
        .frame(height: 56)
    }
}

#Preview {
    AddedToFavoriteCard(eventImage: Data(), selectedScreen: .constant(.calendar))
}
