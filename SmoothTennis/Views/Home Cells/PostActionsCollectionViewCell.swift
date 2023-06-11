//
//  PostActionsCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate: AnyObject {
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int)
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int)
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int)
}

class PostActionsCollectionViewCell: UICollectionViewCell {
    static let identifer = "PostActionsCollectionViewCell"

    private var index = 0

    weak var delegate: PostActionsCollectionViewCellDelegate?

    private var isLiked = false

//    private let likeButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .label
//        let image = UIImage(systemName: "suit.heart",
//                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
//        button.setImage(image, for: .normal)
//        return button
//    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "message",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let commentAmount: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 5
        label.paddingRight = 5
        label.backgroundColor = .systemGreen
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    
    private let postStatus: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 5
        label.paddingRight = 5
        label.backgroundColor = .systemGreen
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()

//    private let shareButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .label
//        let image = UIImage(systemName: "paperplane",
//                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
//        button.setImage(image, for: .normal)
//        return button
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        let color = UIColor(hexString: "#C7F2A4")
        contentView.backgroundColor = color
        //contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(commentAmount)
        contentView.addSubview(postStatus)
        //contentView.addSubview(shareButton)

        // Actions
        //likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        //shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

//    @objc func didTapLike() {
//        if self.isLiked {
//            let image = UIImage(systemName: "suit.heart",
//                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
//            likeButton.setImage(image, for: .normal)
//            likeButton.tintColor = .label
//        }
//        else {
//            let image = UIImage(systemName: "suit.heart.fill",
//                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
//            likeButton.setImage(image, for: .normal)
//            likeButton.tintColor = .systemRed
//        }
//
//        delegate?.postActionsCollectionViewCellDidTapLike(self,
//                                                          isLiked: !isLiked,
//                                                          index: index)
//        self.isLiked = !isLiked
//    }

    @objc func didTapComment() {
        delegate?.postActionsCollectionViewCellDidTapComment(self, index: index)
    }

    @objc func didTapShare() {
        delegate?.postActionsCollectionViewCellDidTapShare(self, index: index)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.height/1.15
        //likeButton.frame = CGRect(x: 10, y: (contentView.height-size), width: size, height: size)
        commentButton.frame = CGRect(x: 10, //originally likeButton.right+12
                                     y: (contentView.height-size), width: size, height: size)
        commentAmount.frame = CGRect(x: commentButton.right+5, y: (contentView.height-size), width: size*4.5, height: size)
        postStatus.frame = CGRect(x: commentAmount.right+5, y: (contentView.height-size), width: size*4.5, height: size)
        //shareButton.frame = CGRect(x: commentButton.right+12, y: (contentView.height-size), width: size, height: size)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(
        with viewModel: PostActionsCollectionViewCellViewModel,
        index: Int,
        with numberComments: Int,
        with status: Bool
    ) {
        self.index = index
        commentAmount.text = String(viewModel.commentAmount) + " feedbacks"
        if viewModel.status == false {
            postStatus.text = "Closed"
            postStatus.backgroundColor = .systemRed
            return
        }
        if viewModel.status == true {
            postStatus.text = "Open"
            postStatus.backgroundColor = .systemYellow
        }
        

    }
}
