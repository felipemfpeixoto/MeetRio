//
//  PersonWhoGoes.swift
//  MeetRio
//
//  Created by Luiz Seibel on 26/08/24.
//

import Foundation
import SwiftUI
import CachedAsyncImage

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
                
                CachedAsyncImage(url: URL(string: hospede.imageURL ?? "xxx"), transaction: Transaction(animation: .easeInOut.speed(1.5))) { phase in
                    switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                                .clipShape(Circle())
                        case .failure(_):
                            Image("defaultImageCard")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                                .clipShape(Circle())
                        default:
                            ZStack {
                                Image("defaultImageCard")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                                    .clipShape(Circle())
                                Color.black.opacity(0.5)
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(1.3)
                                    .padding(.bottom)
                            }
                    }
                }
            }
            .padding(.horizontal)
        
            
            Text("\(hospede.name)")
            
            Text("\(String(describing: hospede.country!.name)) \(String(describing: hospede.country!.flag))")
                .font(.footnote)
                .fontWeight(.light)
        }
    }
}

//#Preview {
//    PersonWhoGoes(hospede: Hospede(name: "Felipe", country: CountryDetails(name: "Brazil", flag: "")))
//}
