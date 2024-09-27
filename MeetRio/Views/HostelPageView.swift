//
//  HostelPageView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 14/08/24.
//

import Foundation
import SwiftUI

struct HostelPageView: View{
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Hostel Informations
    let name: String = "Hostel Leblon"
    let address: String = "R. Cupertino Durão, 56 - Leblon, Rio de Janeiro "
    let description: String = "O hostel mais descolado e maneiro da cidade do Rio de Janeiro!"
    
    // Used for the CustomSegmentedControl
    @State private var selectedSegment = 0
    
    var body: some View{
        ScrollView{
            VStack(spacing: 5){
                ZStack{
                    header
                        .padding(.bottom)
                }
                Icon
                Information
                Footnote
                CustomSegmentedControl(preselectedIndex: $selectedSegment, options: ["Hostel's events", "Indications"])
                
                if selectedSegment == 0 {
                    HostelEvents
                } else {
                    HostelIndications
                }
                
            }
       }.ignoresSafeArea()
    }
    
    
    var header: some View{
        VStack{
            Rectangle()
                .foregroundStyle(Color.black)
                .frame(width: screenWidth, height: screenHeight / 7)
                .overlay{
                    HStack {

                        Text("Your ")
                            .font(.title)
                            .fontWeight(.bold)
                            
                        +
                        Text("hostel")
                            .font(.title.italic())
                            .fontWeight(.light)
  
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 35)
                    .padding(.top, 50)
                        
                }
            Spacer()
        }
    }
    
    var Icon: some View{
        Circle()
            .overlay(
                Image("defaultHostel")
                    .resizable()
                    .scaledToFit()
                    .offset(x: 8.0)
                    .padding(10)
            )
            .foregroundStyle(Color(uiColor: UIColor(red: 231/255, green: 228/255, blue: 111/255, alpha: 1)))
            .frame(width: screenWidth/3)
    }
    
    var Information: some View{
        VStack(spacing: 5){
            Text("\(name)")
                .font(.title)
            
            Text("\(address)")
                .fontWeight(.light)
                .frame(width: screenWidth * 0.65)
                .multilineTextAlignment(.center)
        }
    }
    
    var Footnote: some View{
        RoundedRectangle(cornerRadius: 20.0)
            .frame(width: screenWidth * 0.85, height: screenWidth * 0.20)
            .overlay{
                Text("\(description)")
                    .font(.subheadline)
                    .foregroundStyle(Color.white)
                    .frame(width: screenWidth * 0.65)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
    }
    
    // TODO: Adicionar os conteúdos
    var HostelEvents: some View{
        VStack{
            Text("Aqui vão os eventos do Hostel")
        }
    }
    
    // TODO: Adicionar os conteúdos
    var HostelIndications: some View{
        VStack{
            Text("Aqui vão as indicações")
        }
    }

}

struct CustomSegmentedControl: View {
    let screenHeight = UIScreen.main.bounds.height
    
    @Namespace private var animation
    @Binding var preselectedIndex: Int
    var options: [String]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                ZStack {
                    Rectangle()
                        .fill(Color.clear)

                    VStack {
                        Text(options[index])
                            .fontWeight(.light)
                            .foregroundStyle(preselectedIndex == index ? Color.black : Color.gray)
                        
                        
                        if preselectedIndex == index {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.black)
                                .matchedGeometryEffect(id: "underline", in: animation, properties: .frame) // Animação da barra
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        preselectedIndex = index
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: screenHeight / 10)
        .cornerRadius(20)
    }
}

#Preview{
    HostelPageView()
}

