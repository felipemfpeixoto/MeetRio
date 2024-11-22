//
//  HostelPopulatedView.swift
//  MeetRio
//
//  Created by Felipe on 21/11/24.
//

import SwiftUI
import CachedAsyncImage

struct HostelPopulatedView: View {
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
                ScrollView {
                    descriptionContainer
                        .padding()
                    VStack {
                        servicesContainer
                        eventsContainer
                    }
                    .padding(.leading) // MARK: Esses paddings estão uma merda, ajeitar dps
                    Spacer()
                }
                .refreshable {
                    Task {
                        try await UserManager.shared.updateHostel()
                    }
                }
            }
        }
    }
    
    var headerContainer: some View {
        VStack {
            CachedAsyncImage(url: URL(string: UserManager.shared.hostel!.imageURL!), transaction: Transaction(animation: .easeInOut.speed(1.5))) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                case .failure(_):
                    Image("defaultImageCard")
                        .resizable()
                default:
                    ZStack {
                        Image("defaultImageCard")
                            .resizable()
                        Color.black.opacity(0.5)
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.3)
                    }
                }
            }
            .scaledToFill()
            .frame(width: 115, height: 115)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.5), radius: 4, y: 4)
            
            Text(UserManager.shared.hostel!.name)
                .font(Font.custom("Bircolage Grotesque", size: 26))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text("\(UserManager.shared.hostel?.addressDetails.street ?? ""), \(UserManager.shared.hostel?.addressDetails.number ?? "") ")
                .foregroundStyle(.white)
                
        }
    }
    
    var descriptionContainer: some View {
        ZStack {
            if let description = UserManager.shared.hostel?.description {
                ZStack {
                    Text(description)
                        .font(.system(size: 15))
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.cinzaClarin)
                        }
                }
                .padding(.horizontal)
            }
        }
    }
    
    var servicesContainer: some View {
        ZStack {
            if let services = UserManager.shared.hostel?.services, services.count > 0 {
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
    
    var eventsContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hostel Events")
                .font(Font.custom("Bricolage Grotesque", size: 20))
                .fontWeight(.bold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(UserManager.shared.hostel!.events, id:\.self.id) { event in
                        NewEventCard(selectedFavorite: .constant(nil), loggedCase: .constant(.anonymous), clicouGoing: .constant(false), event: event)
                    }
                }
            }
        }
    }
}

#Preview {
    UserManager.shared.hostel = Hostel(
        name: "Social Hostel",
        description: "O hostel mais descolado e maneiro da cidade do Rio de Janeiro!",
        contact: ContactDetails(),
        addressDetails: AddressDetails(
            street: "R. Cupertino Durão",
            number: "56", neighborhood: "Leblon",
            location: LocationDetails(latitude: 0, longitude: 0), details: ""),
        services: ["Wifi Gratuito", "Café da manhã gratuito", "Área de jogos", "Acesso a internet"],
        imageURL: "https://storage.googleapis.com/meetrio.appspot.com/HotelPics/bvKiWCn1HsejIPr3jCy9/SocialHostel.jpg"
    )
    
    return HostelPopulatedView()
}
