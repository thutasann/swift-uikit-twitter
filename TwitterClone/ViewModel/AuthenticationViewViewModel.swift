//
//  RegisterViewViewModel.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/18/22.
//

import Foundation
import UIKit
import Firebase
import Combine


final class AuthenticationViewViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    // subscription
    private var subscriptions: Set<AnyCancellable> = [];
    
    // Registration Form Validation
    func validateAuthenticationForm(){
        
        guard let email = email,
              let password = password else{
            isAuthenticationFormValid = false;
            return
        }
        
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 8;
    }
    
    // Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Create User in Firebase Authentication
    func createUser(){
            
        guard let email = email,
              let password = password else {return}
        
        AuthManager.shared.registerUser(with: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in // Save User to FireStore
                self?.user = user;
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription // error.localizedDescription -> From Firebase
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscriptions)
    }
    
    // Record User Data in Firestore
    func createRecord(for user: User){
        DatabaseManager.shared.collectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Adding User Record to database: \(state)")
            }
            .store(in: &subscriptions)
    }
    
    // Login User
    func loginUser(){
        guard let email = email,
              let password = password else { return }
        
        AuthManager.shared.loginUser(with: email, password: password)
            .sink{ [weak self] completion in
                
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
}
