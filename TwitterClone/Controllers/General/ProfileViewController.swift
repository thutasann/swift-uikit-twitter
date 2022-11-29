//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/16/22.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    
    private var isStatusBarHidden: Bool = true
    private var viewModel = ProfileViewViewModel()
    private var subscriptions : Set<AnyCancellable> = []
    
    // Status Bar at the Header
    private let statusBar : UIView = {
        let view = UIView();
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view;
    }()
    
    
    // Profile Header View
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 400));
    
    
    // Profile Table View
    private let profileTableView : UITableView = {
        let tableView = UITableView();
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // View Will
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.retrieveUser()
    }

    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile" // Title on the Top Center of the Phone
        
        // SubViews go here..
        view.addSubview(profileTableView)
        
        view.addSubview(statusBar)
       
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never // hide the back arrow and ignore the safeArea
        
        navigationController?.navigationBar.isHidden = true
        
        configureConstraints()
        
        bindViews()
    }
    
    // Bind View
    private func bindViews(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.userNameLabel.text = user.username
            self?.headerView.followerCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBioLabel.text = user.bio
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
        }
        .store(in: &subscriptions)

    }
    
    // Constraints Configuration
    private func configureConstraints() {
        
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ];
        
        
        // Status Bar at the Top Constraints
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20) // For Notch or NotchLess
        ];
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // Numbers of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    // Cell For Row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
    // For Header Status Bar Scroll Show/Hide
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden{
            isStatusBarHidden  = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: { _ in }
        }
        else if yPosition < 0 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
    
}
