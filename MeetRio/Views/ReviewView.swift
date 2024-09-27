//
//  ReviewView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 15/08/24.
//

import Foundation
import SwiftUI

struct ReviewView: View{
    
    @Environment(\.dismiss) var dismiss
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var userReview: String = ""
    @State var isTyping: Bool = false
    @State var starRate: Int = 0
    
    var body: some View {
        VStack(spacing: 20) { // Ajuste o espaçamento conforme necessário
            header
            
            Spacer()
            
            TitleStars
            
            Spacer()
            
            CustomTextField
            
            Spacer()
            
            ContinueButton
            
            Spacer()
        }
        .padding(.bottom, 120) // Adiciona um pouco de padding vertical para dar espaço adicional
        .ignoresSafeArea()
    }

    
    var header: some View{
        VStack{
            Rectangle()
                .foregroundStyle(Color.black)
                .frame(width: screenWidth, height: screenHeight / 7)
                .overlay{
                    HStack {
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.down")
                                .font(.title)
                                .padding(.leading, 20)
                                .padding(.trailing, 10)
                        })
                        
                        
                        Text("Add ")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        +
                        Text("review")
                            .font(.title.italic())
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                    
                    .padding(.top)
                    
                }
        }
    }
    
    var TitleStars: some View{
        VStack(spacing: 10){
            Text("How was\nyour experience?")
                .frame(width: screenWidth * 0.85, height: screenHeight * 0.1, alignment: .leading)
                .font(.title)
            
            HStack{
                ForEach(1...5, id: \.self){index in
                    Button(action: {
                        starRate = index
                    }, label: {
                        Image(systemName: starRate < index ? "star" : "star.fill")
                            .foregroundStyle(Color.black)
                    })
                    
                    
                }
                Spacer()
            }.padding(.horizontal, 30)
        }
    }
    
    var CustomTextField: some View{
        RoundedRectangle(cornerRadius: 20)
            .frame(width: screenWidth * 0.85, height: screenHeight * 0.25)
            .foregroundStyle(Color.white)
            .shadow(radius: 5, y: 5)
            .overlay{
                ZStack(alignment: .topLeading) {
                   
                    TextEditor(text: $userReview)
                        .frame(width: screenWidth * 0.75, height: screenHeight * 0.20, alignment: .topLeading)
                        .background(Color.red) // Fundo transparente para combinar com o TextField
                        .onTapGesture {
                            isTyping = true
                        }
                       
                    if !isTyping{
                        Text("Type something here")
                            .font(.title3)
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            
                           
                    }
                }
            }
    }
    
    var ContinueButton: some View{
        Button(action: {
            //TODO: Enviar review
        }, label: {
            RoundedRectangle(cornerRadius: 20.0)
                .frame(width: screenWidth * 0.85, height: screenHeight * 0.05)
                .foregroundStyle(Color("marcaTexto"))
                .shadow(radius: 5, y: 5)
                .overlay{
                    Text("Continue")
                        .foregroundStyle(Color.black)
                }
        })
    }
    
}

#Preview {
    ReviewView()
}
