//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/15/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    // NavigationBar Configuration to display the logo on the Top of the Phone
    private func configureNavigationBar(){
        let size: CGFloat = 33
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitterLogo")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        
        navigationItem.titleView = middleView
        
        // profile image
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
    }
    
    // Tap Function Upon Profile Icon
    @objc private func didTapProfile(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // TimeLine (Feed) Table View
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        configureNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
    }
    
    
    // Sign Out Tap
    @objc private func didTapSignOut(){
        try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    // View Did Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // frame the Timeline Table View
        timelineTableView.frame = view.frame
    }
    
    // Authentication Handler
    private func handleAuthentication(){
        // Authentication Check
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingUIViewController());
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    
    // View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
    }
    
}

// UI Table Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of Rows In Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // Cell For Row At -> To identify how to render the Rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
 

}

// To Test Action Buttons in Each Tweet
extension HomeViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        print("Reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("ReTweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("Like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("Share")
    }
}
