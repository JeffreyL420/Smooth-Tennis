//
//  ProfileViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import UIKit


/// Reusable controller for Profile
class ProfileViewController: UIViewController, UISearchResultsUpdating{
    
    private var photoType = String()

    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    private let user: User

    private var isCurrentUser: Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }

    private var collectionView: UICollectionView?

    private var headerViewModel: ProfileHeaderViewModel?

    private var posts: [Post] = []
    
    private var comments: [Comment] = []
    
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    //private var viewModels: [SingleProfilePostCellType] = []
    
    private var postsEachKind: [[SingleProfilePostCellType]] = [[]]
    
    private let commentBarView = CommentBarView()
    
    private var profilePhotoUrl1: URL!
    // MARK: - Init

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        commentBarView.delegate = self
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        assignBackground()
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.backgroundColor = .white
        self.tabBarController?.tabBar.tintColor = .green
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search..."
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        if self.user.playerType == "Player" {
//        super.viewDidLoad()
        configureNavBar()
        fetchProfileInfo()
        configureCollectionView()
        }
        else if self.user.playerType == "Coach" {
            observeKeyboardChange()
            fetchProfileInfo2()
            configureNavBar()
            configureCollectionView2()
            
            //header part is basically the same, but below instead of posts, you can leave comments about what you think about the coach
        }
        if isCurrentUser {
            observer = NotificationCenter.default.addObserver(
                forName: .didPostNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.posts.removeAll()
                self?.fetchProfileInfo()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.setValue(false, forKey: "Transported")
        if UserDefaults.standard.bool(forKey: "Transported") {
            findthePost(x: realID)
        }
    }
    
    func assignBackground(){
        let background = UIImage(named: "BackgroundImage")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.alpha = 0.3
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        commentBarView.frame = CGRect(
            x: 0,
            y: view.height-view.safeAreaInsets.bottom-100,
            width: view.width,
            height: 100
        )
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
    
    private func fetchProfileInfo2() {
        let username = user.username

        let group = DispatchGroup()

        // Fetch Posts
        group.enter()
        //Fix this to fetch ratings, add that into databasemanager
        DatabaseManager.shared.ratings(for: username) { [weak self] result in
            defer {
                group.leave()
            }

            switch result {
            case .success(let comments):
                self?.comments = comments
            case .failure:
                break
            }
        }

        // Fetch Profiel Header Info

        var profilePictureUrl: URL?
        var ceritifcatePictureUrl: URL?
        var buttonType: ProfileButtonType = .edit
//        var followers = 0
//        var following = 0
        var topCommentAmount: Int?
        var experience: String?
        var age: String?
        var posts = 0
        var name: String?
        var bio: String?
        var location: String?
        

        // Counts (3)
        group.enter()
        DatabaseManager.shared.getUserCounts(username: user.username, playerType: self.user.playerType) { result in
            defer {
                group.leave()
            }
            posts = result.posts
//            followers = result.followers
//            following = result.following
        }
        
        group.enter()
        DatabaseManager.shared.getCoachCommentAmount(username: user.username) { result in
            defer {
                group.leave()
            }
            topCommentAmount = result
        }
        
        // Bio, name
        DatabaseManager.shared.getUserInfo(username: user.username) { userInfo in
            name = userInfo?.name
            bio = userInfo?.bio
            age = userInfo?.age
            experience = userInfo?.experience
            location = userInfo?.location
        }

        // Profile picture url
        group.enter()
        StorageManager.shared.profilePictureURL(for: user.username) { url in
            defer {
                group.leave()
            }
            profilePictureUrl = url
        }
        
        group.enter()
        StorageManager.shared.certificatePictureURL(for: user.username) { url in
            defer {
                group.leave()
            }
            ceritifcatePictureUrl = url
        }

        // if profile is not for current user,
        if !isCurrentUser {
            // Get follow state
            group.enter()
            DatabaseManager.shared.isFollowing(targetUsername: user.username) { isFollowing in
                defer {
                    group.leave()
                }
                
                buttonType = .follow(isFollowing: isFollowing)
            }
        }

        group.notify(queue: .main) {
            
            self.headerViewModel = ProfileHeaderViewModel(
                profilePictureUrl: profilePictureUrl,
                certificatePictureURL: ceritifcatePictureUrl,
                experience: experience,
                age: age,
                postCount: posts,
                location: location,
                buttonType: buttonType,
                name: name,
                bio: bio,
                topCommentAmount: topCommentAmount,
                playerLevel: nil
            )
            self.collectionView?.reloadData()
        }
    }

    private func fetchProfileInfo() {
        let username = user.username

        let group = DispatchGroup()
        
        // Fetch Posts
        group.enter()
        DatabaseManager.shared.posts(for: username) { [weak self] result in
            defer {
                group.leave()
            }

            switch result {
            case .success(let posts):
//                for post in posts {
//                    guard let postUrl = URL(string: post.postUrlString) else {
//                        return
//                    }
//                    var postData: [SingleProfilePostCellType] = [
//                        .post(viewModel: PostCollectionViewCellViewModel(postUrl: postUrl)),
//                        .caption(viewModel: PostCaptionCollectionViewCellViewModel(tag: post.tag, caption: post.caption))
//                        ]
//                    //getting an array of SingleProfilePostCellType arrays that contain a post and caption aspect
//                    self?.postsEachKind.append(postData)
//                }
                
                //for each post, append to viewmodel so I can take the url string and caption, then I can display that in each photocollectionviewcell
                
                self?.posts = posts
            case .failure:
                break
            }
        }

        // Fetch Profiel Header Info
        var profilePictureUrl: URL?
        var certificatePictureUrl: URL?
        var buttonType: ProfileButtonType = .edit
//        var followers = 0
//        var following = 0
        var experience: String?
        var age: String?
        var posts = 0
        var name: String?
        var bio: String?
        var location: String?
        var playerLevel: String?

        // Counts (3)
        group.enter()
        DatabaseManager.shared.getUserCounts(username: user.username, playerType: self.user.playerType) { result in
            defer {
                group.leave()
            }
            posts = result.posts
//            followers = result.followers
//            following = result.following
        }


        // Bio, name
        DatabaseManager.shared.getUserInfo(username: user.username) { userInfo in
            name = userInfo?.name
            bio = userInfo?.bio
            age = userInfo?.age
            experience = userInfo?.experience
            location = userInfo?.location
        }

        // Profile picture url
        group.enter()
        StorageManager.shared.profilePictureURL(for: user.username) { url in
            defer {
                group.leave()
            }
            profilePictureUrl = url
        }
        
        group.enter()
        StorageManager.shared.certificatePictureURL(for: user.username) { url in
            defer {
                group.leave()
            }
            certificatePictureUrl = url
        }
        
        group.enter()
        DatabaseManager.shared.getPlayerLevel(username: user.username) { result in
            playerLevel = result
            defer {
                group.leave()
            }
        }

        // if profile is not for current user,
        if !isCurrentUser {
            // Get follow state
            group.enter()
            DatabaseManager.shared.isFollowing(targetUsername: user.username) { isFollowing in
                defer {
                    group.leave()
                }
                
                buttonType = .follow(isFollowing: isFollowing)
            }
        }

        group.notify(queue: .main) {
            
            self.headerViewModel = ProfileHeaderViewModel(
                profilePictureUrl: profilePictureUrl,
                certificatePictureURL: certificatePictureUrl,
                experience: experience,
                age: age,
                postCount: posts,
                location: location,
                buttonType: buttonType,
                name: name,
                bio: bio,
                topCommentAmount: nil,
                playerLevel: playerLevel
            )
            self.collectionView?.reloadData()
        }
    }

//    private func createViewModel(
//        model: Post,
//        completion: @escaping (Bool) -> Void)
//    {
//        guard let postUrl = URL(string: model.postUrlString) else {
//            completion(false)
//            return
//        }
//        completion(true)
//        //work from here
//    }
    
    
    private func configureNavBar() {
        if isCurrentUser {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        DatabaseManager.shared.findUsers(with: query) { results in
            DispatchQueue.main.async {
                resultsVC.update(with: results)
            }
        }
    }

    @objc func didTapSettings() {
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func findthePost(x: String) {
        collectionView?.reloadData()
        for i in posts {
            if i.id == realID {
                let neededPost = i
                let vc = PostViewController(post: neededPost, owner: user.username)
                navigationController?.pushViewController(vc, animated: true)
                break
            }
            
        }
        
    }
}
/// going to try creating sections, 2 items per section, the caption and the picture
extension ProfileViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if user.playerType == "Player" {
            if posts.count == 0 {
                return 1

            }
            else {
            return posts.count
            }
        }
        else if user.playerType == "Coach" {
            if comments.count == 0 {
                return 1
            }
            else {
            return comments.count
            }
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if user.playerType == "Player" {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfilePhotoCollectionViewCell.identifier,
                for: indexPath
            ) as? ProfilePhotoCollectionViewCell else {
                fatalError()
            }
            //cell.configure(with: URL(string: posts[indexPath.row].postUrlString))
//            if posts.count == 0 {
//                cell.configure(with: URL(string: "nil"), with: "nil", with: "nil", with: "nil", with: self.user.playerType)
//            }
//            else {
            if posts.count == 0 {
                cell.configure(with: URL(string: "nil"), with: "nil", with: "nil", with: "nil", with: self.user.playerType)
            }
            else {
            cell.configure(with: URL(string: posts[indexPath.row].postImageUrlString), with: posts[indexPath.row].postVideoUrlString, with: posts[indexPath.row].caption, with: posts[indexPath.row].tag, with: self.user.playerType)
            }
            //}
        
            return cell
        }
        
        else if user.playerType == "Coach"{
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfilePhotoCollectionViewCell.identifier,
                for: indexPath
            ) as? ProfilePhotoCollectionViewCell else {
                fatalError()
            }
            //cell.configure(with: URL(string: posts[indexPath.row].postUrlString))
            if comments.count == 0 {
                cell.configure(with: URL(string: "nil"), with: "nil", with: "nil", with: "nil", with: self.user.playerType)
            }
            else {
            cell.configure(with: comments[indexPath.row].usernameProfilePhoto, with: "nil", with: comments[indexPath.row].comment, with: comments[indexPath.row].username, with: self.user.playerType)
            }
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        if let viewModel = headerViewModel {
            headerView.configure(with: viewModel, playerType1: self.user.playerType)
            headerView.countContainerView.delegate = self
        }
        headerView.delegate = self
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if user.playerType == "Player" {
            collectionView.deselectItem(at: indexPath, animated: true)
            let post = posts[indexPath.row]
            let vc = PostViewController(post: post, owner: user.username)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableViewDidTapLeaveComment(_ header: ProfileHeaderCollectionReusableView) {
        guard isCurrentUser else {
            commentBarView.isHidden = false
            commentBarView.field.text = "Type your thoughts here..."
            commentBarView.field.textColor = .lightGray
            self.view.addSubview(self.commentBarView)
            return
        }
        
    }
    
    func profileHeaderCollectionReusableViewDidTapCertificatePicture(_ header: ProfileHeaderCollectionReusableView, type: String) {
        guard isCurrentUser else {
            return
        }

        let sheet = UIAlertController(
            title: "Change Picture",
            message: "Update your coaching certificate.",
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
                self?.present(picker, animated: true)
                self?.photoType = type
            }
        }))
        present(sheet, animated: true)
    }
    
    func profileHeaderCollectionReusableViewDidTapProfilePicture(_ header: ProfileHeaderCollectionReusableView, type: String) {

        guard isCurrentUser else {
            return
        }
        
        

        let sheet = UIAlertController(
            title: "Change Picture",
            message: "Update your photo to reflect your best self.",
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
                self?.present(picker, animated: true)
                self?.photoType = type
            }
        }))
        present(sheet, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        if photoType == "Profile" {
            StorageManager.shared.uploadProfilePicture(
                username: user.username,
                data: image.pngData()
            ) { [weak self] success in
                if success {
                    self?.headerViewModel = nil
                    self?.posts = []
                    self?.fetchProfileInfo()
                }
            }
        }
        if photoType == "Certificate" {
            StorageManager.shared.uploadCertificatePicture(
                username: user.username,
                data: image.pngData()
            ) { [weak self] success in
                if success {
                    self?.headerViewModel = nil
                    self?.posts = []
                    self?.fetchProfileInfo()
                }
            }
        }
    }
}

