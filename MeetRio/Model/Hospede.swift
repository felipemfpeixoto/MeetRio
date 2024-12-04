//
//  UserModels.swift
//  MeetRio
//
//  Created by Felipe on 11/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

struct Hospede: Codable {
    @DocumentID var id: String?
    var name: String
    var country: CountryDetails
    var imageURL: String = ""
    var hostel: String?
}
