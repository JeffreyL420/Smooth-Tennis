//
//  CommentBarView.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/25/21.
//

import UIKit

protocol CommentBarViewDelegate: AnyObject {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String)
    //func commentBarViewDidTapClear(_ commentBarView: CommentBarView)
}

final class CommentBarView: UIView, UITextViewDelegate{
                            //UITextFieldDelegate {

    weak var delegate: CommentBarViewDelegate?

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    private let textLabel: UILabel = {
        let textView = UILabel()
        textView.accessibilityIdentifier = "350"
        textView.tintColor = .systemRed
        textView.text = "0/350"
        textView.textAlignment = .center
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 10)
        return textView
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
        addSubview(textLabel)
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

    func textViewDidChange(_ textLabel: UILabel, _ strLength: Int) {
        textLabel.text = "\(strLength)/\(textLabel.accessibilityIdentifier!)"
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var strlength = textView.text.count
        if strlength > 350 {
            let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
            textView.text = String(textView.text[..<end])
            strlength -= 1
        }
        textViewDidChange(textLabel, strlength)
    }
    
    @objc func didTapComment() {
        guard let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        delegate?.commentBarViewDidTapDone(self, withText: text)
        field.resignFirstResponder()
        field.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let color = UIColor(hexString: "#C7F2A4")
        backgroundColor = color
        button.sizeToFit()
        button.frame = CGRect(x: width-button.width-6,
                              y: button.height-10,
                              width: button.width+4,
                              height: button.height)
        textLabel.frame = CGRect(x: width-button.width-6,
                                 y: button.bottom+5,
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
}
