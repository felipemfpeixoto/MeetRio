//
//  CloudStorageManager.swift
//  MeetRio
//
//  Created by Felipe on 13/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
//import FirebaseError

final class UploadViewModeManager {
    
    let storage = Storage.storage()
    
    func saveImage(userID: String, image: UIImage) async throws -> String {
        let photoName = UUID().uuidString
        let storageRef = storage.reference().child("profilePics/\(userID)/profile.jpg") // A imagem será armazenada na pasta \(userID)/profile.jpg
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else { // Comprimindo a imagem para armazená-la no Cloud Storage
//            throw FirebaseError.invalidImageData
            print("Falhou ao ajustar o tamanho da imagem")
            return ""
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg" // Setting metadata allows you to see console image in the web browser
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            print("✅ Imagem salva com sucesso!")
            do {
                let imageURL = try await storageRef.downloadURL()
                return imageURL.absoluteString
            } catch {
                print("🤬 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                return ""
            }
        } catch {
            print("🤬 ERROR: uploading image to FirebaseStorage")
            return ""
        }
    }
    
    func deleteImage(userID: String) async throws {
        let storageRef = storage.reference().child("profilePics/\(userID)/profile.jpg")
        do {
            try await storageRef.delete()
            print("✅ Imagem deletada com sucesso!")
        } catch {
            print("🤬 ERROR: deleting image from FirebaseStorage")
        }
    }
}
