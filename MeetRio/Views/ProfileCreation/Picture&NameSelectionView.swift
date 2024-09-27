//
//  Picture&NameSelectionView.swift
//  MeetRio
//
//  Created by Felipe on 21/08/24.
//

import SwiftUI

struct Picture_NameSelectionView: View {
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    @State var hospede = Hospede(name: "", country: CountryDetails(name: "", flag: ""), picture: nil)
    
    @Binding var isShowingFullScreenCover: Bool
    @Binding var arbiuPrimeiraVez: Bool
    
    @Binding var loggedCase: LoginCase
    
    @Binding var didStartSignUpFlow: Bool
    
    @Binding var willLoad: Bool
    
    let userID: String
    
    var body: some View {
        ZStack {
            backgroundContainer
            VStack {
                HStack {
                    titleContainer
                    Spacer()
                }
                Spacer()
            }.padding(.top, 64)
            VStack {
                Spacer()
                imagePickerButton
                textFieldContainer
                continueButtonContainer
                Spacer()
            }.padding()
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
        }
        .onDisappear {
            if let selectedImage {
                hospede.picture = selectedImage.pngData()
            }
        }
    }
    
    var titleContainer: some View {
        VStack(alignment: .leading) {
            Text("Complete Profile")
                .font(Font.custom("Bricolage Grotesque", size: 26))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.bottom)
            Text("By creating a profile, you can find")
                .font(.system(size: 15))
                .foregroundStyle(.white)
            Text("other guests who will attend to")
                .font(.system(size: 15))
                .foregroundStyle(.white)
            Text("the same event as you.")
                .font(.system(size: 15))
                .foregroundStyle(.white)
        }.padding(.horizontal)
    }
    
    var backgroundContainer: some View {
        ZStack {
            Image("seaBackground")
                .resizable()
            Rectangle()
                .foregroundStyle(.black)
                .opacity(0.30)
        }
        .ignoresSafeArea()
    }
    
    var textFieldContainer: some View {
        TextField("Add your name", text: $hospede.name)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
    }
    
    var imagePickerButton: some View {
            Button {
                isImagePickerPresented.toggle()
            } label: {
                if selectedImage == nil {
                    ZStack {
                        Circle()
                            .foregroundColor(.oceanBlue)
                            .shadow(color: .black.opacity(0.25), radius: 2, y: 4)
                        Image(systemName: "camera")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 60, height: 26)
                                    .foregroundStyle(.white)
                                Text("Add")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                } else {
                    ZStack {
                        Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFit()
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.5), radius: 2.5, y: 4)
                    }
                }
            }
            .padding()
            .frame(width: 180, height: 180)
        }
    
    var continueButtonContainer: some View {
        NavigationLink(destination: SelectCountryView(hospede: $hospede, isShowingFullScreenCover: $isShowingFullScreenCover, arbiuPrimeiraVez: $arbiuPrimeiraVez, loggedCase: $loggedCase, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad, userID: userID)) {
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundStyle(.marcaTexto)
                Text("Continue")
                    .foregroundStyle(.black)
            }
        }.frame(height: 55)
    }
}

//#Preview {
//    Picture_NameSelectionView(isShowingFullScreenCover: .constant(true), arbiuPrimeiraVez: .constant(true), loggedCase: .constant(.none), userID: "")
//}
