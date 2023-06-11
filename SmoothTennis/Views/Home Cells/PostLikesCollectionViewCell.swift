//
//  PostLikesCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import UIKit

protocol PostLikesCollectionViewCellDelegate: AnyObject {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int)
}

class PostLikesCollectionViewCell: UICollectionViewCell {
    static let identifer = "PostLikesCollectionViewCell"

    private var index = 0

    weak var delegate: PostLikesCollectionViewCellDelegate?

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 3, width: self.frame.size.width, height: 5)
        bottomLine.backgroundColor = UIColor.black.cgColor
        contentView.layer.addSublayer(bottomLine)
        contentView.clipsToBounds = true
        let color = UIColor(hexString: "#C7F2A4")
        contentView.backgroundColor = color
//        contentView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapLabel))

        label.addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc func didTapLabel() {
        delegate?.postLikesCollectionViewCellDidTapLikeCount(self, index: index)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: 0, width: contentView.width-12, height: contentView.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    func configure(with viewModel: PostLikesCollectionViewCellViewModel, index: Int) {
        self.index = index
        let users = viewModel.likers
        //label.text = "\(users.count) Thumbs Up"
    }
}
