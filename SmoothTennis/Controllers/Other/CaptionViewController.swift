//
//  CaptionViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import UIKit
import StoreKit

var realID: String = ""

var postDate = [(post: Post, user: User)]()

class CaptionViewController: UIViewController, UITextViewDelegate {
    
    
//    var targetTime: String = "00:01:00"
//
//    var oTime: String = ""
//
//    var timerCounting: Bool = false
//
//    var startTime: Date?
//
//    var stopTime: Date?
//
//    let userDefaults = UserDefaults.standard
//    let START_TIME_KEY = "startTime"
//    let STOP_TIME_KEY = "stopTime"
//    let COUNTING_KEY = "countingKey"
//
//    var scheduledTimer: Timer!
//
//
//    public var hours: Int = 0
//    public var mins: Int = 0
//    public var secs: Int = 0
//
    private let buttonIcon = UIImage(systemName: "circle.circle")
    
    private let activityIndicatorViewFix: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.isHidden = true
        return aiv
    }()
    
    public var category: String = ""
    
    private let button1: UIButton = {
        let btn = UIButton()
        btn.setTitle("Select Technique", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        return btn
    }()

    private let button2: UIButton = {
        let btn = UIButton()
        btn.setTitle("Forehand", for: .normal)
        btn.backgroundColor = .systemGray //.systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        btn.isHidden = true
        return btn
    }()
    
    private let button3: UIButton = {
        let btn = UIButton()
        btn.setTitle("Backhand", for: .normal)
        btn.backgroundColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        btn.isHidden = true
        return btn
    }()

    private let button4: UIButton = {
        let btn = UIButton()
        btn.setTitle("Volley", for: .normal)
        btn.backgroundColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        btn.isHidden = true
        return btn
    }()
    
    private let button5: UIButton = {
        let btn = UIButton()
        btn.setTitle("Slice", for: .normal)
        btn.backgroundColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        btn.isHidden = true
        return btn
    }()

    private let button6: UIButton = {
        let btn = UIButton()
        btn.setTitle("Smash", for: .normal)
        btn.backgroundColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        btn.isHidden = true
        return btn
    }()
    
    private let button7: UIButton = {
        let btn = UIButton()
        btn.setTitle("Drop-Shot", for: .normal)
        btn.backgroundColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        btn.isHidden = true
        return btn
    }()

    private let button8: UIButton = {
        let btn = UIButton()
        btn.setTitle("Serve", for: .normal)
        btn.backgroundColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.masksToBounds = false
        btn.isHidden = true
        return btn
    }()
    
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let image: UIImage

    private let videoURL: String
    
    private let videoView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "play")
        imageView.tintColor = .white
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let imageVIew: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.text = "Add caption..."
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return textView
    }()

    private let textLabel: UILabel = {
        let textView = UILabel()
        textView.accessibilityIdentifier = "250"
        textView.tintColor = .systemRed
        textView.text = "0/250"
        textView.textAlignment = .center
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 10)
        return textView
    }()

    
    private var finalVideoURL: URL!
    // MARK: - Init
    
    func textViewDidChange(_ textLabel: UILabel, _ strLength: Int) {
        textLabel.text = "\(strLength)/\(textLabel.accessibilityIdentifier!)"
        
    }
    func replacebutton1(x: String) {
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        button5.isHidden = true
        button6.isHidden = true
        button7.isHidden = true
        button8.isHidden = true
        button1.setTitle(x, for: .normal)
        category = x
        
    }
    
    @objc func didTapTechnique() {
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        button5.isHidden = false
        button6.isHidden = false
        button7.isHidden = false
        button8.isHidden = false
    }
    
    
    @objc func didTap2() {
        replacebutton1(x: "Forehand")
    }
    
    @objc func didTap3() {
        replacebutton1(x: "Backhand")
    }
    
    @objc func didTap4() {
        replacebutton1(x: "Volley")
    }
    
    @objc func didTap5() {
        replacebutton1(x: "Slice")
    }
    
    @objc func didTap6() {
        replacebutton1(x: "Smash")
    }
    
    @objc func didTap7() {
        replacebutton1(x: "Drop-Shot")
    }
    
    @objc func didTap8() {
        replacebutton1(x: "Serve")
    }
    
    init(image: UIImage, url: String) {
        self.image = image
        self.videoURL = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageVIew)
        imageVIew.image = image
        view.addSubview(textView)
        view.addSubview(textLabel)
        textView.delegate = self
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Post",
//            style: .done,
//            target: self,
//            action: #selector(didTapPost))
//        view.addSubview(stackView)
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(button5)
        view.addSubview(button6)
        view.addSubview(button7)
        view.addSubview(button8)
