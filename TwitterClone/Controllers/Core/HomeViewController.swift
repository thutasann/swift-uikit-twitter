//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Thuta sann on 11/15/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // NavigationBar Configuration
    private func configureNavigationBar(){
        
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
    }
    
    // View Did Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // frame the Timeline Table View
        timelineTableView.frame = view.frame
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
