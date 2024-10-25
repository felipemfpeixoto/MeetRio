//
//  LateralCard.swift
//  MeetRio
//
//  Created by Luiz Seibel on 26/08/24.
//

import Foundation
import SwiftUI

struct LateralCard: View {
    
    var event: EventDetails
    
    @State var showingAlert = false
    @Binding var needAtt: Bool
    
    var body: some View {
        HStack(spacing: 0.0){
            Image(uiImage: (event.photoData != nil ? UIImage(data: event.photoData!) : UIImage(systemName: "caipiImage"))!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 128, height: 125)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Text(event.address.street)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()

                
            }
            .padding(.leading)
            .padding(.top)
            

            Spacer()
            
            VStack{
                Button(action: {
                    showingAlert.toggle()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
            .padding(.top)
            .padding(.trailing)


        }
        .background{
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor(.white)
                .shadow(radius: 5, y: 5)
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Are you sure you want to delete this favorite place?"),
                primaryButton: .destructive(Text("Yes"), action: {
                    // Ação a ser executada quando o usuário confirma a exclusão
                    Task{
                        await FirestoreManager.shared.deleteGoingEvent((UserManager.shared.hospede?.id!)!, event.id!)
                    }
                    
                    // Quero atualizar a view forcadamente
                    needAtt.toggle()
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
//        .onAppear {
//            print("event.pgoto: \(event.photo)")
//        }
        
        
        
    }
}
