//
//  PointViewController.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/7/28.
//

import UIKit

final class PointButton: UIButton {
    
    //Will have to obtain a setTitle value from databasemanager at some point
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        clipsToBounds = false
        setTitle("0", for: .normal)
        titleLabel?.font = UIFont(name: "Times New Roman", size: 25.0)
        backgroundColor = .systemGreen
        setTitleColor(.systemTeal, for: .normal)
        layer.borderWidth = 2.0
        setImage(UIImage(systemName: "circle.circle"), for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10.0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //addTarget(self, action: #selector(presentPurchase), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
