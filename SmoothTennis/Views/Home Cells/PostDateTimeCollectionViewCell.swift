//
//  PostDateTimeCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import UIKit

class PostDateTimeCollectionViewCell: UICollectionViewCell {
    static let identifer = "PostDateTimeCollectionViewCell"

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 3, width: self.frame.size.width, height: 5)
        bottomLine.backgroundColor = UIColor.black.cgColor
        contentView.layer.addSublayer(bottomLine)
        contentView.clipsToBounds = true
        let color = UIColor(hexString: "#B6E388")
        contentView.backgroundColor = color
        contentView.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: 0, width: contentView.width-12, height: contentView.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    func configure(with viewModel: PostDatetimeCollectionViewCellViewModel) {
        let date = viewModel.date
        label.text = .date(from: date)
    }
}
