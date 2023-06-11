//
//  SignInHeaderView.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import UIKit

class SignInHeaderView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var gradientLayer: CALayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createGradient()
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGreen.cgColor, UIColor.systemYellow.cgColor]
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = layer.bounds
        imageView.frame = bounds
    }

}
