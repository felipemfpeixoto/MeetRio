//
//  PersonWhoGoes.swift
//  MeetRio
//
//  Created by Luiz Seibel on 26/08/24.
//

import Foundation
import SwiftUI

struct PersonWhoGoes: View {
    let screenWidth = UIScreen.main.bounds.width
    let hospede: Hospede
    
    var body: some View{
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(.gray)
                    .opacity(0.3)
                    .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                
                if let pictureData = hospede.picture, let uiImage = UIImage(data: pictureData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth * 0.1, height: screenWidth * 0.1)
                }
            }
            .padding(.horizontal)
        
            
            Text("\(hospede.name)")
            
            Text("\(hospede.country.name) \(hospede.country.flag)")
                .font(.footnote)
                .fontWeight(.light)
        }
    }
}

#Preview {
    PersonWhoGoes(hospede: Hospede(name: "Felipe", country: CountryDetails(name: "Brazil", flag: "")))
}
