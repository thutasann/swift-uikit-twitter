//
//  ProfileHeaderUIView.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/16/22.
//

import UIKit

class ProfileTableViewHeader: UIView {
    
    
    // Seciton Tabs Enum (Switch case)
    private enum SectionTabs: String{
        case tweets = "Tweets"
        case tweetsAnReplies = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
    
        var index : Int {
            switch self {
            case .tweets:
                return 0
            case .tweetsAnReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    
    // Selected Tab
    private var selectedTab: Int = 0 {
        didSet{
            print(selectedTab)
        }
    }
    
    // Tabs Buttons
    private var tabs: [UIButton] = ["Tweets", "Tweets & Replies", "Media", "Likes"].map {
        buttonTitle in
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    // Section Stack View
    private lazy var sectionStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center // to align buttons in the Center horizontally
        return stackView
    }()
    
    
    // Follower Text Label
    private let followerTextLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Followers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    
    // Follower Count label
    private let followerCountLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .label
        label.text = "1M"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    
    // Follwing Text label
    private let follwingTextLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    
    // Following count label
    private let followingCountLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "341"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label;
    }()
    
    // Jonined Date Label
    private let joinedDateLabel : UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "March 16, 1999"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    // Joining Date Image View
    private let joinDateImageView : UIImageView = {
        let imageView = UIImageView();
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // User Bio Label
    private let userBioLabel : UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "I Talk, I Deliver"
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        return label
    }()

    
    // Display Name Label
    private let displayNameLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Thuta Sann"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    // User Name Label
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@thutasann"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    
    // Profile Avatar Image View
    private let profileAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .gray
        imageView.tintColor = .black
        return imageView
    }()
    
    
    // Profile Header View Image
    private let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "header")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    // Initialier
    override init(frame: CGRect){
        super.init(frame: frame)
      
        // Sub Views go Here...
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(displayNameLabel)
        addSubview(userNameLabel)
        addSubview(userBioLabel)
        addSubview(joinDateImageView)
        addSubview(joinedDateLabel)
        addSubview(followingCountLabel)
        addSubview(follwingTextLabel)
        addSubview(followerCountLabel)
        addSubview(followerTextLabel)
        addSubview(sectionStack)
        configureConstraints()
        configureStackButton()
    }
    
    
    // Tabs button onTap Function
    @objc private func didTapTab (_ sender: UIButton){
        guard let label = sender.titleLabel?.text else { return }
        
        switch label {
        case SectionTabs.tweets.rawValue:
            selectedTab = 0
        case SectionTabs.tweetsAnReplies.rawValue:
            selectedTab = 1
        case SectionTabs.media.rawValue:
            selectedTab = 2
        case SectionTabs.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    
    // StackButtons Configure
    private func configureStackButton(){
        for(_, button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    
    // Constraints Configuration
    private func configureConstraints(){
        
        // Header Image View Constraints
        let profileHeaderImageViewConstraints = [
            
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        ];
        
        
        // Profile Avatar Image View Constraints
        let profileAvatarImageViewConstraints = [
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        // Display Name Label Constraints
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 20),
        ];
        
        
        // User Name Label Constraints
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor,constant: 5)
        ];
        
        // User Bio Constraints
        let userBioLabelConstraints = [
            userBioLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            userBioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5)
        ]
        
        
        // Joining Date Constraints
        let joinDateConstraints = [
            joinDateImageView.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor, constant: 5)
        ]
        
        // Joined Date Label Constriants
        let joinedDateLabeConstraints = [
            joinedDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 2),
            joinedDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
        ]
        
        // Fowlling Count Label Constraints
        let followingCountLabelConstraints = [
            followingCountLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            followingCountLabel.topAnchor.constraint(equalTo: joinedDateLabel.bottomAnchor, constant: 10)
        ]
        
        // Following Text Label Constraints
        let followingTextLabelConstraints = [
            follwingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 4),
            follwingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        // Followers Count Label Constraints
        let followersCountLabelConstraints = [
            followerCountLabel.leadingAnchor.constraint(equalTo: follwingTextLabel.trailingAnchor, constant: 8),
            followerCountLabel.bottomAnchor.constraint(equalTo: follwingTextLabel.bottomAnchor)
        ]
        
        // Follwers Text Label COnstraints
        let followersTextLabelConstraints = [
            followerTextLabel.leadingAnchor.constraint(equalTo: followerCountLabel.trailingAnchor, constant: 4),
            followerTextLabel.bottomAnchor.constraint(equalTo: followerCountLabel.bottomAnchor)
        ]
        
        // Section Stack Constraints
        let sectionStackConstraints = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ];
        
        
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(userBioLabelConstraints)
        NSLayoutConstraint.activate(joinDateConstraints)
        NSLayoutConstraint.activate(joinedDateLabeConstraints)
        NSLayoutConstraint.activate(followingCountLabelConstraints)
        NSLayoutConstraint.activate(followingTextLabelConstraints)
        NSLayoutConstraint.activate(followersCountLabelConstraints)
        NSLayoutConstraint.activate(followersTextLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)

    }
    
    
    // Initialize the coder
    required init(coder: NSCoder){
        fatalError()
    }
    

}
