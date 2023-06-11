//
//  CollectionViewReusableFooterViewCell.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/11.
//

import UIKit

protocol CollectionViewFooterCellDelegate: AnyObject {
    func exploreCollectionViewDidTapCategory(_ cell: CollectionViewReusableFooterViewCell, wantedIndex: Int)
}
class CollectionViewReusableFooterViewCell: UICollectionViewCell {
    static let identifier = "FooterReusableViewCell"

    private var index = 0
    
    weak var delegate: CollectionViewFooterCellDelegate?
    
    private let moreButton: MoreTechniqueButton = {
        let button = MoreTechniqueButton()
        let color = UIColor(hexString: "#2192FF")
        button.backgroundColor = color
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height-5, width: self.frame.size.width, height: 5)
        bottomLine.backgroundColor = UIColor.systemGreen.cgColor
        layer.addSublayer(bottomLine)
        layer.borderColor = UIColor.systemGreen.cgColor
        //addSubview(cellLabel)
        addSubview(moreButton)
        //moreButton.center.y = self.contentView.center.y
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        //moreButton.addTarget(self, action: #selector(openUpPostViewController), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //moreButton.setTitle(nil, for: .normal)
        
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
        moreButton.sizeToFit()
        //What is wrong here?
        moreButton.frame = CGRect(x: self.width/4, y: contentView.height/5, width: self.width/2, height: contentView.height/2)
    }
    

    func configure(with technique: String) {
        moreButton.setTitle(technique, for: .normal)
        //cellLabel.text = technique
    }
    
    @objc func didTapMore() {
        if moreButton.currentTitle == "MORE FOREHAND" {
            index = 0
        }
        else if moreButton.currentTitle == "MORE BACKHAND" {
            index = 1
        }
        else if moreButton.currentTitle == "MORE VOLLEY" {
            index = 2
        }
        else if moreButton.currentTitle == "MORE SLICE" {
            index = 3
        }
        else if moreButton.currentTitle == "MORE SMASH" {
            index = 4
        }
        else if moreButton.currentTitle == "MORE DROP SHOT" {
            index = 5
        }
        else if moreButton.currentTitle == "MORE SERVE" {
            index = 6
        }
        delegate?.exploreCollectionViewDidTapCategory(self, wantedIndex: index)
    }
}
