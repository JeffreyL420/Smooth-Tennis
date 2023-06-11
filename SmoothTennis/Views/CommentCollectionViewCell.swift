//
//  CommentCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/25/21.
//

import UIKit

//protocol CommentCollectionViewCellDelegate: AnyObject {
//    func commentCollectionViewCellDidTapComment(_ cell: CommentCollectionViewCell, index: Int)
//}

protocol CommentCollectionViewCellDelegate: AnyObject {
    func commentCollectionViewDidTapComment(_ cell: CommentCollectionViewCell)
    func commentCollectionViewDidTapUsername(_ cell: CommentCollectionViewCell, username: String)
    func commentCollectionViewDidTapImage(_ cell: CommentCollectionViewCell, username: String)
}

class CommentCollectionViewCell: UICollectionViewCell {
    
    private var scrolling = 0
    
    static let identifier = "CommentCollectionViewCell"
    
    private var index = 0
    
    private var Bool = false
    
    private let bottomLine = CALayer()
    //weak var delegate: CommentCollectionViewCellDelegate?
    
    weak var delegate: CommentCollectionViewCellDelegate?
    
    var transferUsername = String()
    
    let field: UITextView = {
        let field = UITextView()
        field.isEditable = false
        field.isScrollEnabled = true
        field.showsVerticalScrollIndicator = true
        field.textContainer.maximumNumberOfLines = 0
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 14)
//        field.textContainer.lineBreakMode = .byTruncatingTail
        return field
    }()
    
