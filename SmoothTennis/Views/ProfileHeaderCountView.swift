//
//  ProfileHeaderCountView.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/23/21.
//

import UIKit

protocol ProfileHeaderCountViewDelegate: AnyObject {
    func profileHeaderCountViewDidTapFollowers(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapFollowing(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapPosts(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapEditProfile(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapFollow(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountViewDidTapUnFollow(_ containerView: ProfileHeaderCountView)
}

class ProfileHeaderCountView: UIView {

    weak var delegate: ProfileHeaderCountViewDelegate?

    private var action = ProfileButtonType.edit

    // Count Buttons

//    private let followerCountButton: UIButton = {
//        let button = UIButton()
//        button.setTitleColor(.label, for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.setTitle("-", for: .normal)
//        button.titleLabel?.textAlignment = .center
//        button.layer.cornerRadius = 4
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        return button
//    }()
//
//    private let followingCountButton: UIButton = {
//        let button = UIButton()
//        button.setTitleColor(.label, for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.setTitle("-", for: .normal)
//        button.titleLabel?.textAlignment = .center
//        button.layer.cornerRadius = 4
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        return button
//    }()

    private let postCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    private let userStatus: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //Coach Profile only comment to leave ratings

    private let actionButton = IGFollowButton()
    

    private var isFollowing = false

    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(followerCountButton)
//        addSubview(followingCountButton)
        addSubview(postCountButton)
        addSubview(actionButton)
        addSubview(userStatus)
        addActions()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addActions() {
//        followerCountButton.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)
//        followingCountButton.addTarget(self, action: #selector(didTapFollowing), for: .touchUpInside)
        postCountButton.addTarget(self, action: #selector(didTapPosts), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    // Actions
    
    @objc func didTapFollowers() {
        delegate?.profileHeaderCountViewDidTapFollowers(self)
    }

    @objc func didTapFollowing() {
        delegate?.profileHeaderCountViewDidTapFollowing(self)
    }

    @objc func didTapPosts() {
        delegate?.profileHeaderCountViewDidTapPosts(self)
    }

    @objc func didTapActionButton() {
        switch action {
        case.edit:
            delegate?.profileHeaderCountViewDidTapEditProfile(self)
            //delegate?.profileHeaderCountViewDidTapLeaveComment(self)
        case .follow:
            if self.isFollowing {
                // unfollow
                delegate?.profileHeaderCountViewDidTapUnFollow(self)
            }
            else {
                // Follow
                delegate?.profileHeaderCountViewDidTapFollow(self)
            }
            self.isFollowing = !isFollowing
            actionButton.configure(for: isFollowing ? .unfollow : .follow)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWidth: CGFloat = (width-15)/3
        let postCountButtonWidth: CGFloat = (width)/27
    
//        followerCountButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: height/2)
//        followingCountButton.frame = CGRect(x: followerCountButton.right+5, y: 5, width: buttonWidth, height: height/2)
        
        actionButton.frame = CGRect(x: 5, y: height-42, width: width-10, height: 40)
        userStatus.frame = CGRect(x: 5, y: topCommentLabel, width: width-165, height: 30)
    }

    func configure(with viewModel: ProfileHeaderCountViewViewModel, playerType1: String) {
        let buttonWidth: CGFloat = (width-15)/3
        let postCountButtonWidth: CGFloat = (width)/27
//        followerCountButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
//        followingCountButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        if viewModel.viewable == false {
            postCountButton.frame = CGRect(x: postCountButtonWidth, y: bioLabelBottom+5, width: buttonWidth*1.5, height: height/2)
            postCountButton.setTitle("\(viewModel.postsCount)\nPosts", for: .normal)
//            leaveCommentButton.isHidden = true
            userStatus.image = UIImage(named: "Player")
        }
        else if viewModel.viewable {
            postCountButton.setTitle("\(viewModel.postsCount)\nReviews", for: .normal)
            postCountButton.frame = CGRect(x: postCountButtonWidth, y: certificateImageBottom, width: buttonWidth*1.5, height: height/2.5)
//            leaveCommentButton.isHidden = false
            userStatus.image = UIImage(named: "Coach")
        }
        
      

        self.action = viewModel.actioonType

        switch viewModel.actioonType {
        case .edit:
            actionButton.backgroundColor = .systemBackground
            actionButton.setTitle("Edit Profile", for: .normal)
            actionButton.setTitleColor(.label, for: .normal)
            actionButton.layer.borderWidth = 0.5
            actionButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        case .follow(let isFollowing):
//            self.isFollowing = isFollowing
//            actionButton.configure(for: isFollowing ? .unfollow : .follow)
            actionButton.isHidden = true
        }
    }
}
