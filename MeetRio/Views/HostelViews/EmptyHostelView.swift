//
//  EmptyHostelView.swift
//  MeetRio
//
//  Created by Felipe on 21/11/24.
//

import SwiftUI

struct EmptyHostelView: View {
    
    @State var isShowingAddHostel: Bool = false
    
    var body: some View {
        ZStack {
            Image("MuseuDoAmanha")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                
            
            VStack(spacing: 120) {
                contentTexts
                enterButton
            }
            .padding()
            .sheet(isPresented: $isShowingAddHostel) {
                AddHostelView()
                    .presentationDetents([.fraction(0.8)])
            }
            
        }
        
        
    }
    
    var contentTexts: some View{
        VStack(spacing: 20){
            Text("Ops...")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("You are not logged yet\nat your hostel")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            Text("Enter to see tips and the\nbest recomendations")
                .font(.title3)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.white)
    }
    
    var enterButton: some View{
        Button {
            // Mostra a sheet para que ele possa escanear o qrcode do hostel
            isShowingAddHostel.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.novoGray)
                Text("Enter")
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .medium))
            }
        }.frame(width: UIScreen.main.bounds.width * 0.8 ,height: 45)
    }
}

#Preview {
    EmptyHostelView()
}
