//
//  PostViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import UIKit
import Appirater

var mostRecentIndex = 0
var selectedTimes = 0

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var isthePostOpen = false
    
    var emptyDoubles: [Int] = []
//    private let confirmButton: UIBarButtonItem = {
//        let button = UIBarButtonItem()
//        button.title
//        return button
//    }()
    //private var bestComments = [Int: [String?]]()
    
    private var commentAmount = 0
    
    private var profilePhotoUrl1: URL!
    
    private var usernamesNeeded: [String]  = []
    
    private var topCommentsNeeded: [String]  = []
    
    private var order = 1
    private var nextButtonClickAmount = 0

    private let post: Post
    private let owner: String

    private var collectionView: UICollectionView?

    private var viewModels: [SinglePostCellType] = []
    
    private var sections: [SinglePostandCommentCellType] = []
    
    private let commentBarView = CommentBarView()

    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private var status = false
    
//    private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: PostViewController.self, action: #selector(doneButtonClicked))
    
//    private let ye = CommentCollectionViewCell()
    
//    private let commentPlacement: UIButton = {
//        let button = UIButton()
//        button.tintColor = .systemRed
//        let image = UIImage(named: "story 2")
//        button.setImage(image, for: .normal)
//        return button
//    }()
    

    // MARK: - Init

    init(
        post: Post,
        owner: String
    ) {
        self.owner = owner
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        view.backgroundColor = .systemBackground
        //collectionView?.collectionViewLayout = configureCollectionView()
        commentBarView.delegate = self
        fetchPost()
        observeKeyboardChange()
        
        // Appirater.tryToShowPrompt()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        commentBarView.ridButton.isHidden = true
        commentBarView.frame = CGRect(
            x: 0,
            y: view.height-view.safeAreaInsets.bottom-100,
            width: view.width,
            height: 100
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "Transported") == true && self.owner == UserDefaults.standard.string(forKey: "username") //supposed to be true
        {
            //seeing if I need to ask them to terminate or extend
            DatabaseManager.shared.getComments(
                postID: self.post.id,
                owner: self.owner
            ) { [self] comments in
                self.commentAmount = comments.count
                if comments.count < 3 {
                    
                    let sheet = UIAlertController(
                        title: "Oh No!",
                        message: "It has been over a week yet no one has yet to reply to your post, would you like to continue extending this post for a week so coaches may comment or just terminate this post?",
                        preferredStyle: .alert
                    )
                    sheet.addAction(UIAlertAction(title: "Extend", style: .default, handler: { [weak self] _ in
                        //extend date by another week
                        DatabaseManager.shared.editPostStatus(with: self!.post, with: "postedDate") { success in
                            noticeAppeared = false
                            guard success else {
                                return
                            }
                        }
                        
                        
                    }))
                    sheet.addAction(UIAlertAction(title: "Terminate", style: .default, handler: { [weak self] _ in
                        DatabaseManager.shared.deletePost(with: self!.post) { success in
                            noticeAppeared = false
                            guard success else {
                                
                                return
                            }
                        }
        
                        DispatchQueue.main.async {
                            self?.tabBarController?.tabBar.isHidden = false
                            self?.navigationController?.popToRootViewController(animated: false)

                            NotificationCenter.default.post(name: .didPostNotification,
                                                            object: nil)
                        }
                        //terminate the post, deleting it from user history
                        
                        
                    }))
                    self.present(sheet, animated: true)
                    //get rain to check this problem
                }
            
                else {
                    navigationItem.setHidesBackButton(true, animated: true)
                    navigationItem.title = ("Select the \(1)st best response")
                    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(doneButtonClicked))
                    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonClicked))
                    self.tabBarController?.tabBar.isHidden = true
                    navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            UserDefaults.standard.setValue(false, forKey: "Transported")
        }
    }

    private func observeKeyboardChange() {
        observer = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
                return
            }
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-60-height,
                    width: self.view.width,
                    height: 70
                )
            }
        }

        hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-self.view.safeAreaInsets.bottom-70,
                    width: self.view.width,
                    height: 70
                )
            }
        }
    }
    
    @objc func backButtonClicked() {
        order = 1
        selectedTimes = 0
        usernamesNeeded = []
        topCommentsNeeded = []
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(doneButtonClicked))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.title = "Select the 1st best response"
        configureCollectionView()
    }

    @objc func doneButtonClicked() {
        
        if order == 1 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            navigationItem.title = ("Select the \(2)nd best response")
            selectedTimes = 0
        }
        else if order == 2 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            navigationItem.title = ("Select the \(3)rd best response")
            selectedTimes = 0
        }
        else if order == 3 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            //using usernamesNeeded, call DatabaseManager
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateCheckTrack = dateFormatter.string(from: Date())
            DatabaseManager.shared.updatePostComments(commentUsername: usernamesNeeded, postID: post.id, owner: self.owner) { success in
                guard success else {
                    return
                }
            }
            
            DatabaseManager.shared.updateCoachComment(postID: post.id, commenter: usernamesNeeded) { success in
                guard success else {
                    return
                }
            }
            
            DatabaseManager.shared.editUser(newUser: usernamesNeeded[0]) { success in
                guard success else {
                    return
                }
            }
            
            DatabaseManager.shared.editUser(newUser: usernamesNeeded[1]) { success in
                guard success else {
                    return
                }
            }
            
            DatabaseManager.shared.editUser(newUser: usernamesNeeded[2]) { success in
                guard success else {
                    return
                }
            }
            
            guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
            
            
            DatabaseManager.shared.editPostStatus(with: self.post, with: "openStatus") { success in
                guard success else {
                    return
                }
            }
            
            DatabaseManager.shared.createPlayerReview(
                comment: PlayerComment(
                    username: currentUsername,
                    dateString:  self.post.postedDate,
                    thePostImage: self.post.postImageUrlString,
                    thePostVideo: self.post.postVideoUrlString ?? "nil",
                    thePostID: self.post.id,
                    thePostOwner: self.owner,
                    likers: self.post.likers,
                    caption: self.post.caption,
                    tag: self.post.tag,
                    dateCheck: self.post.dateCheck,
                    whoSelected: usernamesNeeded,
                    dateCheckTrack: self.post.dateCheckTrack),
                playerUsername: self.owner) { success in
                    guard success else {
                        return
                    }
                }
        

            ///add three for updating in the coach's section
            
            //DatabaseManager.shared.commentsCoachTransfer(post: post, postID: post.id, owner: self.owner, neededComments: usernamesNeeded)
            UserDefaults.standard.setValue(false, forKey: "Transported")
            self.tabBarController?.tabBar.isHidden = false
            navigationController?.popToRootViewController(animated: true)
            noticeAppeared = false
        }

        order += 1
        

    }

    private func fetchPost() {
        // mock data
        let username = owner
        DatabaseManager.shared.getPost(with: post.id, from: username) { [weak self] post in
            guard let post = post else {
                return
            }

            self?.createViewModel(
                model: post,
                username: username,
                completion: { success in
                    guard success else {
                        return
                    }

                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                }
            )
        }
    }

    private func createViewModel(
        model: Post,
        username: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
            guard let strongSelf = self,
                  let postImageUrl = URL(string: model.postImageUrlString),
                  let postVideoUrl = URL(string: model.postVideoUrlString ?? "nil"),
                  let profilePhotoUrl = profilePictureURL else {
                completion(false)
                return
            }
            var postType = String()
            if model.postVideoUrlString != "nil" {
                postType = "video"
            }
            else {
                postType = "camera"
            }
            self?.status = model.openStatus

            let isLiked = model.likers.contains(currentUsername)

            DatabaseManager.shared.getComments(
                postID: strongSelf.post.id,
                owner: strongSelf.owner
            ) { [self] comments in
                self?.commentAmount = comments.count
                
                var postData: [SinglePostCellType] = [
                    .poster(
                        viewModel: PosterCollectionViewCellViewModel(
                            username: username,
                            profilePictureURL: profilePhotoUrl
                        )
                    ),
                    .caption(
                        viewModel: PostCaptionCollectionViewCellViewModel(
                            tag: model.tag,
                            caption: model.caption
                        )
                    ),
                    .post(
                        viewModel: PostCollectionViewCellViewModel(
                            postImageUrl: postImageUrl, postVideoURL: postVideoUrl, postType: postType
                        )
                    ),
                    .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: isLiked, status: model.openStatus, commentAmount: comments.count)),
                    .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: model.likers)),
                    .timestamp(
                        viewModel: PostDatetimeCollectionViewCellViewModel(
                            date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()
                        )
                        )
                ]
                
                //first -> enable the collection view layout and then I have to cycle through each comment and then append all of them and also adjust the height finish today hopefully
    
