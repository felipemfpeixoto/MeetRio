//
//  LateralCard.swift
//  MeetRio
//
//  Created by Luiz Seibel on 26/08/24.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct LateralCard: View {
    
    var event: EventDetails
    
    @Binding var needAtt: Bool
    
    
    @State var showingAlert: Bool = false
    
    var body: some View {
        HStack(spacing: 0.0){
            CachedAsyncImage(url: URL(string: event.photoURL!), transaction: Transaction(animation: .easeInOut.speed(1.5))) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 128, height: 125)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                case .failure(_):
                    Image("defaultImageCard")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 128, height: 125)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                default:
                    ZStack {
                        Image("defaultImageCard")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 128, height: 125)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Color.black.opacity(0.5)
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.3)
                            .padding(.bottom)
                    }
                }
            }
            
            
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
                    
                    YourEventsModel.shared.removeEvent(event)
                    Task{
                        await FirestoreManager.shared.deleteGoingEvent((UserManager.shared.hospede?.id!)!, event.id!)
                    }
                    
                    ToastVariables.shared.isOnRemove = true
                    
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        
    }
}
