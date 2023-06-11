//
//  PlayerTrackCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/11/14.
//

import UIKit

protocol PlayerTrackCollectionViewCellDelegate: AnyObject {
    func trackingCollectionViewCellDidTapImage(_ cell: PlayerTrackCollectionViewCell, postOwner: String, postID: String, postCaption: String, postDateCheck: String, postLikers: [String], postTag: String, postImageURL: String, postVideoURL: String, Date: String, postDateCheckTrack: String)
}

class PlayerTrackCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PlayerTrackCollectionViewCellDelegate?
    
    private var postOwner = String()
    
    private var postID = String()
    
    private var postCaption = String()
    
    private var postDateCheck = String()
    
    private var postLikers = [String]()
    
    private var postTag = String()
    
    private var postImageURL = String()
    
    private var postVideoURL = String()
    
    private var postDate = String()
    
    private var postDateCheckTrack = String()
    
    static let identifier = "PlayerTrackCollectionViewCell"
    
    private var correctedName = ""

    private let myLabel: UILabel = {
        let myLabel = UILabel()
        //myLabel.backgroundColor = .systemGreen
        myLabel.numberOfLines = 0
        myLabel.textColor = .label
        //myLabel.layer.borderColor = UIColor.black.cgColor
        //myLabel.font = UIFont.systemFont(ofSize: 12)
        //myLabel.layer.borderWidth = 1
        myLabel.clipsToBounds = true
        //myLabel.layer.cornerRadius = 8
        return myLabel
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let background: UIView = {
        let imageView = UIView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGreen
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let dateLabel: PaddingLabel = {
        let myLabel = PaddingLabel()
        myLabel.textAlignment = .center
        myLabel.backgroundColor = .systemCyan
        myLabel.numberOfLines = 0
        myLabel.textColor = .black
        myLabel.layer.borderColor = UIColor.black.cgColor
        myLabel.layer.borderWidth = 1
        myLabel.clipsToBounds = true
        myLabel.layer.cornerRadius = 8
        return myLabel
    }()
    
    private let videoView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "play")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.backgroundColor = .white
        imageView.isHidden = true
        return imageView
    }()
    
    
    
//    private var myImage: UIImageView = {
//        let myImage = UIImageView()
//        return myImage
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(background)
        contentView.addSubview(myLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageView)
        imageView.addSubview(videoView)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
//        imageView.layer.borderColor = nil
//        imageView.layer.borderWidth = 0
        dateLabel.text = nil
        dateLabel.layer.borderColor = nil
        dateLabel.layer.borderWidth = 0
        myLabel.text = nil
        videoView.image = UIImage(named: "play")
        //videoView.isHidden = false
        videoView.backgroundColor = .white
        //background.backgroundColor = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame.size.height = 200.0
        dateLabel.frame = CGRect(x: 5, y: 5, width: contentView.width-10, height: contentView.height-(contentView.height-20))
        myLabel.frame = CGRect(x: 20, y: dateLabel.bottom+5, width: contentView.width*2/3-10, height: contentView.height-30)
        background.frame = CGRect(x: 10, y: dateLabel.bottom+5, width: contentView.width-20, height: contentView.height-40)
        imageView.frame = CGRect(x: myLabel.right+10, y: dateLabel.bottom+10, width: contentView.width/4, height: myLabel.height-20)
        videoView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        videoView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        videoView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        videoView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func didTapImage() {
        delegate?.trackingCollectionViewCellDidTapImage(self, postOwner: postOwner, postID: postID, postCaption: postCaption, postDateCheck: postDateCheck, postLikers: postLikers, postTag: postTag, postImageURL: postImageURL, postVideoURL: postVideoURL, Date: postDate, postDateCheckTrack: postDateCheckTrack) //add all in
    }
    
    
    func configure(with model: PlayerComment) {
//        if model.username.count >= 21 {
//            let index = model.username.index(model.username.startIndex, offsetBy: 18)
//            correctedName = model.username[..<index] + "..."
//        }
//        else {
//            correctedName = model.username
//        }
        
        postOwner = model.thePostOwner
        postID = model.thePostID
        postCaption = model.caption
        postDateCheck = model.dateCheck
        postLikers = model.likers
        postTag = model.tag
        postImageURL = model.thePostImage
        postVideoURL = model.thePostVideo
        postDate = model.dateString
        postDateCheckTrack = model.dateCheckTrack
        
//        myLabel.text = " Interacted with: \(model.username) \n Method: \(model.method) \n Points: \(model.points) \n Date: \(model.dateString) \n Post: \(model.thePostImage)
        
        var whoSelected = String()
        dateLabel.text = model.dateString
        model.whoSelected.forEach { username in
            whoSelected += username + ", "
        }
        let start = whoSelected.index(whoSelected.startIndex, offsetBy: 0)
        let end = whoSelected.index(whoSelected.endIndex, offsetBy: -1)
        let range = start..<end
        let whoSelected2 = whoSelected[range]
        myLabel.text = "On this post, you selected: \(whoSelected2) as Top Responses."
        guard model.thePostImage == "None" else {
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 1
            imageView.sd_setImage(with: URL(string: model.thePostImage))
            if model.thePostVideo != "nil" {
                videoView.isHidden = false
            }
            return
        }
    }
    

}
