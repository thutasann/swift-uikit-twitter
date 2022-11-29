//
//  ProfileViewViewModel.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/29/22.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel : ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = [];
    
    // MARK: - Retrieve User
    func retrieveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
}
