//
//  HomeViewViewModel.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/20/22.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject{
    
    @Published var user: TwitterUser?
    @Published var error: String?
    
    private var subscriptoins: Set<AnyCancellable> = [];
    
    // Retrieve User from user Collection
    func retrieveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription;
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptoins)
    }
    
    
}
