//
//  OnboardingUIViewController.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/17/22.
//

import UIKit

class OnboardingUIViewController: UIViewController {

    // Welcome Label
    private let welcomeLabel: UILabel = {
        let label = UILabel();
        label.numberOfLines = 0;
        label.text = "See what's happening in the world right now."
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        return label;
    }()
    
    
    // Create Account Button
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.setTitle("Craete Account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    
    // PropmptLabel
    private let promptLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .gray
        label.text = "Have an account already?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label;
    }()
    
    // Login Button
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return button;
    }()
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // subViews go here...
        view.addSubview(welcomeLabel)
        view.addSubview(createAccountButton)
        view.addSubview(promptLabel)
        view.addSubview(loginButton)
        
        configureConstraints()
    }
    
    // Configure Constraints
    private func configureConstraints() {
        let welcomeLabelConstraints = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ];
        
        let createAccountButtonConstraints = [
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ];
        
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ];
        
        let loginButtonConstraints = [
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstraints)
        NSLayoutConstraint.activate(createAccountButtonConstraints)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }
    
}
