//
//  EditLabel.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/9.
//

import UIKit

class EditLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.masksToBounds = true
        
        backgroundColor = .systemGreen
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError()
    }


}