extension ProfileViewController: ProfileHeaderCountViewDelegate {
    
    func profileHeaderCountViewDidTapFollowers(_ containerView: ProfileHeaderCountView) {
        let vc = ListViewController(type: .followers(user: user))
        navigationController?.pushViewController(vc, animated: true)
    }

    func profileHeaderCountViewDidTapFollowing(_ containerView: ProfileHeaderCountView) {
        let vc = ListViewController(type: .following(user: user))
        navigationController?.pushViewController(vc, animated: true)
    }

    func profileHeaderCountViewDidTapPosts(_ containerView: ProfileHeaderCountView) {
        guard posts.count >= 18 else {
            return
        }
        collectionView?.setContentOffset(CGPoint(x: 0, y: view.width * 0.4),
                                         animated: true)
    }

    func profileHeaderCountViewDidTapEditProfile(_ containerView: ProfileHeaderCountView) {
        let vc = EditProfileViewController()
        vc.completion = { [weak self] in
            self?.headerViewModel = nil
            self?.fetchProfileInfo()
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    func profileHeaderCountViewDidTapFollow(_ containerView: ProfileHeaderCountView) {
        DatabaseManager.shared.updateRelationship(
            state: .follow,
            for: user.username
        ) { [weak self] success in
            if !success {
                
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }

    func profileHeaderCountViewDidTapUnFollow(_ containerView: ProfileHeaderCountView) {
        DatabaseManager.shared.updateRelationship(
            state: .unfollow,
            for: user.username
        ) { [weak self] success in
            if !success {
                
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }
}

extension ProfileViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.95),
                        heightDimension: .fractionalHeight(0.7)
                    ),
                    subitem: item,
                    count: 1
                )
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(10), top: nil, trailing: NSCollectionLayoutSpacing.fixed(10), bottom: NSCollectionLayoutSpacing.fixed(10))
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuous

                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(0.9)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]

