//
//  StorageManager.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/28/22.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirestorageError: Error{
    case invalidImageID
}


final class StorageManager {
    
    static let shared = StorageManager();
    
    let storage = Storage.storage()
    
    // MARK: - Download URL
    func getDownloadURL (for id: String?) -> AnyPublisher<URL, Error>{
        guard let id = id else{
            return Fail(error: FirestorageError.invalidImageID).eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    
    // MARK: - Upload Profile Photo to Firebase
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        
        return storage
                    .reference()
                    .child("images/\(randomID).jpg")
                    .putData(image, metadata: metaData)
                    .print()
                    .eraseToAnyPublisher()
    }
    
    
}
