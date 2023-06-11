//
//  ProfileHeaderCollectionReusableView.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/23/21.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableViewDidTapProfilePicture(_ header: ProfileHeaderCollectionReusableView, type: String)
    func profileHeaderCollectionReusableViewDidTapCertificatePicture(_ header: ProfileHeaderCollectionReusableView, type: String)
    func profileHeaderCollectionReusableViewDidTapLeaveComment(_ header: ProfileHeaderCollectionReusableView)
}

var bioLabelBottom: CGFloat = 0
var topCommentLabel: CGFloat = 0
var certificateImageBottom: CGFloat = 0

class ProfileHeaderCollectionReusableView: UICollectionReusableView, UITextViewDelegate {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private var viewable = false
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let certificateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        //imageView.layer.masksToBounds = true
        imageView.isHidden = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
//    private let lblCount: UILabel = {
//        let label = PaddingLabel()
//        label.paddingLeft = 10
//        label.paddingRight = 10
//        label.text = ""
//        label.font = .systemFont(ofSize: 10)
//        return label
//    }()

    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?

    public let countContainerView = ProfileHeaderCountView()
    
    private let toSeeMore: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 10
        label.paddingRight = 10
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Scroll right to view more", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString
        label.font = .systemFont(ofSize: 8)
        return label
    }()

