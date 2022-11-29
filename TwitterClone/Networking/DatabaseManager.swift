//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/20/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager{
    
    static let shared = DatabaseManager();
    
    let db = Firestore.firestore()
    let userPath: String = "users"
    
    
    // Add to Users Collection
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error>{
        let twitterUser = TwitterUser(from: user)
        return db.collection(userPath).document(twitterUser.id).setData(from: twitterUser)
            .map{ _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    // Retrieve User Collection
    func collectionUsers(retrieve id: String) -> AnyPublisher<TwitterUser, Error>{
        db.collection(userPath).document(id).getDocument()
            .tryMap { try $0.data(as: TwitterUser.self)}
            .eraseToAnyPublisher()
    }
    
    // Update User Fields
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error>{
        db.collection(userPath).document(id).updateData(updateFields)
            .map { _ in true}
            .eraseToAnyPublisher()
    }
}