//                guard ((self?.commentAmount) != nil) else {
//                    return
//                }
                
//                guard let stringDate = String.date(from: Date()) else {
//                    return
//                }
//                if self?.commentAmount == 0 {
//                    postData.append(.comment(viewModel: Comment(username: "Instruction", comment: "*Coaches, please leave helpful comments to help players with their problems*", dateString: "Oct 6, 2022 at 9:15 AM")))
//                    DatabaseManager.shared.createComments(comment: Comment(username: "Instruction", comment: "*Coaches, please leave helpful comments to help players with their problems*", dateString: stringDate), postID: self!.post.id, owner: self!.owner) { success in
//                        guard success else {
//                            return
//                        }
//                    }
//                }

                postData.append(.comment(viewModel: Comment2(username: "Instruction", comment: "*Coaches, please leave helpful comments to help players with their problems*", dateString: "nil", usernameProfilePhoto: URL(string: "nil")!, topResponse: false, amountTopComments: -1, dateCheckTrack: "nil")))
                
                var topComments = [Comment2]()
                var amount2 = 0
                
                
//                    add an alertviewcontroller

                
                var ifUserDidNotCommented = true
                comments.forEach { comment in
                    DatabaseManager.shared.getCoachCommentAmount(username: comment.username) { amount in
                        amount2 = amount
                    }
                    if comment.username == currentUsername {
                        ifUserDidNotCommented = false
                    }
                    if comment.topResponse == false {
                        topComments.append(comment)
                    }
                    else {
                        var amount1 = 0
                        
                        postData.append(
                            .comment(viewModel: Comment2(username: comment.username, comment: comment.comment, dateString: comment.dateString, usernameProfilePhoto: comment.usernameProfilePhoto, topResponse: comment.topResponse, amountTopComments: amount2, dateCheckTrack: comment.dateCheckTrack))
                        )
                        
                    }
                }
                
                
                topComments.forEach { comment in
                    postData.append(
                        .comment(viewModel: Comment2(username: comment.username, comment: comment.comment, dateString: comment.dateString, usernameProfilePhoto: comment.usernameProfilePhoto, topResponse: comment.topResponse, amountTopComments: amount2, dateCheckTrack: comment.dateCheckTrack))
                        )
                    
                }
                
                
            

