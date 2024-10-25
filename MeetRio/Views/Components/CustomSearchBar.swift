//
//  CustomSearchBar.swift
//  MeetRio
//
//  Created by Luiz Seibel on 20/08/24.
//

import Foundation
import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    @Binding var filterButton: Bool
    
    var showFilter = true

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchText)
                    .foregroundColor(.black)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(15)
            if showFilter {
                Button(action: {
                    filterButton.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .padding(10)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .clipShape(Circle())
                }
            }
        }
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}


#Preview("SearchBar Filter") {
    CustomSearchBar(searchText: .constant(""), filterButton: .constant(false))
}

#Preview("SearchBar") {
    CustomSearchBar(searchText: .constant(""), filterButton: .constant(false), showFilter: false)
}