//        stackView.addArrangedSubview(button1)
//        stackView.addArrangedSubview(button2)
//        stackView.addArrangedSubview(button3)
//        stackView.addArrangedSubview(button4)
//        stackView.addArrangedSubview(button5)
//        stackView.addArrangedSubview(button6)
//        stackView.addArrangedSubview(button7)
//        stackView.addArrangedSubview(button8)
        button1.addTarget(self, action: #selector(didTapTechnique), for: .touchUpInside)
        button2.addTarget(self, action: #selector(didTap2), for: .touchUpInside)
        button3.addTarget(self, action: #selector(didTap3), for: .touchUpInside)
        button4.addTarget(self, action: #selector(didTap4), for: .touchUpInside)
        button5.addTarget(self, action: #selector(didTap5), for: .touchUpInside)
        button6.addTarget(self, action: #selector(didTap6), for: .touchUpInside)
        button7.addTarget(self, action: #selector(didTap7), for: .touchUpInside)
        button8.addTarget(self, action: #selector(didTap8), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        rightBarButton.image = buttonIcon
        self.navigationItem.rightBarButtonItem = rightBarButton
        if self.videoURL != "nil" {
            videoView.isHidden = false
            imageVIew.addSubview(videoView)
            let videoSize = view.height/16
            videoView.centerXAnchor.constraint(equalTo: imageVIew.centerXAnchor).isActive = true
            videoView.centerYAnchor.constraint(equalTo: imageVIew.centerYAnchor).isActive = true
            videoView.widthAnchor.constraint(equalToConstant: videoSize).isActive = true
            videoView.heightAnchor.constraint(equalToConstant: videoSize).isActive = true
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        var strlength = textView.text.count
        if strlength > 250 {
            let end = textView.text.index(textView.text.endIndex, offsetBy: -1)
            textView.text = String(textView.text[..<end])
            
            strlength -= 1
        }
        textViewDidChange(textLabel, strlength)
    }
    
    @objc func didTapPost() {
        
        guard category != "" && category != "Add caption..." else { //Add alertsheet controller
            return
        }
        
        textView.resignFirstResponder() //forced unwrap for now may need to change
        
        var caption = textView.text ?? ""
        if caption == "Add caption..." {
            caption = ""
        }
        
        let sheet = UIAlertController(
            title: "Posting!",
            message: "By posting, you will be given a week period for coaches to respond and answer your post. After this time, you will obligated to pick 3 best coach comments! If the post has less than three comments, it may continue to be extended by a week or terminated by the user.",
            preferredStyle: .alert
        )
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Sure", style: .default, handler: { [weak self] _ in

            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self!.activityIndicatorViewFix)
            self?.activityIndicatorViewFix.isHidden = false
            self?.activityIndicatorViewFix.startAnimating()
           
            // Generate post ID
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateCheck = dateFormatter.string(from: Date())
            ///change I took out the "a", does that fix it?
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateCheckTrack = dateFormatter.string(from: Date())
            
            guard let newPostID = self!.createNewPostID(),
                  let stringDate = String.date(from: Date()) else {
                return
            }
            //realID = newPostID
            
            
            

            // Upload Post with Image
            StorageManager.shared.uploadPost(
                imageData: self!.image.pngData(),
                id: newPostID
            ) { newPostDownloadURL in
                guard var url1 = newPostDownloadURL else {
                    //print("error: failed to upload")
                    return
                }
                var url: URL!
                if self?.videoURL != "nil" {
                    self?.finalVideoURL = URL(string: self!.videoURL)!
                    StorageManager.shared.uploadVideo(id: newPostID, data: (self?.finalVideoURL!)!) { newPostVideoDownloadURL in
                    
                        url = newPostVideoDownloadURL
                        let newPost = Post(
                            id: newPostID,
                            caption: caption,
                            postedDate: stringDate,
                            postImageUrlString: url1.absoluteString, //this is the image portion
                            postVideoUrlString: url.absoluteString, //this is the video portion
                            likers: [],
                            dateCheck: dateCheck,
                            tag: self!.category,
                            openStatus: true,
                            dateCheckTrack: dateCheckTrack
                        )
                        DatabaseManager.shared.createPost(newPost: newPost) { [weak self] finished in
                            self?.activityIndicatorViewFix.stopAnimating()
                            guard finished else {
                                return
                            }
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .didPostNotification,
                                                                object: nil)
                                self?.tabBarController?.tabBar.isHidden = false
                                self?.tabBarController?.selectedIndex = 0
                                self?.navigationController?.popToRootViewController(animated: false)
                                //NotificationCenter.default.post(name: .didPostNotification,
                                                                //object: nil)

                             
                            }
                        }
                    }
                }
                else {
                    url = URL(string: "nil")
                    let newPost = Post(
                        id: newPostID,
                        caption: caption,
                        postedDate: stringDate,
                        postImageUrlString: url1.absoluteString, //this is the image portion
                        postVideoUrlString: url.absoluteString, //this is the video portion
                        likers: [],
                        dateCheck: dateCheck,
                        tag: self!.category,
                        openStatus: true,
                        dateCheckTrack: dateCheckTrack
                    )
                    DatabaseManager.shared.createPost(newPost: newPost) { [weak self] finished in
                        guard finished else {
                            return
                        }
                        self?.activityIndicatorViewFix.stopAnimating()
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .didPostNotification,
                                                            object: nil)
                            self?.tabBarController?.tabBar.isHidden = false
                            self?.tabBarController?.selectedIndex = 0
                            self?.navigationController?.popToRootViewController(animated: false)
                            //NotificationCenter.default.post(name: .didPostNotification,
                                                            //object: nil)

                            
                        }
                    }
                }

                }
            }))
    
        
        
        present(sheet, animated: true)
    }

        
    


    private func createNewPostID() -> String? {
        let timeStamp = Date().timeIntervalSince1970
        let randomNumber = Int.random(in: 0...1000)
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }

        return "\(username)_\(randomNumber)_\(timeStamp)"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size: CGFloat = view.width/4
        let size2: CGFloat = view.width/2
        imageVIew.frame = CGRect(
            x: (view.width-size*3.5)/2,
            y: view.safeAreaInsets.top + 5,
            width: size*3.5,
            height: size*2
        )
        textView.frame = CGRect(
            x: 20,
            y: imageVIew.bottom,
            width: view.width-40,
            height: 150
        )
        button1.frame = CGRect(x: (view.width-size2)/2+10, y: textView.bottom+20, width: 200, height: 40)
        button2.frame = CGRect(x: (view.width-size2)/2+10, y: button1.bottom+2, width: 200, height: 40)
        button3.frame = CGRect(x: (view.width-size2)/2+10, y: button2.bottom+2, width: 200, height: 40)
        button4.frame = CGRect(x: (view.width-size2)/2+10, y: button3.bottom+2, width: 200, height: 40)
        button5.frame = CGRect(x: (view.width-size2)/2+10, y: button4.bottom+2, width: 200, height: 40)
        button6.frame = CGRect(x: (view.width-size2)/2+10, y: button5.bottom+2, width: 200, height: 40)
        button7.frame = CGRect(x: (view.width-size2)/2+10, y: button6.bottom+2, width: 200, height: 40)
        button8.frame = CGRect(x: (view.width-size2)/2+10, y: button7.bottom+2, width: 200, height: 40)
        
        textLabel.frame = CGRect(x: textView.right-45, y: textView.bottom+5, width: 45, height: 10)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add caption..." {
            textView.text = nil
        }
    }
    
    //timer things
    
   
}