//                if let comment = comments.first {
//                    postData.append(
//                        .comment(viewModel: comment)
//                    )
//                }

                
                self?.viewModels = postData
                self?.configureCollectionView()
                if UserDefaults.standard.string(forKey: "playerType") == "Coach" && model.openStatus == true && ifUserDidNotCommented {
                    self?.view.addSubview(self!.commentBarView)
                }
                
                completion(true)
            }
        }
    }

    // CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7+self.commentAmount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section]
        switch cellType {
        case .poster(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifer,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCaptionCollectionViewCell.identifer,
                for: indexPath
            ) as? PostCaptionCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifer,
                for: indexPath
            ) as? PostCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            
            return cell
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifer,
                for: indexPath
            ) as? PostActionsCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section, with: self.commentAmount, with: status)
            return cell
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifer,
                for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .comment(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CommentCollectionViewCell.identifier,
                for: indexPath
            ) as? CommentCollectionViewCell else {
                fatalError()
            }
            var amount1 = 0
//            let text = viewModel.comment
//            let imageSize: CGFloat = cell.height - (4 * 2)
//            let height = estimateFrameForText(text: text).height + 20 + (cell.height-imageSize/3.3-30)
//            cell.frame.size.height = height
//            cell.bounds.size.height = height
//            cell.heightAnchor.constraint(equalToConstant: height).isActive = true
            cell.configure(with: viewModel, index: indexPath.section, topResponse: viewModel.topResponse, amountTopComments: amount1) //bestindex: bestComments)
            cell.backgroundColor = .systemGray
            cell.delegate = self
            //cell.tintColor = .systemGray
            return cell
        case .timestamp(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDateTimeCollectionViewCell.identifer,
                for: indexPath
            ) as? PostDateTimeCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }

    
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 1000, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

