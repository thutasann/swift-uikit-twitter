//
//  TweetTableViewCell.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/15/22.
//

// THIS IS CUSTOM TWEET TABLE TO RENDER IN THE HOME PAGE

import UIKit

class TweetTableViewCell: UITableViewCell {

    static let identifier = "TweetTableViewCell"
    
    // Avatar Image For user
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .gray
        imageView.tintColor = .black   
        return imageView
    }()
    
    
    // Display Name Label
    private let displayNameLabel: UILabel = {
       let label = UILabel()
       label.text = "Thuta Sann"
       label.font = .systemFont(ofSize: 18, weight: .bold)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    // User Name Label
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@thutasann"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Tweet Content Label
    private let tweetTextContentLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is my Mock up tweet. Its is going to take multiple lines. I believe some more text is enough but let add some more text to make sure its working fine or not"
        label.numberOfLines = 0
        return label
    }()
    
    // Initialize the Table and Its styles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Sub Views go Here
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(tweetTextContentLabel)
        configureConstraints()
    }
    
    
    // Configure Constraints
    private func configureConstraints(){
        
        // avatarImage Constraints
        let avatarImageViewConstraints = [
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20), // to the right
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14), // top
            avatarImageView.heightAnchor.constraint(equalToConstant: 50), // height
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        ];
        
        // DisplayName Constraints
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            displayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ];
        
        
        // UserName Constraints
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor)
        ]
        
        // Tweet Content
        let tweetTextContentLabelConstraints = [
            tweetTextContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            tweetTextContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 10),
            tweetTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            tweetTextContentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(avatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(tweetTextContentLabelConstraints)
    }
    
    // Fatal Error
    required init?(coder: NSCoder){
        fatalError()
    }
    
}
