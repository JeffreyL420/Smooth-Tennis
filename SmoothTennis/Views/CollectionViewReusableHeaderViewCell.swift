//
//  CollectionViewReusableHeaderViewCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/6.
//

import UIKit


class CollectionViewReusableHeaderViewCell: UICollectionViewCell {
    static let identifier = "HeaderReusableViewCell"
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Times New Roman", size: 30)
        label.backgroundColor = .systemBlue
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        let color = UIColor(hexString: "#82CD47")
        label.textColor = color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellLabel.text = nil
    }
////    private let cellImageView: UIImageView = {
////        let cellImageView = UIImageView()
////        cellImageView.layoutIfNeeded()
////        cellImageView.layer.cornerRadius = cellImageView.frame.height/2
////        return cellImageView
////    }()
//
    override func layoutSubviews() {
        super.layoutSubviews()
        cellLabel.sizeToFit()
        //What is wrong here?
        //cellLabel.frame = CGRect(x: 0, y: contentView.height/3, width: self.width/2, height: contentView.height-10)
    }

    func configure(with technique: String) {
        cellLabel.text = technique
        let size: CGSize = cellLabel.text!.size(withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        cellLabel.frame = CGRect(x: 0, y: contentView.height/3, width: size.width+40, height: contentView.height-10)
        
    }
}
