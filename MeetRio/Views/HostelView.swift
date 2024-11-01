//
//  HostelView.swift
//  MeetRio
//
//  Created by Felipe on 01/11/24.
//

import SwiftUI

struct HostelView: View {
    
    @Environment(UserHostel.self) var userHostel
    
    @State var isShowingAddHostel: Bool = false
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        if userHostel.id != nil {
            hostel
        } else {
            emptyHostel
        }
    }
    
    var hostel: some View {
        VStack {
            ZStack {
                Image("imgFundoTop")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight / 5)
                    .clipped()
            }
            Spacer()
        }.ignoresSafeArea()
    }
    
    var emptyHostel: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Looks like you don't have a hostel yet.")
                Text("Click on the button below to add one.")
            }
            Button {
                // Mostra a sheet para que ele possa escanear o qrcode do hostel
                isShowingAddHostel.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.darkGreen)
                    Text("Add Hostel")
                        .foregroundStyle(.white)
                        .font(.system(size: 24, weight: .medium))
                }
            }.frame(width: 150,height: 55)

        }.padding()
        .sheet(isPresented: $isShowingAddHostel) {
            Text("Mengo")
        }
    }
}

#Preview("Hostel Vazio") {
    HostelView()
        .environment(UserHostel())
}

#Preview("Hostel Adicionado") {
    HostelView()
        .environment(
            UserHostel(id: UUID().uuidString, name: "Mengo Hostel", description: "O hostel mais descolado e maneiro da cidade do Rio de Janeiro!", email: "mengo@mengo.com", services: ["Wifi Gratuito", "Café da manhã"], location: LocationDetails(latitude: -22.97731931869979, longitude: -43.21826065180895))
        )
}
