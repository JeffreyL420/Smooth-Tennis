//
//  PostCaptionCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import UIKit

protocol PostCaptionCollectionViewCellDelegate: AnyObject {
    func postCaptionCollectionViewCellDidTapCaptioon(_ cell: PostCaptionCollectionViewCell)
}

class PostCaptionCollectionViewCell: UICollectionViewCell {
    static let identifer = "PostCaptionCollectionViewCell"

    weak var delegate: PostCaptionCollectionViewCellDelegate?

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.isHighlighted = true
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        let color = UIColor(hexString: "#E1FFB1")
        contentView.backgroundColor = color
        contentView.layer.borderColor = UIColor(hexString: "#379237").cgColor
        contentView.layer.borderWidth = 2
        contentView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapCaption))
        label.addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc func didTapCaption() {
        delegate?.postCaptionCollectionViewCellDidTapCaptioon(self)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 1000, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], context: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = label.sizeThatFits(CGSize(width: contentView.bounds.size.width-12,
                                             height: contentView.bounds.size.height))
        label.frame = CGRect(x: 5, y: 3, width: size.width, height: size.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    func configure(with viewModel: PostCaptionCollectionViewCellViewModel) {
        let text = viewModel.caption
        let imageSize: CGFloat = contentView.height - (4 * 2)
        let height = estimateFrameForText(text: text ?? "").height + 30
        contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        contentView.frame.size.height = height
        contentView.bounds.size.height = height
        label.text = "\(viewModel.tag): \(viewModel.caption ?? "")"
    }
}
