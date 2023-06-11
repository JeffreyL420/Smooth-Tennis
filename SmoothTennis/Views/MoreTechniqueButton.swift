//
//  MoreTechniqueButton.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/11.
//

import UIKit

class MoreTechniqueButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        layer.masksToBounds = true
        layer.borderWidth = 1
        let color = UIColor(hexString: "#82CD47")
        layer.borderColor = color.cgColor
        setTitleColor(color, for: .normal)
        setTitle("Hi", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
