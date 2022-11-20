//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/18/22.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    // View Model
    private var viewModel = AuthenticationViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    // Register Label
    private let registerTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your account"
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
    
    // Register Button
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Create Account", for: .normal)
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
            self?.registerButton.isEnabled = validationState
            self?.registerButton.alpha = 1
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
     
    
    // For Button Disabled/Enabled
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }

    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Sub Views go here
        view.addSubview(registerTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        configureConstraints()
        
        // Add Gesture Recognizer
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        bindViews()
    }
    
    // Register Handle OnTap Func
    @objc private func didTapRegister(){
        viewModel.createUser()
    }
    
    
    // Constraints Configurations
    private func configureConstraints(){
        let registerTitleLabelConstraints = [
            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ]
        
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 20),
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
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 180),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(registerTitleLabelConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }


}
