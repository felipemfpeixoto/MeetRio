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
            AddHostelView()
        }
    }
}

#Preview {
    EmptyHostelView()
}
