//
//  MenuBar.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/4.
//

import UIKit

class MenuBar: UIView {
    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor.systemGreen
//        cv.dataSource = self
//        cv.delegate = self
//        return cv
//    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.image = UIImage(systemName: "circle.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Waiting..."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(label)
        configureLabelAmount()
//        addSubview(collectionView)
        backgroundColor = UIColor.systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: self.width/3, y: 0, width: self.width/10, height: self.height)
        label.frame = CGRect(x: self.imageView.right, y: 0, width: self.width/5, height: self.height)
//        collectionView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    func configureLabelAmount() {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        DatabaseManager.shared.getPointsAmount(for: username) { amount in
            self.label.text =  "\(Int(amount))"
        }
    }

//    @objc func didTapToPurchase() {
//        let vc = PurchaseViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