extension PostViewController: CommentBarViewDelegate {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        StorageManager.shared.profilePictureURL(for: currentUsername) { [weak self] profilePictureURL in
            guard let profilePhotoUrl = profilePictureURL else {
                return
            }
            
            
            //get the user's amount of topcomments
            var topComments = 0
            DatabaseManager.shared.getCoachCommentAmount(username: currentUsername) { Int in
                topComments = Int
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateCheckTrack = dateFormatter.string(from: Date())
            DatabaseManager.shared.createComments(
                comment: Comment2(
                    username: currentUsername,
                    comment: text,
                    dateString: String.date(from: Date()) ?? "",
                    usernameProfilePhoto: profilePhotoUrl,
                    topResponse: false,
                    amountTopComments: topComments,
                    dateCheckTrack: dateCheckTrack
                ),
                postID: self!.post.id,
                owner: self!.owner
            ) { success in
                DispatchQueue.main.async {
                    guard success else {
                        return
                    }
    //                self.tabBarController?.tabBar.isTranslucent = false
                }
            }
            DatabaseManager.shared.createCoachComment(
                comment: CoachComment(
                    username: currentUsername,
                    comment: text,
                    dateString: String.date(from: Date()) ?? "",
                    usernameProfilePhoto: profilePhotoUrl,
                    topResponse: false,
                    thePostImage: self!.post.postImageUrlString,
                    thePostVideo: self!.post.postVideoUrlString ?? "nil",
                    thePostID: self!.post.id,
                    thePostOwner: self!.owner,
                    likers: self!.post.likers,
                    caption: self!.post.caption,
                    tag: self!.post.tag,
                    dateCheck: self!.post.dateCheck,
                    openStatus: true,
                    dateCheckTrack: self!.post.dateCheckTrack
                )
            ) { success in
                DispatchQueue.main.async {
                    guard success else {
                        return
                    }
                }
            }
        }
        self.fetchPost()
    }

    
    

      
}

extension PostViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
        let vc = ListViewController(type: .likers(usernames: []))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PostViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaptioon(_ cell: PostCaptionCollectionViewCell) {
        
    }
}

