//
//  Picture&NameSelectionView.swift
//  MeetRio
//
//  Created by Felipe on 21/08/24.
//

import SwiftUI

struct PictureNameSelectionView: View {
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    @Binding var isShowingFullScreenCover: Bool
    @Binding var arbiuPrimeiraVez: Bool
    
    @Binding var didStartSignUpFlow: Bool
    
    @Binding var willLoad: Bool
    @State var willNavigate: Bool = false
    
    @State var name: String = ""
    
    var body: some View {
        ZStack {
            backgroundContainer
            VStack(spacing: 32) {
                Spacer()
                HStack {
                    titleContainer
                    Spacer()
                }
                imagePickerButton
                VStack(spacing: 16) {
                    textFieldContainer
                    continueButtonContainer
                }
                Spacer()
                Spacer()
            }.padding()
            .tint(.blue)
        }
        .navigationDestination(isPresented: $willNavigate) {
            SelectCountryView(isShowingFullScreenCover: $isShowingFullScreenCover, arbiuPrimeiraVez: $arbiuPrimeiraVez, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad, selectedImage: selectedImage)
        }
        .onDisappear { // MARK: Responsável por atualizar o name do user, a imagem será atualizada na próxima view, pois temos que gerar a url da mesma
            Fornecedor.shared.userVariable!.name = name
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    var titleContainer: some View {
        VStack(alignment: .leading) {
            Text("Complete Profile")
                .font(Font.custom("Bricolage Grotesque", size: 32))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.bottom)
            Text("By creating a profile, you can find")
                .font(.system(size: 17))
                .foregroundStyle(.white)
            Text("other guests who will attend to")
                .font(.system(size: 17))
                .foregroundStyle(.white)
            Text("the same event as you.")
                .font(.system(size: 17))
                .foregroundStyle(.white)
        }.padding(.horizontal)
    }
    
    var backgroundContainer: some View {
        ZStack {
            Image("MuseuDoAmanha")
                .resizable()
        }
        .ignoresSafeArea()
    }
    
    var textFieldContainer: some View {
        TextField("Add your name", text: $name)
            .textFieldStyle()
    }
    
    var imagePickerButton: some View {
            Button {
                isImagePickerPresented.toggle()
            } label: {
                if selectedImage == nil {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.75), radius: 4, y: 4)
                        Image(systemName: "plus")
                            .font(.system(size: 50).weight(.semibold))
                            .foregroundStyle(.black)
                        VStack {
                            Spacer()
                            Text("Add")
                                .font(.system(size: 26))
                                .fontWeight(.light)
                                .foregroundStyle(.black)
                        }.padding(32)
                    }
                } else {
                    ZStack {
                        Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.75), radius: 4, y: 4)
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.white).foregroundStyle(.white)
                                    .frame(width: 80, height: 30)
                                Text("Edit")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 17).weight(.semibold))
                            }
                        }
                    }
                    .frame(width: 204, height: 204)
                }
            }
            .padding()
            .frame(width: 204, height: 204)
        }
    
    var continueButtonContainer: some View {
        Button(action: {
            willNavigate.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(name == "" ? .white : .black)
                Text("Continue")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
        })
        .frame(height: 44)
        .disabled(name == "")
        .opacity(name == "" ? 0.5 : 1)
    }
}

#Preview {
    PictureNameSelectionView(isShowingFullScreenCover: .constant(true), arbiuPrimeiraVez: .constant(true), didStartSignUpFlow: .constant(true), willLoad: .constant(false))
}