//    let bubbleView: UIView = {
//        let view = UIView()
//        let color = UIColor(hexString: "#C7F2A4")
//        view.backgroundColor = color
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let profilePictureImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let goodResponseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "topResponse")
//        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    let usernamelabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.isUserInteractionEnabled = true
//        label.backgroundColor = .red
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        label.isUserInteractionEnabled = true
//        label.backgroundColor = .red
        return label
    }()
    
    let amountTopCommentsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.isHidden = true
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        return label
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
//        label.backgroundColor = .red
        return label
    }()
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: contentView.width-17, height: 100000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        //assignBackground()
        let color = UIColor(hexString: "#C7F2A4")
        contentView.backgroundColor = color
        
        //bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //bubbleView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        //bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -2).isActive = true

    }
    
    func layout() {
        contentView.translatesAutoresizingMaskIntoConstraints = true
        if UserDefaults.standard.bool(forKey: "Transported") == true //supposed to be true
        {
            contentView.layer.borderColor = UIColor.systemRed.cgColor
            contentView.layer.borderWidth = 2
        }
        else {
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0
        }
        //let bottomLine = CALayer()
        //bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 5)
        //bottomLine.backgroundColor = UIColor.black.cgColor
        //contentView.layer.addSublayer(bottomLine)
        //contentView.layer.borderColor = UIColor.black.cgColor
        //contentView.addSubview(bubbleView)
        contentView.addSubview(field)
        contentView.addSubview(usernamelabel)
        contentView.addSubview(profilePictureImageView1)
        contentView.addSubview(goodResponseImage)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountTopCommentsLabel)
        let tap3 = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapImage))
        profilePictureImageView1.addGestureRecognizer(tap3)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapUserComment))
        //contentView.addGestureRecognizer(tap)
        self.addGestureRecognizer(tap)
        //profilePictureImageView1.addGestureRecognizer(tap)
       
        let tap2 = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapUsernameComment))
        usernamelabel.addGestureRecognizer(tap2)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func assignBackground(){
        let background = UIImage(named: "BackgroundImage")
        var imageView : UIImageView!
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.alpha = 0.3
        imageView.center = contentView.center
        contentView.addSubview(imageView)
        self.contentView.sendSubviewToBack(imageView)
    }
    
    @objc func didTapUsernameComment() {
        guard usernamelabel.text == "Instruction:" ||
                UserDefaults.standard.bool(forKey: "Transported") == true
        else {
            delegate?.commentCollectionViewDidTapUsername(self, username: transferUsername)
            return
        }
    }
    @objc func didTapUserComment() {
        guard label.text == "*Coaches, please leave helpful comments to help players with their problems. Please try to write less than 100 words*" ||
              UserDefaults.standard.bool(forKey: "Transported") == false //supposed to be false
        else {
            delegate?.commentCollectionViewDidTapComment(self)
//            if selectedTimes != 1 {
//                delegate?.commentCollectionViewDeletePreviousSelection(self, index: mostRecentIndex)
//            }
            return
        }
    }
    
    @objc func didTapImage() {
        guard profilePictureImageView1.image == UIImage(named: "logo") ||  UserDefaults.standard.bool(forKey: "Transported") == true else {
            delegate?.commentCollectionViewDidTapImage(self, username: transferUsername)
            return
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 4, width: self.frame.size.width, height: 5)
        let imagePadding: CGFloat = 4
        let imageSize: CGFloat = 140 - (imagePadding * 2)
        usernamelabel.frame = CGRect(x: imageSize/2+60, y: 25, width: contentView.width-profilePictureImageView1.width-240, height: 15)
        amountTopCommentsLabel.frame = CGRect(x: self.width/1.5, y: 25, width: self.width/1.5, height: 20)
        goodResponseImage.frame = CGRect(x: 20, y: 15, width: imageSize/5, height: imageSize/4.3)
        profilePictureImageView1.frame = CGRect(x: imagePadding+60, y: 0, width: imageSize/2, height: imageSize/2)
        profilePictureImageView1.layer.cornerRadius = imageSize/2
//        profilePictureImageView.frame = CGRect(x: 5, y: 3, width: 20, height: 15)
        //label.frame = CGRect(x: 10, y: usernamelabel.bottom, width: contentView.width-10, height: contentView.height)
        field.frame = CGRect(x: 10, y: usernamelabel.bottom+20, width: contentView.width-10, height: contentView.height-contentView.height/10)
        dateLabel.frame = CGRect(x: contentView.width-160, y: contentView.bottom-20, width: 160, height: 15)
        //height originally just conentView.height
    }
    
    //maybe unnessecary
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        usernamelabel.text = nil
        profilePictureImageView1.image = nil
        field.text = nil
        amountTopCommentsLabel.text = nil
        amountTopCommentsLabel.isHidden = true
        dateLabel.text = nil
        
        //bubbleView.backgroundColor = nil
        //goodResponseImage.image = nil
    }
    
    func layoutHeight(with x: CGFloat) {
        if contentView.height == 140.0 {
            contentView.heightAnchor.constraint(equalToConstant: (height+contentView.height/1.2)-10).isActive = true
            contentView.layer.addSublayer(bottomLine)
        }
    }
    
    func configure(
        with model: Comment2,
        index: Int,
        topResponse: Bool,
        amountTopComments: Int
//        height: CGFloat
    ) {
        var text = model.comment
        var test = String(text.filter { !"\n".contains($0) })

        let height = estimateFrameForText(text: test).height

        let imageSize: CGFloat = contentView.height

        print(contentView.height)
        //layoutHeight(with: height)
        if contentView.height == 140.0 {
            let color = UIColor(hexString: "#FF597B")
            bottomLine.backgroundColor = color.cgColor
            contentView.layer.addSublayer(bottomLine)
            contentView.heightAnchor.constraint(equalToConstant: (height+contentView.height/1.2)-10).isActive = true
        }
        
        self.index = index
        transferUsername = model.username
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let attributeString = NSAttributedString(string: "\(model.username)", attributes: underlineAttribute)
        usernamelabel.attributedText = attributeString
        if model.dateString == "nil" {
            dateLabel.isHidden = true
        }
        else {
            dateLabel.isHidden = false
            dateLabel.text = model.dateString
        }
        field.text = test
        if model.usernameProfilePhoto.absoluteString == "nil" {
            profilePictureImageView1.image = UIImage(named: "logo")
        }
        
        else {
            profilePictureImageView1.sd_setImage(with: model.usernameProfilePhoto, completed: nil)
        }
        if model.amountTopComments >= 0 {
            amountTopCommentsLabel.isHidden = false
            amountTopCommentsLabel.text = "Top Comments: \(amountTopComments)"
            DatabaseManager.shared.getCoachCommentAmount(username: model.username) { [self] amount in
                amountTopCommentsLabel.text = "Top Comments: \(amount)"
            }
        }
        else {
            amountTopCommentsLabel.isHidden = true
        }
        
        guard model.topResponse == true else {
            goodResponseImage.isHidden = true
            return
        }
        goodResponseImage.isHidden = false
        
        
    }
   
}

