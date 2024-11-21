//
//  HostelPopulatedView.swift
//  MeetRio
//
//  Created by Felipe on 21/11/24.
//

import SwiftUI

struct HostelPopulatedView: View {
    
    let hostel = UserManager.shared.hostel
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Image("imgFundoTop")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: 280)
                    .clipped()
                    .ignoresSafeArea()
                Spacer()
            }
            VStack(spacing: 24) {
                VStack {
                    headerContainer
                    CustomSearchBar(searchText: $searchText, filterButton: .constant(false), showFilter: false)
                }
                .padding()
                descriptionContainer
                    .padding()
                servicesContainer
                    .padding(.leading) // MARK: Esses paddings estão uma merda, ajeitar dps
                Spacer()
            }
        }
    }
    
    var headerContainer: some View {
        VStack {
            Circle()
                .frame(width: 115, height: 115)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 4, y: 4)
            Text(hostel!.name)
                .font(Font.custom("Bircolage Grotesque", size: 26))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text("\(hostel?.addressDetails.street ?? ""), \(hostel?.addressDetails.number ?? "") ")
                .foregroundStyle(.white)
                
        }
    }
    
    var descriptionContainer: some View {
        ZStack {
            if let description = hostel?.description {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.cinzaClarin)
                    Text(description)
                        .font(.system(size: 15))
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 75)
                .padding(.horizontal)
            }
        }
    }
    
    var servicesContainer: some View {
        ZStack {
            if let services = hostel?.services, services.count > 0 {
                VStack(alignment: .leading) {
                    Text("Services")
                        .font(Font.custom("Bricolage Grotesque", size: 20))
                        .fontWeight(.bold)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(services, id:\.self) { service in
                                ZStack { // MARK: Precisamos ainda descobrir como fazer o stroke (como no design), sem ficar escroto
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.darkGreen, lineWidth: 2)
                                        )
                                    Text(service)
                                        .foregroundStyle(.darkGreen)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 127, height: 64)
                                .padding(4)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    UserManager.shared.hostel = Hostel(name: "Hostel Name", description: "O hostel mais descolado e maneiro da cidade do Rio de Janeiro!", contact: ContactDetails(), addressDetails: AddressDetails(street: "R. Cupertino Durão", number: "56", neighborhood: "Leblon", location: LocationDetails(latitude: 0, longitude: 0), details: ""), services: ["Wifi Gratuito", "Café da manhã gratuito", "Área de jogos", "Acesso a internet"])
    
    return HostelPopulatedView()
}
