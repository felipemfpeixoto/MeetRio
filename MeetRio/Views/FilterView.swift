//
//  FilterView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 20/08/24.
//

import Foundation
import SwiftUI

struct FilterView: View {
       
    let nationalities = ["Brazilian", "American", "Canadian", "French", "Japanese"]

    let categories = ["Music", "Sports", "Technology", "Art", "Food"]
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var selectedCategory = "Music"
    @State private var proximity = 10.0
    @State private var selectedNationality = "Brazilian"
    
    @Binding var safetyRating: Int

    var body: some View {
        
            ZStack{
                Color("novoGray")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20){
                    
                    header
                        .padding(.top)
                    
                    category
                    
                    proximititi
                    
                    safety
                    
                    nationality
                    
                    footer
                    
                    Spacer()
                }
            }
            

    }
    
    var header: some View{
        HStack{
            Text("Filter")
                .font(.title3)
                .foregroundStyle(Color.white)
            Spacer()
            
            Button(action: {
                safetyRating = 0
            }, label: {
                Text("Clear filters")
                    .font(.callout)
                    .foregroundStyle(Color("marcaTexto"))
                    
            })
        }
        .padding()
        .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
    }
    
    var category: some View{
        HStack {
            Text("Category")
                .foregroundStyle(Color.white)
            Spacer()
            Picker("Select Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) {
                    Text($0)
                }
            }
            .accentColor(Color("marcaTexto"))
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
        .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
        .background(Color("novoGray2"))
        .cornerRadius(20)
    }
    
    var proximititi: some View{
        VStack(alignment: .leading) {
            Text("Proximity")
                .foregroundStyle(Color.white)
            
            Slider(value: $proximity, in: 0...20, step: 1)
                .accentColor(Color("marcaTexto"))
               
            HStack {
                Text("0")
                Spacer()
                Text("20")
            } .foregroundStyle(Color.white)
        }
        .padding()
        .frame(width: screenWidth * 0.9, height: screenHeight * 0.15)
        .background(Color("novoGray2"))
        .cornerRadius(20)
    }
    
    var safety: some View{
        HStack{
            VStack(alignment: .leading) {
                Text("Safety")
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 8)
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= safetyRating ? "star.fill" : "star")
                            .foregroundColor(index <= safetyRating ? Color("marcaTexto") : .gray)
                            .onTapGesture {
                                safetyRating = index
                            }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(width: screenWidth * 0.9, height: screenHeight * 0.08)
        .background(Color("novoGray2"))
        .cornerRadius(20)
    }
    
    var nationality: some View{
        HStack {
            Text("People's nationality")
                .foregroundStyle(Color.white)
            Spacer()
            Picker("Select Nationality", selection: $selectedNationality) {
                ForEach(nationalities, id: \.self) {
                    Text($0)
                }
            }
            .accentColor(Color("marcaTexto"))
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
        .frame(width: screenWidth * 0.9, height: screenHeight * 0.08)
        
        .background(Color("novoGray2"))
        .cornerRadius(20)
        
    }
    
    var footer: some View{
        HStack{
            Image(systemName: "info.circle")
                .offset(y: -10)
            
            Text("Find out which nationalities will attend the events you search for")
                
                .fontWeight(.light)
        }
        .foregroundStyle(Color.white)
        .padding()
    }
}



#Preview {
    FilterView(safetyRating: .constant(2))
}
