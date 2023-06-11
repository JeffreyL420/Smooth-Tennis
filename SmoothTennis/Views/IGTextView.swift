//
//  IGTextView.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/17.
//

import UIKit

class IGTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        textColor = .lightGray
        layer.cornerRadius = 8
        layer.borderWidth = 1
        autocapitalizationType = .none
        text = "Give helpful feedback within 350 characters."
        isEditable = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
