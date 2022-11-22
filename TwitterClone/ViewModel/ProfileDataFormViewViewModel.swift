//
//  ProfileDataFormViewViewModel.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/20/22.
// TO RETRIEVE AUTHENTICATED USER

import Foundation
import Combine

final class ProfileDataFormViewViewModel: ObservableObject{

    @Published var displayName: String?
    @Published var userName: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
}

