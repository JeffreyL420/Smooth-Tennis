//
//  EditProfileViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/24/21.
//

import UIKit

class EditProfileViewController: UIViewController, UITextViewDelegate {

    public var completion: (() -> Void)?

    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    // Fields
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Bio?", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        return button
    }()
    
    let nameLabel: EditLabel = {
        let field = EditLabel()
        field.text = " Name: "
        return field
    }()
    
    let ageLabel: EditLabel = {
        let field = EditLabel()
        field.text = " Age:"
        return field
    }()
    
    
    let experienceLabel: EditLabel = {
        let field = EditLabel()
        field.text = " Experience:"
        return field
    }()
    
    let locationLabel: EditLabel = {
        let field = EditLabel()
        field.text = " Location:"
        return field
    }()
    

    
    
    let bioLabel: EditLabel = {
        let field = EditLabel()
        field.text = " Bio:"
        return field
    }()
    
    let nameField: IGTextView = {
        let field = IGTextView()
        field.autocorrectionType = .no
        field.text = "Please write your name"
        field.font = .systemFont(ofSize: 16)
        field.accessibilityIdentifier = "name"
        field.focusGroupIdentifier = "Please write your name"
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    let ageField: IGTextView = {
        let field = IGTextView()
        field.text = "Fill in your age"
        field.autocorrectionType = .no
        field.font = .systemFont(ofSize: 16)
        field.accessibilityIdentifier = "age"
        field.focusGroupIdentifier = "Fill in your age"
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    let locationField: IGTextView = {
        let field = IGTextView()
        field.accessibilityIdentifier = "location"
        field.font = .systemFont(ofSize: 16)
        field.focusGroupIdentifier = "Fill in your state and country e.g. CA, America"
        field.text = "Fill in your state and country e.g. CA, America"
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    let experienceField: IGTextView = {
        let field = IGTextView()
        field.accessibilityIdentifier = "experience"
        field.font = .systemFont(ofSize: 16)
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.focusGroupIdentifier = "Fill in your years of playing/coaching"
        field.text = "Fill in your years of playing/coaching"
        return field
    }()

    private let bioTextView: IGTextView = {
        let textView = IGTextView()
        textView.accessibilityIdentifier = "bio"
        textView.focusGroupIdentifier = "Include a basic background if you'd like and social media accounts for players to reach out to."
        textView.autocorrectionType = .no
        textView.text = "Include a basic background if you'd like and social media accounts for players to reach out to."
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.font = UIFont(name: "Helvetica Neue", size: 18)
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }()
    
    private let nameLblCount: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 10
        label.paddingRight = 10
        label.text = ""
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.restorationIdentifier = "20"
        return label
    }()
    
    private let ageLblCount: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 10
        label.paddingRight = 10
        label.text = ""
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.restorationIdentifier = "10"
        return label
    }()
    
    private let experienceLblCount: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 10
        label.paddingRight = 10
        label.text = ""
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.restorationIdentifier = "10"
        return label
    }()
    
    private let locationLblCount: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 10
        label.paddingRight = 10
        label.text = ""
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.restorationIdentifier = "30"
        return label
    }()
    
    private let bioLblCount: UILabel = {
        let label = PaddingLabel()
        label.paddingLeft = 10
        label.paddingRight = 10
        label.textAlignment = .right
        label.text = ""
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemRed
        label.restorationIdentifier = "250"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = .tertiarySystemBackground
        view.addSubview(nameField)
        view.addSubview(ageField)
        view.addSubview(experienceField)
        view.addSubview(bioTextView)
        view.addSubview(locationField)
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(locationLabel)
        view.addSubview(experienceLabel)
        view.addSubview(bioLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave))
        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(goDelete), for: .touchUpInside)
        view.addSubview(nameLblCount)
        view.addSubview(ageLblCount)
        view.addSubview(experienceLblCount)
        view.addSubview(locationLblCount)
        view.addSubview(bioLblCount)
        
        //bioLabel.delegate = self
        nameField.delegate = self
        ageField.delegate = self
        experienceField.delegate = self
        locationField.delegate = self
        bioTextView.delegate = self

        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.getUserInfo(username: username) { [weak self] info in
            DispatchQueue.main.async {
                if let info = info {
//                    self?.nameField.text = info.name
//
//
//                    if info.location == "" {
//                        self?.locationField.text = "  Location: "
//                    }
//                    else if info.location != "" {
//                        self?.locationField.text = info.location
//                    }
//
//
//                    if info.age == "" {
//                        self?.ageField.text = "  Age: "
//                    }
//                    else if info.name != "" {
//                        self?.ageField.text = info.age
//                    }
//
//
//                    if info.experience == "" {
//                        self?.experienceField.text = "  Experience: "
//                    }
//                    else if info.name != "" {
//                        self?.experienceField.text = info.experience
//                    }
//
//                    if info.bio == "" {
//                        self?.bioTextView.text = "  Bio: "
//                    }
//                    else if info.name != "" {
//                        self?.bioTextView.text = info.bio
//                    }
                    if info.bio == "" {
                        self?.bioTextView.text = "Include a basic background if you'd like and social media accounts for players to reach out to."
                    }
                    else {
                        self?.bioTextView.text = info.bio
                    }
                    
                    if info.experience == "" {
                        self?.experienceField.text = "Fill in your years of playing/coaching"
                    }
                    else {
                        self?.experienceField.text = info.experience
                    }
                    
                    if info.age == "" {
                        self?.ageField.text = "Fill in your age"
                    }
                    else {
                        self?.ageField.text = info.age
                    }
                    
                    if info.location == "" {
                        self?.locationField.text = "Fill in your state and country e.g. CA, America"
                    }
                    else {
                        self?.locationField.text = info.location
                    }
                    
                    if info.name == "" {
                        self?.nameField.text = "Please write your name"
                    }
                    else {
                        self?.nameField.text = info.name
                    }
                    
                    self?.textViewDidChange(self!.nameField, self!.nameLblCount)
                    self?.textViewDidChange(self!.ageField, self!.ageLblCount)
                    self?.textViewDidChange(self!.experienceField, self!.experienceLblCount)
                    self?.textViewDidChange(self!.locationField, self!.locationLblCount)
                    self?.textViewDidChange(self!.bioTextView, self!.bioLblCount)
                }
            }
        }
    
        observeKeyBoardChange()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.accessibilityIdentifier == "name" && nameField.text == "Please write your name" {
            nameField.text = ""
        }
        else if textView.accessibilityIdentifier == "age" && ageField.text == "Fill in your age" {
            ageField.text = ""
        }
        else if textView.accessibilityIdentifier == "experience" && experienceField.text == "Fill in your years of playing/coaching" {
            experienceField.text = ""
        }
        else if textView.accessibilityIdentifier == "location" && locationField.text == "Fill in your state and country e.g. CA, America" {
            locationField.text = ""
        }
        else if textView.accessibilityIdentifier == "bio" && bioTextView.text == "Include a basic background if you'd like and social media accounts for players to reach out to." {
            bioTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.accessibilityIdentifier == "name" && nameField.text == "" {
            nameField.text = "Please write your name"
           
        }
        else if textView.accessibilityIdentifier == "age" && ageField.text == "" {
            ageField.text = "Fill in your age"
        }
        else if textView.accessibilityIdentifier == "experience" && experienceField.text == "" {
            experienceField.text = "Fill in your years of playing/coaching"
        }
        else if textView.accessibilityIdentifier == "location" && locationField.text == "" {
            locationField.text = "Fill in your state and country e.g. CA, America"
        }
        else if textView.accessibilityIdentifier == "bio" && bioTextView.text == "" {
            bioTextView.text = "Include a basic background if you'd like and social media accounts for players to reach out to."
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var strlength = textView.text.count
        if textView.accessibilityIdentifier == "age" {
            if strlength > 10 {
                let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
                textView.text = String(textView.text[..<end])
                
                strlength -= 1
            }
            textViewDidChange(ageLblCount, strlength, ageField)
            
           
        }
        else if textView.accessibilityIdentifier == "name" {
            if strlength > 20 {
                let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
                textView.text = String(textView.text[..<end])
                
                strlength -= 1
            }
            textViewDidChange(nameLblCount, strlength, nameField)
            
        }
        else if textView.accessibilityIdentifier == "experience" {
            if strlength > 10 {
                let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
                textView.text = String(textView.text[..<end])
                
                strlength -= 1
            }
            textViewDidChange(experienceLblCount, strlength, experienceField)
            
            
        }
        else if textView.accessibilityIdentifier == "location" {
            if strlength > 30 {
                let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
                textView.text = String(textView.text[..<end])
                
                strlength -= 1
            }
               
            textViewDidChange(locationLblCount, strlength, locationField)
    
            
        }
        else if textView.accessibilityIdentifier == "bio" {
            if strlength > 250 {
                let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
                textView.text = String(textView.text[..<end])
                
                strlength -= 1
            }
            textViewDidChange(bioLblCount, strlength, bioTextView)
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView, _ textLabel: UILabel) {
        if textView.focusGroupIdentifier == textView.text {
            textLabel.text = "0/\(textLabel.restorationIdentifier!)"
        }
        else {
        let strlength = textView.text.count
        textLabel.text = "\(strlength)/\(textLabel.restorationIdentifier!)"
        }
        
    }
    
    func textViewDidChange(_ textLabel: UILabel, _ strLength: Int, _ textView: UITextView) {
        if textView.focusGroupIdentifier == textView.text {
            textLabel.text = "0/\(textLabel.restorationIdentifier!)"
        }
        else {
        textLabel.text = "\(strLength)/\(textLabel.restorationIdentifier!)"
        }
        
    }
    
    
    private func observeKeyBoardChange() {
        observer = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { _ in
            self.textViewDidChange(self.ageField)
            self.textViewDidChange(self.nameField)
            self.textViewDidChange(self.experienceField)
            self.textViewDidChange(self.locationField)
            self.textViewDidChange(self.bioTextView)
            //self.textViewDidChange(self.locationField, self.locationLblCount)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameLabel.frame = CGRect(x: 20, y: view.safeAreaInsets.top+20, width: view.width/5, height: 50)
        nameField.frame = CGRect(x: nameLabel.right+5,
                                 y: view.safeAreaInsets.top+20,
                                 width: view.width-view.width/3,
                                 height: 50)
        nameLblCount.frame = CGRect(x: (nameField.right-view.width/6), y: nameLabel.bottom+5, width: view.width/6, height: 10)
        
        ageLabel.frame = CGRect(x: 20, y: nameLabel.bottom+20, width: view.width/5, height: 50)
        ageField.frame = CGRect(x: ageLabel.right+5,
                                y: nameField.bottom+20,
                                 width: view.width-view.width/3,
                                 height: 50)
        ageLblCount.frame = CGRect(x: (ageField.right-view.width/6), y: ageField.bottom+5, width: view.width/6, height: 10)
        
        experienceLabel.frame = CGRect(x: 20, y: ageLabel.bottom+20, width: view.width/4, height: 50)
        experienceField.frame = CGRect(x: experienceLabel.right+5,
                                y: ageField.bottom+20,
                                 width: view.width-view.width/3,
                                 height: 50)
        experienceLblCount.frame = CGRect(x: (experienceField.right-view.width/6), y: experienceField.bottom+5, width: view.width/6, height: 10)
        
        locationLabel.frame = CGRect(x: 20, y: experienceLabel.bottom+20, width: view.width/4, height: 50)
        locationField.frame = CGRect(x: locationLabel.right+5, y: experienceField.bottom+20, width: view.width-view.width/3, height: 50)
        locationLblCount.frame = CGRect(x: (locationField.right-view.width/6), y: locationField.bottom+5, width: view.width/6, height: 10)
        
        bioLabel.frame = CGRect(x: 20, y: locationField.bottom+20, width: view.width/4, height: 50)
        bioTextView.frame = CGRect(x: 20,
                                   y: bioLabel.bottom+20,
                                   width: view.width-40,
                                   height: 150)
        bioLblCount.frame = CGRect(x: (bioTextView.right-view.width/6), y: bioTextView.bottom+5, width: view.width/6, height: 10)
        
        deleteButton.frame  = CGRect(x: 20, y: bioTextView.bottom+10, width: view.width/4, height: 40)
    }

    // Actions
    
    @objc func goDelete() {
        self.bioTextView.text = ""
    }

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapSave() {
        var name = String()
        var bio = String()
        var age = String()
        var experience = String()
        var location = String()
        if nameField.text == "Please write your name" {
            name = ""
        }
        else {
            name = (nameField.text)
        }
        
        if bioTextView.text == "Include a basic background if you'd like and social media accounts for players to reach out to." {
            bio = ""
        }
        else {
            bio = (bioTextView.text)
        }
        
        if ageField.text == "Fill in your age" {
            age = ""
        }
        else {
            age = (ageField.text)
        }
        
        if experienceField.text == "Fill in your years of playing/coaching" {
            experience = ""
        }
        else {
            experience = (experienceField.text)
        }
        
        if locationField.text == "Fill in your state and country e.g. CA, America" {
            location = ""
        }
        else {
            location = (locationField.text)
        }
       
        
        
        
        let newInfo = UserInfo(name: name, bio: bio, age: age, experience: experience, location: location)
        DatabaseManager.shared.setUserInfo(userInfo: newInfo) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.completion?()
                    self?.didTapClose()
                }
            }
        }
    }
}
