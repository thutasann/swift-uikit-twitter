//
//  AuthManage.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/19/22.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

class AuthManager{
    
    static let shared = AuthManager();
    
    
    // Register User
    func registerUser(with email: String, password: String) -> AnyPublisher<User, Error>{
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    // Login User
    func loginUser(with email: String, password: String) -> AnyPublisher<User, Error>{
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
}
