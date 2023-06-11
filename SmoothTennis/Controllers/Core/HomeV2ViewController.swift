//
//  HomeV2ViewController.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/6.
//

import UIKit

class HomeV2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    private var neeededPost: [(post: Post, user: User)]
    /// CollectionView for feed
    private var collectionView: UICollectionView?

    /// Feed viewModels
    private var viewModels = [[HomeFeedCellType]]()

    /// Notification observer
    private var observer: NSObjectProtocol?

    /// All post models
    private var allPosts: [(post: Post, owner: String)] = []
    
    private var commentAmount = [Int]()
    
    private let pointButton: PointButton = {
        let button = PointButton()
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Go Post And Get That Feedback!"
        return label
    }()
    
    private var status: [Bool] = []

    
    //MARK: - Init
    
    init(
        post: [(post: Post, user: User)]
    ) {
        self.neeededPost = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Smooth Tennis"
        view.backgroundColor = .systemBackground
        fetchPosts()
        observer = NotificationCenter.default.addObserver(
            forName: .didPostNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.viewModels.removeAll()
            self?.fetchPosts()
        }
        
        setupMenuBar()
        
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
//    view.addSubview(menuBar)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(goPurchase))
//        tap.numberOfTapsRequired = 1
//        menuBar.label.isUserInteractionEnabled = true
//        menuBar.label.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pointActivate()
        menuBar.configureLabelAmount()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.backgroundColor = .systemGreen
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/(1.4)
        //menuBar.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/20)
        collectionView?.frame = view.bounds
        label.frame = CGRect(x: view.width/3, y: view.height/3, width: view.width/3, height: view.height/5)
        //pointButton.frame = CGRect(x: size, y: view.top+50, width: view.width/5, height: view.height/20)
    }
    
    @objc func pointActivate() {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
//        DatabaseManager.shared.addPoints(
//            point:
//                Points(
//                    points: "200",
//                    username: username,
//                    dateString: String.date(from: Date()) ?? "",
//                    method: "Given",
//                    thePostImage: "None",
//                ),
//            username: username) { success in
//                DispatchQueue.main.async {
//                    guard success else {
//                        return
//                    }
//                }
//            }
    }
    
//    @objc func goPurchase() {
//        let vc = PurchaseViewController()
//        UserDefaults.standard.setValue(true, forKey: "HometoPurchase")
//        navigationController?.pushViewController(vc, animated: true)
//    }

    private func fetchPosts() {
        

        
//        var allPosts: [(post: Post, user: User)] = []
//
//        self.allPosts = neeededPost
        let userGroup = DispatchGroup()
        userGroup.notify(queue: .main) {
            let group = DispatchGroup()
            self.neeededPost.forEach { model in
                group.enter()
                self.createViewModel(
                    model: model.post,
                    username: model.user.username,
                    completion: { success in
                        defer {
                            group.leave()
                        }
                        if !success {
                            
                        }
                    }
                )
            }
            group.notify(queue: .main) {
                self.sortData()
                self.collectionView?.reloadData()
            }
            
        }
    }
    private func sortData() {
       
        neeededPost = neeededPost.sorted(by: { first, second in
            let date1 = first.post.date
            let date2 = second.post.date
            return date1 > date2
        })
        
        viewModels = viewModels.sorted(by: { first, second in
            var date1: Date?
            var date2: Date?
            first.forEach { type in
                switch type {
                case .timestamp(let vm):
                    date1 = vm.date
                default:
                    break
                }
            }
            second.forEach { type in
                switch type {
                case .timestamp(let vm):
                    date2 = vm.date
                default:
                    break
                }
            }
            
            if let date1 = date1, let date2 = date2 {
                return date1 > date2
            }
            
            return false
        })

    }

    private func createViewModel(
        model: Post,
        username: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
            guard let postImageUrl = URL(string: model.postImageUrlString),
                  let postVideoUrl = URL(string: model.postVideoUrlString ?? "nil"),
                  let profilePhotoUrl = profilePictureURL else {
                return
            }
            var postType = String()
            if model.postVideoUrlString != "nil" {
                postType = "video"
            }
//            self?.status = model.openStatus
            DatabaseManager.shared.getComments(postID: model.id, owner: currentUsername) { comments in
                self?.commentAmount.append(comments.count)
                
                self?.status.append(model.openStatus)

                
                let isLiked = model.likers.contains(currentUsername)
                let postData: [HomeFeedCellType] = [
                    .poster(
                        viewModel: PosterCollectionViewCellViewModel(
                            username: username,
                            profilePictureURL: profilePhotoUrl
                        )
                    ),
                    .caption(
                        viewModel: PostCaptionCollectionViewCellViewModel(
                            tag: model.tag,
                            caption: model.caption)),
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
                self?.viewModels.append(postData)
                completion(true)
            }
        }
        configureCollectionView()
    }

    // CollectionView

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section][indexPath.row]
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
//            cell.playPauseButton.isHidden = viewModel.postType == "video"
            return cell
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifer,
                for: indexPath
            ) as? PostActionsCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section, with: self.commentAmount[indexPath.section], with: status[indexPath.section])
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
}

extension HomeV2ViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
        HapticManager.shared.vibrateForSelection()
        let vc = ListViewController(type: .likers(usernames: neeededPost[index].post.likers))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeV2ViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaptioon(_ cell: PostCaptionCollectionViewCell) {
        
    }
}

extension HomeV2ViewController: PostActionsCollectionViewCellDelegate {
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.share)
        let section = viewModels[index]
        section.forEach { cellType in
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
    }

    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.comment)
        let tuple = neeededPost[index]
        HapticManager.shared.vibrateForSelection()
        let vc = PostViewController(post: tuple.post, owner: tuple.user.username)
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }

    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.like)
        HapticManager.shared.vibrateForSelection()
        let tuple = neeededPost[index]
        DatabaseManager.shared.updateLikeState(
            state: isLiked ? .like : .unlike,
            postID: tuple.post.id,
            owner: tuple.user.username) { success in
            guard success else {
                return
            }
            
        }
    }
}

extension HomeV2ViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.doubleTapToLike)
        let tuple = neeededPost[index]
        DatabaseManager.shared.updateLikeState(
            state: .like,
            postID: tuple.post.id,
            owner: tuple.user.username) { success in
            guard success else {
                return
            }
            
        }
    }
}

extension HomeV2ViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
        let sheet = UIAlertController(
            title: "Post Actions",
            message: nil,
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                let section = self?.viewModels[index] ?? []
                section.forEach { cellType in
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
            }
        }))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
            // Report
            AnalyticsManager.shared.logFeedInteraction(.reported)
        }))
        present(sheet, animated: true)
    }

    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
        let username = neeededPost[index].user.username
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

extension HomeV2ViewController {
    func configureCollectionView() {
        let sectionHeight: CGFloat = 240 + view.width
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                // Item
                let posterItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let captionItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(60)
                    )
                )

                let postItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1)
                    )
                )

                let actionsItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                let likeCountItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                let timestampItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(sectionHeight)
                    ),
                    subitems: [
                        posterItem,
                        captionItem,
                        postItem,
                        actionsItem,
                        likeCountItem,
                        timestampItem
                    ]
                )

                // Section
                let section = NSCollectionLayoutSection(group: group)

                if index == 0 {
                    section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .fractionalWidth(0)
                            ),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top
                        )
                    ]
                }

                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 20, trailing: 0)

                return section
            })
        )

        view.addSubview(collectionView)
        let color = UIColor(hexString: "#C7F2A4")
        collectionView.backgroundColor = color
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
        self.collectionView = collectionView
    }
}
