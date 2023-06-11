//
//  ProfilePhotoCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/9.
//

import UIKit


protocol ProfilePhotoCollectionViewCellDelegate: AnyObject {
    func commentDidTapProfileName(_ cell: ProfilePhotoCollectionViewCell, username: String)
    func commentDidTapProfileImage(_ cell: ProfilePhotoCollectionViewCell, username: String)
}

class ProfilePhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfilePhotoCollectionViewCell"

    weak var delegate: ProfilePhotoCollectionViewCellDelegate?
    
    let profilePictureImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        return imageView
    }()
    
    private let field: UITextView = {
        let field = UITextView()
        field.isEditable = false
        field.isScrollEnabled = true
        field.showsVerticalScrollIndicator = true
        field.backgroundColor = .clear
        field.font = UIFont.systemFont(ofSize: 16)
        field.textContainer.maximumNumberOfLines = 0
//        field.textContainer.lineBreakMode = .byTruncatingTail
        return field
    }()
    
    private let nameField: UITextView = {
        let field = UITextView()
        field.isEditable = false
        field.isScrollEnabled = true
        field.showsVerticalScrollIndicator = true
        field.isUserInteractionEnabled = true
        field.backgroundColor = .clear
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.textContainer.maximumNumberOfLines = 0
//        field.textContainer.lineBreakMode = .byTruncatingTail
        return field
    }()
    
    private let emptyField: UITextView = {
        let field = UITextView()
        field.isEditable = false
        field.isScrollEnabled = true
        field.showsVerticalScrollIndicator = true
        field.backgroundColor = .clear
        field.font = UIFont.systemFont(ofSize: 16)
        field.textContainer.maximumNumberOfLines = 0
        field.isHidden = true
//        field.textContainer.lineBreakMode = .byTruncatingTail
        return field
    }()
    
    private let videoView: UIButton = {
        let imageView = UIButton()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "play"), for: .normal)
        imageView.tintColor = .systemCyan
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true

        return imageView
    }()
    
//    private let label: UILabel = {
//        let label = PaddingLabel()
//        label.clipsToBounds = true
//        label.paddingLeft = 20
//        label.paddingRight = 20
//        label.backgroundColor = .systemGreen
//        label.numberOfLines = 0
//        label.font = .systemFont(ofSize: 16)
//        label.text = ""
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        //contentView.addSubview(label)
        contentView.addSubview(profilePictureImageView1)
        contentView.addSubview(field)
        contentView.addSubview(nameField)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapImage))
        profilePictureImageView1.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapUsernameComment))
        nameField.addGestureRecognizer(tap2)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .systemGreen
        //imageView.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        field.text = nil
        nameField.text = nil
        nameField.isHidden = true
        emptyField.text = nil
        emptyField.isHidden = true
        //label.frame = contentView.bounds
        field.frame = contentView.bounds
    }
    
    @objc func didTapImage() {
        delegate?.commentDidTapProfileImage(self, username: nameField.text)
    }

    @objc func didTapUsernameComment() {
        delegate?.commentDidTapProfileName(self, username: nameField.text)
    }
    
    
    func configure(
        with url: URL?,
        with videoURL: String?,
        with caption: String,
        with tag: String,
        with playerType: String
    ) {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: tag.capitalized, attributes: underlineAttribute)
       
        nameField.attributedText = underlineAttributedString
        nameField.font = UIFont.boldSystemFont(ofSize: 18)
        nameField.text = tag.capitalized
        field.text = caption
        field.isHidden = false
        if tag != "nil" {
            emptyField.removeFromSuperview()
            if playerType == "Coach" {
                nameField.isHidden = false
                imageView.isHidden = true
                let imagePadding: CGFloat = 4
                let imageSize: CGFloat = contentView.height/1.5 - (imagePadding * 2)
                profilePictureImageView1.frame = CGRect(x: 20, y: contentView.top+5, width: imageSize/2.3, height: imageSize/2.3)
                nameField.frame = CGRect(x: profilePictureImageView1.right+5, y: contentView.top+10, width: contentView.width-(profilePictureImageView1.right+5), height: imageSize/2.3)
                profilePictureImageView1.layer.cornerRadius = imageSize/3
                field.frame = CGRect(x: contentView.left+20, y: contentView.top+profilePictureImageView1.height+10, width: contentView.width-20, height: contentView.height-20)
                profilePictureImageView1.sd_setImage(with: url, completed: nil)
            }
            else {
                if videoURL != "nil" {
                    imageView.addSubview(videoView)
                    let size = contentView.height/8
                    videoView.tintColor = .systemCyan
                    videoView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
                    videoView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
                    videoView.widthAnchor.constraint(equalToConstant: size).isActive = true
                    videoView.heightAnchor.constraint(equalToConstant: size).isActive = true
                    
                }
                else {
                    videoView.removeFromSuperview()
                }
                imageView.sd_setImage(with: url, completed: nil)
                field.frame = CGRect(x: contentView.left, y: contentView.top, width: contentView.width, height: 120)
                imageView.frame = CGRect(x: contentView.left, y: field.bottom, width: contentView.width, height: contentView.height-120)
                profilePictureImageView1.isHidden = true
            }
        }
        else {
            contentView.addSubview(emptyField)
            emptyField.frame = CGRect(x: contentView.left, y: contentView.top, width: contentView.width, height: 120)
            emptyField.isHidden = false
            if playerType == "Coach" {
                emptyField.text = "Leave a review for your coach!"
                field.isHidden = true
            }
            else if playerType == "Player" {
                emptyField.text = "Go make a post!"
                field.isHidden = true
            }
        }
        
//        guard let captain = String(caption) else {
//            fatalError()
//        }
        
    }
}
