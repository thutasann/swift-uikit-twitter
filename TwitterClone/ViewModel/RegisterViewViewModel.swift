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


final class RegisterViewViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isRegistrationFormValid: Bool = false
    @Published var user: User?
    
    // subscription
    private var subscriptions: Set<AnyCancellable> = [];
    
    
    // Registration Form Validation
    func validateRegisrationForm(){
        
        guard let email = email,
              let password = password else{
            isRegistrationFormValid = false;
            return
        }
        
        isRegistrationFormValid = isValidEmail(email) && password.count >= 8;
    }
    
    // Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    // Create User
    func createUser(){
            
        guard let email = email,
              let password = password else {return}
        
        AuthManager.shared.registerUser(with: email, password: password)
            .sink { _ in
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
}
