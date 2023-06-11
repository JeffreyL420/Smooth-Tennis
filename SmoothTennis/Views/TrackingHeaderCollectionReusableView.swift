//
//  TrackingHeaderCollectionReusableView.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/12.
//

import UIKit

//class TrackingHeaderCollectionReusableView: UICollectionReusableView {
//    static let identifier = "TrackingHeaderCollectionReusableView"
//
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = true
//        imageView.clipsToBounds = true
//        imageView.layer.masksToBounds = true
//        imageView.backgroundColor = .secondarySystemBackground
//        return imageView
//    }()
//
//    public let countContainerView = ProfileHeaderCountView()
//
//    private let toSeeMore: UILabel = {
//        let label = PaddingLabel()
//        label.paddingLeft = 10
//        label.paddingRight = 10
//        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//        let underlineAttributedString = NSAttributedString(string: "Scroll right to view more", attributes: underlineAttribute)
//        label.attributedText = underlineAttributedString
//        label.font = .systemFont(ofSize: 10)
//        return label
//    }()
//
//    private let bioLabel: UILabel = {
//        let label = PaddingLabel()
//        label.paddingLeft = 10
//        label.numberOfLines = 0
//        //label.sizeToFit()
//        label.text = ""
//        label.layer.borderWidth = 2
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        label.layer.masksToBounds = true
//        label.backgroundColor = .systemGreen
//        label.font = .systemFont(ofSize: 16)
//        return label
//    }()
//
//    private let ageLabel: UILabel = {
//        let label = PaddingLabel()
//        label.numberOfLines = 0
//        label.paddingLeft = 10
//        //label.text = ""
//        label.layer.borderWidth = 2
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        label.layer.masksToBounds = true
//        label.backgroundColor = .systemGreen
//        label.font = .systemFont(ofSize: 16)
//        return label
//    }()
//
//    private let experienceLabel: UILabel = {
//        let label = PaddingLabel()
//        label.numberOfLines = 0
//        label.paddingLeft = 10
//        label.backgroundColor = .systemGreen
//        label.text = ""
//        label.layer.borderWidth = 2
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        label.layer.masksToBounds = true
//        label.font = .systemFont(ofSize: 16)
//        return label
//    }()
//
//    private let locationLabel: UILabel = {
//        let label = PaddingLabel()
//        label.numberOfLines = 0
//        label.paddingLeft = 10
//        label.paddingTop = 5
//        label.paddingBottom = 5
//        label.backgroundColor = .systemGreen
//        label.text = ""
//        label.layer.borderWidth = 2
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        label.layer.masksToBounds = true
//        label.font = .systemFont(ofSize: 16)
//        return label
//    }()
//
//    // MARK: - Init
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(countContainerView)
//        addSubview(imageView)
//        addSubview(bioLabel)
//        addSubview(ageLabel)
//        addSubview(locationLabel)
//        addSubview(experienceLabel)
//        addSubview(toSeeMore)
//
////        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
////        imageView.addGestureRecognizer(tap)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
////    @objc func didTapImage() {
////        delegate?.profileHeaderCollectionReusableViewDidTapProfilePicture(self)
////    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let imageSize: CGFloat = width/3.5
//        imageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
//        imageView.layer.cornerRadius = imageSize/2
//        countContainerView.frame = CGRect(
//            x: imageView.right+5,
//            y: 3,
//            width: width-imageView.right-10,
//            height: imageSize
//        )
//        let bioSize = bioLabel.sizeThatFits(bounds.size)
//        let yLength = imageView.bottom+10
//        ageLabel.frame = CGRect(
//            x: 5, y: yLength, width: imageSize+10, height: bioSize.height+40
//        )
//        locationLabel.frame = CGRect(
//            x: 5, y: ageLabel.bottom+5, width: imageSize+10, height: bioSize.height+50
//        )
//        experienceLabel.frame = CGRect(
//            x: 5, y: locationLabel.bottom+5, width: imageSize+10, height: bioSize.height+40
//        )
//        //bioLabel.sizeToFit()
//        bioLabel.frame = CGRect(
//            x: ageLabel.right+10,
//            y: yLength,
//            width: width-width/3-10,
//            height: bioSize.height+140
//        )
//        bioLabelBottom = bioLabel.bottom
//        toSeeMore.frame = CGRect(x: width/1.5, y: bottom-30, width: imageSize+20, height: bioSize.height+30)
//
////        bioLabel.sizeToFit()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//        bioLabel.text = nil
//        ageLabel.text = nil
//        experienceLabel.text = nil
//
//    }
//
//    public func configure(with viewModel: ProfileHeaderViewModel) {
//        imageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
//
//        var text = "Bio:  "
//        if let name = viewModel.name {
//            text = name + "\nBio:"
//        }
//        text += viewModel.bio ?? "Welcome to my profile!"
//        bioLabel.text = text
//
//        var text1 = "Age: "
//        text1 += viewModel.age ?? ""
//        ageLabel.text = text1
//
//        var text2 = "Experience:  "
//        text2 += viewModel.experience ?? ""
//        experienceLabel.text = text2
//
//        var text3 = "Location:  "
//        text3 += viewModel.location ?? ""
//        locationLabel.text = text3
//        // Container
//        let containerViewModel = ProfileHeaderCountViewViewModel(
////            followerCount: viewModel.followerCount,
////            followingCount: viewModel.followingICount,
//            postsCount: viewModel.postCount,
//            actioonType: viewModel.buttonType
//        )
//        countContainerView.configure(with: containerViewModel, playerType1: "?")
//    }
//}
