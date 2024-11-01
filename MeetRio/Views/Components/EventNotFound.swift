//
//  EventNotFound.swift
//  MeetRio
//
//  Created by Luiz Seibel on 01/11/24.
//

import SwiftUI

struct EventNotFound: View {
    
    var body: some View{
        VStack{
            Image("plasticChair")
            Text("Ops...")
                .font(.title2)
                .bold()
            Text("Event not found :(")
                .padding(.bottom, 60)
        }
    }
}

#Preview {
    EventNotFound()
}
