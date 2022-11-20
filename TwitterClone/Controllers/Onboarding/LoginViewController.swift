//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/20/22.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // View Model
    private var viewModel = AuthenticationViewViewModel();
    private var subscriptions:  Set<AnyCancellable> = []
    
    
    // Register Label
    private let loginTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login your account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    // Email TextField
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    // Password TextField
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // Login Button
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.alpha = 0.5
        return button;
    }()
    
    // Email Text Field Onchage
    @objc private func didChangeEmailField(){
        viewModel.email = emailTextField.text;
        viewModel.validateAuthenticationForm()
    }
    
    // Password Text Field Onchange
    @objc private func didChangePasswordField(){
        viewModel.password = passwordTextField.text;
        viewModel.validateAuthenticationForm()
    }

    // Bind Views with @AuthenticationViewViewModel
    private func bindViews(){
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink{ [weak self] validationState in
            self?.loginButton.isEnabled = validationState
            self?.loginButton.alpha = 1
        }
        .store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingUIViewController else { return }
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        
        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else { return }
            self?.presentAlert(with: error)
        }
        .store(in: &subscriptions)
    }
    
    // error alert
    private func presentAlert(with error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert);
        let okayButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okayButton)
        present(alert, animated: true)
    }
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Sub Views go Here..
        view.addSubview(loginTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configureConstraints()
        bindViews()
    }
    
    // Login Did Tap Handler
    @objc private func didTapLogin(){
        viewModel.loginUser()
    }
    
    // Constraints Configuraiton
    private func configureConstraints(){
        
        let loginTitleLabelConstraints = [
            loginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ]
        
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let passwordTextConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let registerButtonConstraints = [
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 180),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(loginTitleLabelConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
        
    }
}
