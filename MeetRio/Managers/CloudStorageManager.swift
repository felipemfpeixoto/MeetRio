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
