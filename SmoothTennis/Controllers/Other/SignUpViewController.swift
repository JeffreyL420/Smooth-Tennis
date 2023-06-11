//
//  SignUpViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import SafariServices
import UIKit

public var playerType = ""

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // Subviews
    
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private var photoType = String()
    
    public var playerLevel = ""

    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    private let certificateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "doc.text.magnifyingglass")
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.isHidden = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()

    private let usernameField: IGTextView = {
        let field = IGTextView()
        field.isEditable = true
        field.text = "Username"
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let usernameLblCount: UILabel = {
        let field = UILabel()
        field.text = "0/20"
        field.accessibilityIdentifier = "username"
        field.font = UIFont.boldSystemFont(ofSize: 12)
        field.restorationIdentifier = "20"
        return field
    }()
    
    private let certificateLabel: UILabel = {
        let field = UILabel()
        field.text = "Enter Certificate Image"
        field.translatesAutoresizingMaskIntoConstraints = false
        //field.clipsToBounds = true
        field.accessibilityIdentifier = "username"
        field.isHidden = true
        field.font = UIFont.boldSystemFont(ofSize: 12)
        field.restorationIdentifier = "20"
        field.textAlignment = .center
        return field
    }()
    

    private let emailField: IGTextView = {
        let field = IGTextView()
        field.isEditable = true
        field.text = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.autocorrectionType = .no
        return field
    }()

    private let passwordField: IGTextView = {
        let field = IGTextView()
        field.isEditable = true
        field.text = "Create Password"
        field.font = UIFont.boldSystemFont(ofSize: 16)
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        return field
    }()

    private let warningField: PaddingLabel = {
        let field = PaddingLabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "This username is already in use", attributes: underlineAttribute)
        field.attributedText = underlineAttributedString
        field.textColor = .systemRed
        field.font = UIFont.systemFont(ofSize: 10)
        field.isHidden = true
        return field
    }()

    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Terms and Conditions", for: .normal)
        return button
    }()

    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Privacy Policy", for: .normal)
        return button
    }()
    
    private let coachButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Coach", for: .normal)
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let playerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Player", for: .normal)
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let beginnerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Beginner", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    private let intermediateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Intermediate", for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        
        return button
    }()
    
    private let advancedButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Advanced", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()

    public var completion: (() -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        addSubviews()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        addButtonActions()
        addImageGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 90

        profilePictureImageView.frame = CGRect(
            x: (view.width - imageSize)/2,
            y: view.safeAreaInsets.top + 15,
            width: imageSize,
            height: imageSize
        )

        usernameField.frame = CGRect(x: 25, y: profilePictureImageView.bottom+20, width: view.width-50, height: 50)
        usernameLblCount.frame = CGRect(x: usernameField.right-40, y: usernameField.bottom-10, width: 40, height: 30)
        emailField.frame = CGRect(x: 25, y: usernameField.bottom+10, width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom+10, width: view.width-50, height: 50)
        signUpButton.frame = CGRect(x: 35, y: passwordField.bottom+10, width: view.width-70, height: 50)
        warningField.frame = CGRect(x: 25, y: usernameField.top-10, width: view.width-50, height: 10)
        ///temporarily remove for effect
        termsButton.frame = CGRect(x: 35, y: signUpButton.bottom+10, width: view.width-70, height: 40)
        privacyButton.frame = CGRect(x: 35, y: termsButton.bottom+10, width: view.width-70, height: 40)
       
        playerButton.frame = CGRect(x: 35, y: privacyButton.bottom+10, width: view.width-70, height: 40)
        coachButton.frame = CGRect(x: 35, y: playerButton.bottom+10, width: view.width-70, height: 40)
        beginnerButton.frame = CGRect(x: 45, y: coachButton.bottom+20, width: view.width-70, height: 40)
        intermediateButton.frame = CGRect(x: 60, y: beginnerButton.bottom+10, width: view.width-70, height: 40)
        advancedButton.frame = CGRect(x: 50, y: intermediateButton.bottom+10, width: view.width-70, height: 40)
        
        certificateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        certificateLabel.centerYAnchor.constraint(equalTo: coachButton.bottomAnchor, constant: 20).isActive = true
        certificateLabel.widthAnchor.constraint(equalToConstant: view.width/2).isActive = true
        certificateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        certificateImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        certificateImage.centerYAnchor.constraint(equalTo: certificateLabel.bottomAnchor, constant: 80).isActive = true
        certificateImage.widthAnchor.constraint(equalToConstant: view.width-70).isActive = true
        certificateImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
    }

    private func addSubviews() {
        view.addSubview(profilePictureImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(warningField)
        
        ///temporarily remove for effect
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        
        view.addSubview(playerButton)
        view.addSubview(coachButton)
        view.addSubview(beginnerButton)
        view.addSubview(intermediateButton)
        view.addSubview(advancedButton)
        view.addSubview(certificateImage)
        view.addSubview(certificateLabel)
        view.addSubview(usernameLblCount)
    }
    
    private func addPlayerSubViews() {
        
        beginnerButton.isHidden = false
        intermediateButton.isHidden = false
        advancedButton.isHidden = false
    }
    
    private func addCoachSubViews() {
        
        certificateImage.isHidden = false
        certificateLabel.isHidden = false
    }
    
    private func hideCoachSubViews() {
        certificateImage.isHidden = true
        certificateLabel.isHidden = true
    }
    
    private func hidePlayerSubViews() {
        beginnerButton.isHidden = true
        intermediateButton.isHidden = true
        advancedButton.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var strlength = textView.text.count
        if textView == usernameField {
            if strlength > 20 {
                let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
                textView.text = String(textView.text[..<end])
                
                strlength -= 1
            }
            self.textViewDidChange(usernameLblCount, strlength)
        }
       
    }
    
    func textViewDidChange(_ textLabel: UILabel, _ strLength: Int) {
        textLabel.text = "\(strLength)/\(textLabel.restorationIdentifier!)"
        
    }

    private func addImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tap)
    }

    private func addButtonActions() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        //privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        playerButton.addTarget(self, action: #selector(didTapPlayer), for: .touchUpInside)
        coachButton.addTarget(self, action: #selector(didTapCoach), for: .touchUpInside)
        beginnerButton.addTarget(self, action: #selector(didTapBeg), for: .touchUpInside)
        intermediateButton.addTarget(self, action: #selector(didTapInt), for: .touchUpInside)
        advancedButton.addTarget(self, action: #selector(didTapAd), for: .touchUpInside)
        let tap2 =  UITapGestureRecognizer(target: self, action: #selector(didTapCertificateImage))
        certificateImage.addGestureRecognizer(tap2)
    }
    
    private func observeKeyBoardChange() {
        observer = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { _ in
            self.textViewDidChange(self.passwordField)
            //self.textViewDidChange(self.locationField, self.locationLblCount)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == usernameField {
            
            if passwordField.text == "" {
                passwordField.textColor = UIColor.lightGray
                passwordField.text = "Create Password"
            }
            if emailField.text == "" {
                emailField.textColor = UIColor.lightGray
                emailField.text = "Email Address"
            }
        }
        
        else if textView == passwordField {
            
            if usernameField.text == "" {
                usernameField.textColor = UIColor.lightGray
                usernameField.text = "Username"
            }
            if emailField.text == "" {
                emailField.textColor = UIColor.lightGray
                emailField.text = "Email Address"
            }
            
        }
        else if textView == emailField {
            
            if passwordField.text == "" {
                passwordField.textColor = UIColor.lightGray
                passwordField.text = "Create Password"
            }
            if usernameField.text == "" {
                usernameField.textColor = UIColor.lightGray
                usernameField.text = "Username"
            }
        }
        if textView.textColor == .lightGray && textView.isFirstResponder {
                textView.text = nil
                textView.textColor = .black
            }
    }

    // MARK: - Actions
    
    @objc func didTapPlayer() {
        addPlayerSubViews()
        hideCoachSubViews()
        if coachButton.imageView?.image == UIImage(named: "checked") {
            coachButton.isHidden = true
            playerButton.setImage(UIImage(named: "checked"), for: .normal)
            coachButton.setImage(UIImage(named: "unchecked"), for: .normal)
            playerButton.setTitle("Player", for: .normal)
        }
        else {
            if playerButton.imageView?.image == UIImage(named: "unchecked") {
                playerButton.setImage(UIImage(named: "checked"), for: .normal)
                playerButton.setTitle("Player", for: .normal)
                coachButton.isHidden = true
                playerType = "Player"
            }
            else if playerButton.imageView?.image == UIImage(named: "checked") {
                hidePlayerSubViews()
                coachButton.isHidden = false
                playerButton.setImage((UIImage(named: "unchecked")), for: .normal)
                playerType = ""
            }
        }
    }
    
    @objc func didTapCoach() {
        addCoachSubViews()
        hidePlayerSubViews()
        if playerButton.imageView?.image == UIImage(named: "checked") {
            playerButton.isHidden = true
            coachButton.setImage((UIImage(named: "checked")), for: .normal)
            playerButton.setImage((UIImage(named: "unchecked")), for: .normal)
            coachButton.setTitle("Coach", for: .normal)

        }
        else {
            if coachButton.imageView?.image == UIImage(named: "unchecked") {
                coachButton.setImage(UIImage(named: "checked"), for: .normal)
                playerButton.isHidden = true
                coachButton.setTitle("Coach", for: .normal)
                playerType = "Coach"
            }
            else if coachButton.imageView?.image == UIImage(named: "checked") {
                hideCoachSubViews()
                playerButton.isHidden = false
                coachButton.setImage((UIImage(named: "unchecked")), for: .normal)
                playerType = ""
            }
        }
    }
    
    @objc func didTapBeg() {
        if beginnerButton.imageView?.image == UIImage(named: "unchecked") {
            beginnerButton.setImage(UIImage(named: "checked"), for: .normal)
        }
        else {
            beginnerButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        playerLevel = "Beginner"
        intermediateButton.setImage(UIImage(named: "unchecked"), for: .normal)
        advancedButton.setImage(UIImage(named: "unchecked"), for: .normal)
    }
    
    @objc func didTapInt() {
        if intermediateButton.imageView?.image == UIImage(named: "unchecked") {
            intermediateButton.setImage(UIImage(named: "checked"), for: .normal)
        }
        else {
            intermediateButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        beginnerButton.setImage(UIImage(named: "unchecked"), for: .normal)
        playerLevel = "Intermediate"
        //intermediateButton.setImage(UIImage(named: "checked"), for: .normal)
        advancedButton.setImage(UIImage(named: "unchecked"), for: .normal)
    }
    
    @objc func didTapAd() {
        if advancedButton.imageView?.image == UIImage(named: "unchecked") {
            advancedButton.setImage(UIImage(named: "checked"), for: .normal)
        }
        else {
            advancedButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        beginnerButton.setImage(UIImage(named: "unchecked"), for: .normal)
        playerLevel = "Advanced"
        intermediateButton.setImage(UIImage(named: "unchecked"), for: .normal)
        //advancedButton.setImage(UIImage(named: "checked"), for: .normal)
    }

    @objc func didTapImage() {
        let sheet = UIAlertController(
            title: "Profile Picture",
            message: "Set a picture to help your friends find you.",
            preferredStyle: .actionSheet
        )

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in

            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        sheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self?.photoType = "profile"
                self?.present(picker, animated: true)
            }
        }))
        present(sheet, animated: true)
    }
    
    @objc func didTapCertificateImage() {
        let sheet = UIAlertController(
            title: "Profile Picture",
            message: "Set a picture to help your friends find you.",
            preferredStyle: .actionSheet
        )

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in

            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        sheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self?.photoType = "coach"
                self?.present(picker, animated: true)
            }
        }))
        present(sheet, animated: true)
    }

    @objc func didTapSignUp() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        var inUseAlready: Bool?
        DatabaseManager.shared.checkIfUserExist(username: "Hoof") { [self] success in
            inUseAlready = success
            if playerType == "coach" {
                guard certificateImage.image != UIImage(systemName: "doc.text.magnifyingglass") else {
                    presentError()
                    return
                }
            }
            
            let usernameCheck = self.usernameField.text

            guard inUseAlready! else {
                presentError2()
                return
            }
            
            guard let username = self.usernameField.text,
                  let email = self.emailField.text,
                  let password = self.passwordField.text, //Come here after
                  !email.trimmingCharacters(in: .whitespaces).isEmpty,
                  !password.trimmingCharacters(in: .whitespaces).isEmpty,
                  !username.trimmingCharacters(in: .whitespaces).isEmpty,
                  playerType != "",
                  password.count >= 6,
                  username.count >= 2,
                  username != "Username",
                  email != "Email Address",
                  password != "Create Password",
                  username.trimmingCharacters(in: .alphanumerics).isEmpty else {
                presentError()
                return
            }

            let data = profilePictureImageView.image?.pngData()
            let data2 = certificateImage.image?.pngData()

            // Sign up with authManager
            AuthManager.shared.signUp(
                email: email,
                username: username,
                password: password,
                playerType: playerType,
                playerLevel: playerLevel,///Changes
                profilePicture: data,
                certificatePicture: data2
            ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        HapticManager.shared.vibrate(for: .success)
                        UserDefaults.standard.setValue(user.email, forKey: "email")
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        UserDefaults.standard.setValue(user.playerType, forKey: "playerType")
                        UserDefaults.standard.setValue(user.topComments, forKey: "topComments")
                        UserDefaults.standard.setValue(user.playerLevel, forKey: "playerLevel")

                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.completion?()
                    case .failure(let error):
                        HapticManager.shared.vibrate(for: .error)
                        //print("\n\nSign Up Error: \(error)")
                    }
                }
            }
        }
        
        
    }

    private func presentError() {
        let alert = UIAlertController(title: "Whoops", message: "Please make sure to fill all fields, the certificate image if you are a coach, and have a password longer than 8 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func presentError2() {
        warningField.isHidden = false
    }

    @objc func didTapTerms() {
        guard let url = URL(string: "https://www.appjourneyjeffrey.com/services-7") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    @objc func didTapPrivacy() {
        guard let url = URL(string: "https://www.appjourneyjeffrey.com/services-7") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    // MARK: Field Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapSignUp()
        }
        return true
    }

    // Image Picker

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        if self.photoType == "profile" {
            profilePictureImageView.image = image
        }
        else if self.photoType == "coach" {
            certificateImage.image = image
        }
        
    }
}
