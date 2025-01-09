//
//  UserProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol UserProtocol: Codable, CRUDItem, AuthProtocol {
    
    var name: String { get set }
    var email: String { get set }
    var imageURL: String? { get set }
    
    static func getUserHospede() async throws -> Self
    mutating func deleteUser() async throws
    
    init(user: User)
}

extension UserProtocol {
    
    init(isAnonymous: Bool = false) async throws {
        if !isAnonymous {
            self = try await Self.getUserHospede()
        } else {
            let anonymousUser = try await Self.signInAnonymous()
            self = Hospede(user: anonymousUser) as! Self // TODO: Atualmente estamos instânciando diretamente como Hospede, mas futuramente o user poderá ser um Hostel ou Admin
        }
    }
    
    init(email: String, password: String, isNewUser: Bool = false) async throws {
        if !isNewUser {
            let signInUser = try await Self.signIn(email: email, password: password)
            let id = signInUser.uid
            self = try await Self.getItem(for: id)
        } else {
            let newUser = try await Self.createAccount(email: email, password: password)

            self = Self.init(user: newUser) // MARK: Self.init pois não estamos instânciando apenas Hospedes, mas também Hostels
        }
    }
}

extension UserProtocol {
    
    static func getUserHospede() async throws -> Self {
        let user = try self.getAuthenticatedUser()
        if user.isAnonymous {
            Self.loggedCase = .anonymous
            return Self.init(user: user)
        }
        Self.loggedCase = .registered
        return try await self.getItem(for: user.uid)
    }
    
    mutating func deleteUser() async throws { // TODO: Precisamos ter um método dentro do fornecedor que, após a exclusão ter sido completada, seta o valor de User para nil
        try await GoingEvent.deleteAllGoing(for: self.id)
        try await self.deleteItem()
        try await self.deleteAccount()
        try await Self.signOut()
    }
    
    mutating func saveImage(image: UIImage) async throws {
        
        let storage = Storage.storage()
        
        let photoName = UUID().uuidString
        let storageRef = storage.reference().child("profilePics/\(self.id)/profile.jpg") // A imagem será armazenada na pasta \(userID)/profile.jpg
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else { // Comprimindo a imagem para armazená-la no Cloud Storage
            print("Falhou ao ajustar o tamanho da imagem")
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg" // Setting metadata allows you to see console image in the web browser
        
        let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
        
        let imageURL = try await storageRef.downloadURL()
        self.imageURL = imageURL.absoluteString
        
        try await self.updateItem()
    }
    
}
