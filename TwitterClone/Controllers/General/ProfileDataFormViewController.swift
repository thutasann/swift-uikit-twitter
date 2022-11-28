//
//  ProfileDataFormViewController.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/20/22.
//

import UIKit
import PhotosUI
import Combine

class ProfileDataFormViewController: UIViewController {
    
    // View Model
    private let viewModel = ProfileDataFormViewViewModel();
    private var subscriptions: Set<AnyCancellable> = []
    
    // Scroll view
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView();
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.alwaysBounceVertical = true // The most Important Attribute
        scrollView.keyboardDismissMode = .onDrag
        return scrollView;
    }()
    

    // Hint Label
    private let hintLabel: UILabel = {
        let hintLabel = UILabel();
        hintLabel.translatesAutoresizingMaskIntoConstraints = false;
        hintLabel.text = "Fill in your data";
        hintLabel.font = .systemFont(ofSize: 32, weight: .bold);
        hintLabel.textColor = .label;
        return hintLabel;
    }()
    
    // Bio Text Field
    private let bioTextView: UITextView = {
        let textView = UITextView();
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemFill;
        textView.layer.masksToBounds = true;
        textView.layer.cornerRadius = 8;
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15);
        textView.text = "Tell the world about yourself";
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        return textView
    }()
    
    // Display Name Text Field
    private let displayNameTextField: UITextField = {
        let textField = UITextField();
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.keyboardType = .default;
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always;
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)) // Text Field Left View
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Display Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField;
    }()
    
    // User Name Text Field
    private let userNameTextField: UITextField = {
        let textField = UITextField();
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.keyboardType = .default;
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always;
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true;
        textField.layer.cornerRadius = 8;
        textField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField;
    }()
    
    // Avatar Placeholder Image View
    private let avatarPlaceholderImageView: UIImageView = {
        let imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.tintColor = .gray;
        imageView.isUserInteractionEnabled = true;
        imageView.contentMode = .scaleAspectFit
        return imageView
    }();
    
    // Submit Button
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Submit", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button;
    }()

    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Sub Views go Here
        view.addSubview(scrollView)
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(avatarPlaceholderImageView)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(userNameTextField)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(submitButton)
        
        isModalInPresentation = true // To Prevent Closing the View
        
        bioTextView.delegate = self // For Delegate method for Fake Placeholder
        displayNameTextField.delegate = self
        userNameTextField.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss )))
        
        configureConstraints()
        
        
        // Submit Button Target
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        
        // Photo Upload
        avatarPlaceholderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToUpload)))
        
        bindViews()
        
    }
    
    // MARK: - Submit Button Hand
    @objc private func didTapSubmit(){
        viewModel.uploadAvatar()
    }
    
    
    // MARK: - Edting Changes
    @objc private func didUpdateDisplayName(){
        viewModel.displayName = displayNameTextField.text;
        viewModel.validateUserProfileForm() // Validate User Profile Form
    }
    
    @objc private func didUpdateUserName(){
        viewModel.userName = userNameTextField.text;
        viewModel.validateUserProfileForm() // Validate User Profile Form
    }
    
    
    // MARK: - BindView
    private func bindViews() {
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(didUpdateUserName), for: .editingChanged)
        viewModel.$isFormValid.sink { [weak self] buttonState in
            self?.submitButton.isEnabled = buttonState
        }
        .store(in: &subscriptions)
    }
    

    
    // MARK: - Photo Upload
    @objc private func didTapToUpload(){
        var configuration = PHPickerConfiguration();
        configuration.filter = .images;
        configuration.selectionLimit = 1;
        let picker = PHPickerViewController(configuration: configuration);
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // Did Tap To DIsmiss
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    // MARK: - Constraints Configuration
    private func configureConstraints(){
        
        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ];
        
        let hintLabelConstraints = [
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
        ]
        
        let avatarPlaceholderImageViewConstraints = [
            avatarPlaceholderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarPlaceholderImageView.heightAnchor.constraint(equalToConstant: 110),
            avatarPlaceholderImageView.widthAnchor.constraint(equalToConstant: 110),
            avatarPlaceholderImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 30)
        ]
        
        let displayNameTextFieldConstraints = [
            displayNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayNameTextField.topAnchor.constraint(equalTo: avatarPlaceholderImageView.bottomAnchor, constant: 40),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        
        let userNameTextFieldConstraints = [
            userNameTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            userNameTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            userNameTextField.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let bioTextViewConstraints = [
            bioTextView.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let submitButtonConstraints = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor) // For Preventing Keyboard
        ]
        
        
        NSLayoutConstraint.activate(scrollViewConstraints);
        NSLayoutConstraint.activate(hintLabelConstraints);
        NSLayoutConstraint.activate(avatarPlaceholderImageViewConstraints)
        NSLayoutConstraint.activate(displayNameTextFieldConstraints)
        NSLayoutConstraint.activate(userNameTextFieldConstraints)
        NSLayoutConstraint.activate(bioTextViewConstraints)
        NSLayoutConstraint.activate(submitButtonConstraints)
    }

}


// Delegate method for Bio Text View -> For Fake PLaceholder
extension ProfileDataFormViewController : UITextViewDelegate, UITextFieldDelegate {
    
    // Text View Did Begin Editing
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
        if(textView.textColor == .gray){
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    // Text View Did End Editing
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if(textView.text.isEmpty){
            textView.text = "Tell the world about yourself";
            textView.textColor = .gray
        }
    }
    
    // Since BIO is textView -> DidChange method is written in Here
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = textView.text;
    }
    
    // Text Field Did Begin Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 100), animated: true) // to stay in the view if the keyboard comes out
    }
    
    // Text Field Did End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}


// Delegate method for Photo Picker
extension ProfileDataFormViewController: PHPickerViewControllerDelegate {
    
    // Did Finish Picking
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage{
                    DispatchQueue.main.async {
                        self?.avatarPlaceholderImageView.image = image // update the avatar image placeholder
                        self?.avatarPlaceholderImageView.contentMode = .scaleAspectFill
                        self?.viewModel.imageData = image
                        self?.viewModel.validateUserProfileForm()
                    }
                }
            }
        }
    }
    
}