                return section
            })
        )
        collectionView.register(ProfilePhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProfilePhotoCollectionViewCell.identifier)
        collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        //collectionView.backgroundColor = .systemBackground
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)

        self.collectionView = collectionView
    }
    
    func configureCollectionView2() {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.95),
                        heightDimension: .fractionalHeight(0.2)
                    ),
                    subitem: item,
                    count: 1
                )
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(10), top: nil, trailing: NSCollectionLayoutSpacing.fixed(10), bottom: NSCollectionLayoutSpacing.fixed(10))
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuous
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(1.4)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                

                return section
            })
        )
        collectionView.register(ProfilePhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProfilePhotoCollectionViewCell.identifier)
        collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        //collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
//        collectionView.layer.borderWidth = 2
//        collectionView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(collectionView)

        self.collectionView = collectionView
    }
}

extension ProfileViewController: ProfilePhotoCollectionViewCellDelegate {
    func commentDidTapProfileName(_ cell: ProfilePhotoCollectionViewCell, username: String) {
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
    
    func commentDidTapProfileImage(_ cell: ProfilePhotoCollectionViewCell, username: String) {
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
    
    
}

extension ProfileViewController: CommentBarViewDelegate {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String) {
        if text.count < 1 || text == "Type your thoughts here..." {
            commentBarView.isHidden = true
            return
        }
        else {
            guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
            StorageManager.shared.profilePictureURL(for: currentUsername) { [weak self] profilePictureURL in
                guard let profilePhotoUrl = profilePictureURL else {
                    return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateCheckTrack = dateFormatter.string(from: Date())
                DatabaseManager.shared.createCoachProfileComments(
                    comment: Comment2(
                        username: currentUsername,
                        comment: text,
                        dateString: String.date(from: Date()) ?? "",
                        usernameProfilePhoto: profilePhotoUrl,
                        topResponse: false, amountTopComments: -1,
                        dateCheckTrack: dateCheckTrack
                    ),
                    owner: self!.user.username
                ) { success in
                    DispatchQueue.main.async {
                        guard success else {
                            return
                        }
                        self!.fetchProfileInfo2()
                        commentBarView.isHidden = true
        //                self.tabBarController?.tabBar.isTranslucent = false
                    }
                }
            }
        }
    }
}
