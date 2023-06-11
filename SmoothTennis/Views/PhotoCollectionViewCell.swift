//
//  PhotoCollectionViewCell.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/22/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        return imageView
    }()
    
    private let videoView: UIButton = {
        let imageView = UIButton()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "play"), for: .normal)
        imageView.tintColor = .systemCyan
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        imageView.layer.cornerRadius = 8
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        videoView.imageView?.image = nil
        videoView.tintColor = nil
    }

    func configure(with image: UIImage?, isVideo: Bool) {
        imageView.image = image
    }

    func configure(with url: URL?, isVideo: Bool) {
        imageView.sd_setImage(with: url, completed: nil)
        if isVideo {
            imageView.addSubview(videoView)
            let size = contentView.height/4
            imageView.isHidden = false
            videoView.tintColor = .systemCyan
            videoView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
            videoView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            videoView.widthAnchor.constraint(equalToConstant: size).isActive = true
            videoView.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        else {
            videoView.removeFromSuperview()
        }
    }
    
}
