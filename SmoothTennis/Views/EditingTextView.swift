//
//  EditingTextView.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/11/16.
//

import UIKit

class EditingTextView: UIView, UITextViewDelegate {

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    let ridButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "clear.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //button.setTitleColor(.link, for: .normal)
        return button
    }()

    let field: IGTextView = {
        let field = IGTextView()
        field.textContainer.maximumNumberOfLines = 0
        field.backgroundColor = .secondarySystemBackground
        return field
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(field)
        addSubview(button)
        addSubview(ridButton)
        field.delegate = self
        ridButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        backgroundColor = .tertiarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapClear() {
        field.resignFirstResponder()
        self.isHidden = true
    }

    @objc func didTapComment() {
        guard let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        field.resignFirstResponder()
        field.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let color = UIColor(hexString: "#C7F2A4")
        backgroundColor = color
        button.sizeToFit()
        button.frame = CGRect(x: width-button.width-6,
                              y: (height-button.height)/2,
                              width: button.width+4,
                              height: button.height)
        field.frame = CGRect(x: 2,
                             y: (height-55)/2,
                             width: width-button.width-12,
                             height: 70)
        let ridButtonSize = 20
        ridButton.frame = CGRect(x: 2, y: 2, width: ridButtonSize, height: ridButtonSize)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if field.textColor == .lightGray && field.isFirstResponder {
                field.text = nil
                field.textColor = .black
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        didTapComment()
        return true
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