extension PostViewController: CommentCollectionViewCellDelegate {
    func commentCollectionViewDidTapImage(_ cell: CommentCollectionViewCell, username: String) {
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            DispatchQueue.main.async {
                guard let user = user else {
                    return
                }
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func commentCollectionViewDidTapUsername(_ cell: CommentCollectionViewCell, username: String) {
        
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            DispatchQueue.main.async {
                guard let user = user else {
                    return
                }
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    
    
    func commentCollectionViewDidTapComment(_ cell: CommentCollectionViewCell) {
        /// When x is a certain number, make that the backgroundview of the cell, on top of that, get rid of the cell that previously
        /// had that as it's background view
        
        if order == 4 {
           //print("Transfer Points")
        }
        if order == 3 {
            usernamesNeeded.append(cell.transferUsername)
            //bestComments.append(element: cell.label.text, toValueOfKey: index)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClicked))
            selectedTimes += 1
            
            let addSelector = UIImageView(image: UIImage(named: "Number\(order)"))
            cell.contentView.backgroundColor = .clear
            cell.backgroundView = addSelector

            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else if selectedTimes < 1 {
            usernamesNeeded.append(cell.transferUsername)
            topCommentsNeeded.append(cell.field.text!)
            
            selectedTimes += 1
            
            let addSelector = UIImageView(image: UIImage(named: "Number\(order)"))
            cell.contentView.backgroundColor = .clear
            cell.backgroundView = addSelector

            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}


extension PostViewController: PostActionsCollectionViewCellDelegate {
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
        commentBarView.field.becomeFirstResponder()
    }
    
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
        let cellType = viewModels[index]
        switch cellType {
        case .post(let viewModel):
            let vc = UIActivityViewController(
                activityItems: ["Check out this cool post!", viewModel.postImageUrl],
                applicationActivities: []
            )
            present(vc, animated: true)

        default:
            break
        }
    }
    
    func postActionsCollectionViewCellDidTapLike(
        _ cell: PostActionsCollectionViewCell,
        isLiked: Bool,
        index: Int) {
        DatabaseManager.shared.updateLikeState(
            state: isLiked ? .like : .unlike,
            postID: post.id,
            owner: owner
        ) { success in
            guard success else { //fails here
                return
            }
            
        }
    }
}

extension PostViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell, index: Int) {
        DatabaseManager.shared.updateLikeState(
            state: .like,
            postID: post.id,
            owner: owner
        ) { success in
            guard success else {
                return
            }
            
        }
    }
}

extension PostViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
        let sheet = UIAlertController(
            title: "Post Actions",
            message: nil,
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                let cellType = self?.viewModels[index]
                switch cellType {
                case .post(let viewModel):
                    let vc = UIActivityViewController(
                        activityItems: ["Check out this cool post!", viewModel.postImageUrl],
                        applicationActivities: []
                    )
                    self?.present(vc, animated: true)

                default:
                    break
                }
            }
        }))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
            // Report post
        }))
        present(sheet, animated: true)
    }

    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
        DatabaseManager.shared.findUser(username: owner) { [weak self] user in
            DispatchQueue.main.async {
                guard let user = user else {
                    return
                }
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension PostViewController {
    func configureCollectionView() {
        //let sectionHeight: CGFloat = 290 + view.width
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { [weak self] index, _ -> NSCollectionLayoutSection? in
                
                
                
                guard let self = self else { return nil}
                
                let cellType = self.viewModels[index]
                switch cellType {

                case .poster:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])

                    return NSCollectionLayoutSection(group: group)
                case .caption:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))

                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                    return NSCollectionLayoutSection(group: group)
                case .post:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)), subitems: [item])

                    return NSCollectionLayoutSection(group: group)
                case .actions:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), subitems: [item])

                    return NSCollectionLayoutSection(group: group)
                case .likeCount:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), subitems: [item])

                    return NSCollectionLayoutSection(group: group)
                case .comment:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(140))
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(140))

                    
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                    return NSCollectionLayoutSection(group: group)
                case .timestamp:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), subitems: [item])

                    return NSCollectionLayoutSection(group: group)
                
                }
                
                // Item
//                let posterItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(60)
//                    )
//                )
//
//                let postItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .fractionalWidth(1)
//                    )
//                )
//
//                let actionsItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(30)
//                    )
//                )
//
//                let likeCountItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(40)
//                    )
//                )
//
//
//                let captionItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(60)
//                    )
//                )
//
//                let commentItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(60*CGFloat(self.commentAmount))
//                    )
//                )
//
//                let timestampItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(40)
//                    )
//                )
//
//                // Group
//                let group = NSCollectionLayoutGroup.vertical(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(sectionHeight)
//                    ),
//                    subitems: [
//                        posterItem,
//                        postItem,
//                        actionsItem,
//                        likeCountItem,
//                        captionItem,
//                        commentItem,
//                        timestampItem
//                    ]
//                )
//
//                // Section
//                let section1 = NSCollectionLayoutSection(group: group)
////                section.decorationItems = [
////                    NSCollectionLayoutDecorationItem.background(elementKind: "background")
////                ]
//                section1.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
//
//                return section1
            })

        )
        


        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifer
        )
        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifer
        )
        collectionView.register(
            PostActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifer
        )
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifer
        )
        collectionView.register(
            PostCaptionCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifer
        )
        collectionView.register(
            PostDateTimeCollectionViewCell.self,
            forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifer
        )
        collectionView.register(CommentCollectionViewCell.self,
                                forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        let color = UIColor(hexString: "#C7F2A4")
        collectionView.backgroundColor = color
        self.collectionView = collectionView
        
        
    }
}