//    private let bioLabel: UILabel = {
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
    
    private let bioLabel: UITextView = {
        let label = UITextView()
        //label.isEditing = false
        //label.ma = 0
        //label.paddingLeft = 10
        //label.text = ""
        label.isEditable = false
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGreen
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let topCommentORPlayerLevelLabel: PaddingLabel = {
        let label = PaddingLabel()
        //label.isEditing = false
        //label.ma = 0
        //label.paddingLeft = 10
        //label.text = ""
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGreen
        label.textAlignment = .center
        label.font = UIFont(name: "Optima-ExtraBlack", size: 14)
        //label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    private let ageLabel: UILabel = {
        let label = PaddingLabel()
        label.numberOfLines = 0
        label.paddingLeft = 10
        //label.text = ""
        label.layer.borderWidth = 2
        //let color = UIColor(hexString: "#E7CBCB")
        //label.textColor = color
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGreen
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let certificateLabel: UILabel = {
        let label = PaddingLabel()
        label.numberOfLines = 0
        label.paddingLeft = 8
        label.paddingRight = 8
        //label.text = ""
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.isHidden = true
        label.backgroundColor = .systemGreen
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Coaching Certificate"
        return label
    }()
    
    private let experienceLabel: UILabel = {
        let label = PaddingLabel()
        label.numberOfLines = 0
        label.paddingLeft = 10
        label.backgroundColor = .systemGreen
        label.text = ""
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = PaddingLabel()
        label.numberOfLines = 0
        label.paddingLeft = 10
        label.paddingTop = 5
        label.paddingBottom = 5
        label.backgroundColor = .systemGreen
        label.text = ""
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let leaveCommentButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.label, for: .normal)
        button.isUserInteractionEnabled = true
        button.isHidden = true
        button.setImage(UIImage(systemName: "plus.bubble.fill"), for: .normal)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(countContainerView)
        addSubview(imageView)
        addSubview(bioLabel)
        addSubview(ageLabel)
        addSubview(locationLabel)
        addSubview(experienceLabel)
        addSubview(toSeeMore)
        addSubview(certificateImage)
        addSubview(certificateLabel)
        addSubview(leaveCommentButton)
        addSubview(topCommentORPlayerLevelLabel)
        leaveCommentButton.addTarget(self, action: #selector(didTapLeaveComment), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
        let tap2 =  UITapGestureRecognizer(target: self, action: #selector(didTapImage2))
        certificateImage.addGestureRecognizer(tap2)
    }
    
    //character counting code

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapLeaveComment() {
        delegate?.profileHeaderCollectionReusableViewDidTapLeaveComment(self)

    }

    @objc func didTapImage() {
        delegate?.profileHeaderCollectionReusableViewDidTapProfilePicture(self, type: "Profile")
    }
    
    @objc func didTapImage2() {
        delegate?.profileHeaderCollectionReusableViewDidTapCertificatePicture(self, type: "Certificate")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = width/3.5
        let postCountButtonWidth: CGFloat = (width)/27
        imageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        imageView.layer.cornerRadius = imageSize/2
        countContainerView.frame = CGRect(
            x: imageView.right+5,
            y: 3,
            width: width-imageView.right-10,
            height: imageSize
        )
        let bioSize = 0.0  //bioLabel.sizeThatFits(bounds.size)
        let yLength = imageView.bottom+10
        ageLabel.frame = CGRect(
            x: 5+imageSize+20, y: yLength, width: imageSize+10, height: bioSize+40
        )
        locationLabel.frame = CGRect(
            x: 5, y: yLength, width: imageSize+10, height: bioSize+50+(bioSize+40)
        )
        experienceLabel.frame = CGRect(
            x: 5, y: locationLabel.bottom+5, width: imageSize+10, height: bioSize+60
        )
        //bioLabel.sizeToFit()
        bioLabel.frame = CGRect(
            x: ageLabel.left,
            y: ageLabel.bottom+5,
            width: width-width/3-10,
            height: bioSize+150-(bioSize+40)
        )
        bioLabelBottom = bioLabel.bottom
        topCommentLabel = topCommentORPlayerLevelLabel.top-topCommentORPlayerLevelLabel.height/6
        toSeeMore.frame = CGRect(x: width/1.5, y: bottom-30, width: imageSize+30, height: bioSize+30)
        certificateImage.frame = CGRect(x: width/6, y: bioLabel.bottom+experienceLabel.height, width: width/1.5, height: bioSize+150)
//        certificateLabel.frame = CGRect(x: width/3.6, y: certificateImage.top-50, width: imageSize+70, height: bioSize+40)
        certificateImageBottom = certificateImage.bottom
        certificateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        certificateLabel.centerYAnchor.constraint(equalTo: certificateImage.topAnchor, constant: -30).isActive = true
        certificateLabel.widthAnchor.constraint(equalToConstant: imageSize+60).isActive = true
        certificateLabel.heightAnchor.constraint(equalToConstant: bioSize+35).isActive = true
               
        leaveCommentButton.frame = CGRect(x: 10, y: certificateImage.bottom+10, width: imageSize-10, height: bioSize+40)
        leaveCommentButton.backgroundColor = UIColor.blue
//        bioLabel.sizeToFit()
        topCommentORPlayerLevelLabel.frame = CGRect(x: bioLabel.left+110, y: imageView.bottom/5+5, width: imageSize+30, height: bioSize+30)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        bioLabel.text = nil
        ageLabel.text = nil
        experienceLabel.text = nil
        topCommentORPlayerLevelLabel.text = nil
        //certificateLabel.text = nil
            
    }

    public func configure(with viewModel: ProfileHeaderViewModel, playerType1: String) {
        imageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Scroll right to view more", attributes: underlineAttribute)
        toSeeMore.attributedText = underlineAttributedString
        certificateImage.sd_setImage(with: viewModel.certificatePictureURL, completed: nil)
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        if playerType1 == "Coach" {
            certificateLabel.isHidden = false
            certificateImage.isHidden = false
            leaveCommentButton.isHidden = false
            if viewModel.topCommentAmount == nil {
                DatabaseManager.shared.getCoachCommentAmount(username: username) { result in
                    self.topCommentORPlayerLevelLabel.text = "Top Comments: \(result)"
                }
            }
            else {
                self.topCommentORPlayerLevelLabel.text = "Top Comments: \(viewModel.topCommentAmount!)"
            }
        }
        else {
            topCommentORPlayerLevelLabel.text = "\(viewModel.playerLevel!)"
        }
//        else {
//        }
        
        var text = "Bio:  "
        if let name = viewModel.name {
            text = name + "\nBio: "
        }
        if viewModel.bio == "" {
            text += "Welcome to my profile!"
        }
        else {
            text = viewModel.bio ?? ""
        }
        bioLabel.text = text
//        let attributedStringBio = NSMutableAttributedString(string: text)
//
//        attributedStringBio.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FF597B")],range: NSRange(location: 0, length: 4))
//
//        attributedStringBio.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)],range: NSRange(location: 0, length: 4))
//        bioLabel.attributedText = attributedStringBio
        
        var text1 = "Age: "
        text1 += viewModel.age ?? ""
        ageLabel.text = text1
        let attributedString = NSMutableAttributedString(string: text1)
        
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FC4F4F")],range: NSRange(location: 0, length: 4))
        
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)],range: NSRange(location: 0, length: 4))
        ageLabel.attributedText = attributedString
        
        
        
        var text2 = "Experience:  "
        text2 += viewModel.experience ?? ""
        experienceLabel.text = text2
        let attributedStringExp = NSMutableAttributedString(string: text2)
        
        attributedStringExp.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FC4F4F")],range: NSRange(location: 0, length: 11))
        
        attributedStringExp.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)],range: NSRange(location: 0, length: 11))
        experienceLabel.attributedText = attributedStringExp
        
        var text3 = "Location:  "
        text3 += viewModel.location ?? ""
        locationLabel.text = text3
        let attributedStringLoc = NSMutableAttributedString(string: text3)
        
        attributedStringLoc.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FC4F4F")],range: NSRange(location: 0, length: 9))
        
        attributedStringLoc.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)],range: NSRange(location: 0, length: 9))
        locationLabel.attributedText = attributedStringLoc
        
        if playerType1 == "Coach" {
            viewable = true
        }
        
        // Container
        let containerViewModel = ProfileHeaderCountViewViewModel(
//            followerCount: viewModel.followerCount,
//            followingCount: viewModel.followingICount,
            viewable: viewable,
            postsCount: viewModel.postCount,
            actioonType: viewModel.buttonType
        )
        countContainerView.configure(with: containerViewModel, playerType1: playerType1)
        
    }
    
    
}
