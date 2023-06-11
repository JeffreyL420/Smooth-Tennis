//
//  ExploreV2ViewController.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/6.
//

import UIKit

final class ExploreV2ViewController: UIViewController { //UISearchResultsUpdating {

    private var x = 0
    /// Search controller
    //private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())

    /// Primary exploreo UI component
    private var collectionView: UICollectionView?
    
    private var viewModel1 = [String]()
    
    private var viewModel2 = [String]()
    
    private var posts = [(post: Post, user: User)]()
    private var postsEachKind = [Int: [(post: Post, user: User)]]()
//    private var postsEachKind = [
//        "Forehand": [(post: Post, user: User)],
//        "Backhand": [(post: Post, user: User)],
//        "Volley": [(post: Post, user: User)],
//    ]()
    private var observer: NSObjectProtocol?
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "getRid")
        title = "Explore"
        view.backgroundColor = .systemBackground
        //(searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        //searchVC.searchBar.placeholder = "Search..."
        //searchVC.searchResultsUpdater = self
        //navigationItem.searchController = searchVC
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.backgroundColor = .white
        self.tabBarController?.tabBar.tintColor = .green
        //view.addSubview(collectionView)
        //collectionView.delegate = self
        //collectionView.dataSource = self
        assignBackground()
        fetchData()
        observer = NotificationCenter.default.addObserver(
            forName: .didPostNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            UserDefaults.standard.setValue(true, forKey: "getRid")
            //self?.postsEachKind.removeAll()
            self?.fetchData()
        }
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.postsEachKind.removeAll()
//        self.fetchData()
//    }
    

//    override func viewDidAppear(_ animated: Bool) {
//        postsEachKind = [Int: [(post: Post, user: User)]]()
//
////        postsEachKind = [Int: [(post: Post, user: User)]]()
//        fetchData()
//    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
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
        view.sendSubviewToBack(imageView)
    }
    
    private func fetchData() {
        
        //configureCollectionView()
        DatabaseManager.shared.explorePosts { [weak self] posts in
            //see what's in posts, can maybe add another dictionary key tag to seperate the posts
            DispatchQueue.main.async {
                self?.posts = posts
                self?.collectionView?.reloadData()
                self?.orderbyPosts()
            }
        }
    }
    
    private func orderbyPosts() {
        self.postsEachKind.removeAll()
        self.posts.forEach { post in
            if post.post.tag == "Forehand" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                postsEachKind.append(element: post, toValueOfKey: 0)
                
            }
            else if post.post.tag == "Backhand" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[1]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 1)
                
            }
            else if post.post.tag == "Volley" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[2]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 2)
                
            }
            else if post.post.tag == "Slice" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[2]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 3)
                
            }
            else if post.post.tag == "Smash" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[2]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 4)
                
            }
            else if post.post.tag == "Drop-Shot" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[2]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 5)
                
            }
            else if post.post.tag == "Serve" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[2]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 6)
                
            }
        }
        
        
        if UserDefaults.standard.bool(forKey: "getRid") == false {
           configureCollectionView()
            
        }
        collectionView?.reloadData()
        
    }

}

extension ExploreV2ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard postsEachKind[section]?.count ?? 0 >= 6 else {
            return postsEachKind[section]?.count ?? 0
        }
        return 6
        
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        let model = postsEachKind[indexPath.section]?[indexPath.row]
        //might have to add a video part to it
        var isVideo = Bool()
        if model?.post.postVideoUrlString != "nil" {
            isVideo = true
        }
        else {
            isVideo = false
        }
        cell.configure(with: URL(string: (model?.post.postImageUrlString)!), isVideo: isVideo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewReusableHeaderViewCell.identifier, for: indexPath) as! CollectionViewReusableHeaderViewCell
            viewModel1 = ["FOREHAND", "BACKHAND", "VOLLEY", "SLICE", "SMASH", "DROP SHOT", "SERVE"]
            headerView.configure(with: viewModel1[indexPath.section])
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewReusableFooterViewCell.identifier, for: indexPath) as! CollectionViewReusableFooterViewCell
            viewModel2 = ["MORE FOREHAND", "MORE BACKHAND", "MORE VOLLEY", "MORE SLICE", "MORE SMASH", "MORE DROP SHOT", "MORE SERVE"]
            footerView.configure(with: viewModel2[indexPath.section])
            footerView.delegate = self
//            let tap1 = UITapGestureRecognizer(target: self, action: #selector(didTapFooterView))
//            footerView.addGestureRecognizer(tap1)
            return footerView
        default:
            return UICollectionReusableView()
        }
//        guard kind == UICollectionView.elementKindSectionHeader,
//              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as? CollectionHeaderView else {
//            return UICollectionReusableView()
//        }
//
//        headerView.configure(with: viewModel[indexPath.section])
//        return headerView
//
//        guard kind == UICollectionView.elementKindSectionFooter,
//              let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionFooterView.identifier, for: indexPath) as? CollectionFooterView else {
//            return UICollectionReusableView()
//        }
//        let viewModel1 = ["FOREHAND", "BACKHAND", "VOLLEY", "SLICE", "SMASH", "DROP SHOT", "SERVE"]
//        footerView.configure(with: viewModel1[indexPath.section])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = postsEachKind[indexPath.section]![indexPath.row]
        //let model = posts[indexPath.row]
        let vc = PostViewController(post: model.post, owner: model.user.username)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExploreV2ViewController: CollectionViewFooterCellDelegate {
    func exploreCollectionViewDidTapCategory(_ cell: CollectionViewReusableFooterViewCell, wantedIndex: Int) {
        guard let homePost = postsEachKind[wantedIndex] else {
            return
        }
        let vc = HomeV2ViewController(post: homePost)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//extension ExploreV2ViewController: SearchResultsViewControllerDelegate {
//    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
//        let vc = ProfileViewController(user: user)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}

extension ExploreV2ViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
                
                
                
                let tripletItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.33),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                //tripletItem.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(10))
                
                
                let threeItemGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)), repeatingSubitem: tripletItem, count: 3)
                
                
//                let threeItemGroup = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(160)
//                    ),
//                    subitem: tripletItem,
//                    count: 3
//                )
               
                threeItemGroup2.interItemSpacing = .fixed(10)
                threeItemGroup2.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)

                
        

                let finalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(320)
                    ),
                    subitems: [
                        threeItemGroup2,
                        threeItemGroup2
                    ]
                )
                //finalGroup.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(10), bottom: .fixed(0))
                let section = NSCollectionLayoutSection(group: finalGroup)
//                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem(), self.supplementaryFooterItem()]
                return section
            })

        )
//        collectionView.reloadData()
        self.collectionView = collectionView
        view.addSubview(self.collectionView!)
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.backgroundColor = .clear
        self.collectionView!.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        self.collectionView!.register(
            CollectionViewReusableHeaderViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewReusableHeaderViewCell.identifier
        )
        self.collectionView!.register(
            CollectionViewReusableFooterViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: CollectionViewReusableFooterViewCell.identifier
        )
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem{
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func supplementaryFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem{
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
    }
    
}


//extension ExploreV2ViewController {
//    func configureCollectionView() {
//        private let collectionView: UICollectionView = {
//            let layout = UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
//        //            let item = NSCollectionLayoutItem(
//        //                layoutSize: NSCollectionLayoutSize(
//        //                    widthDimension: .fractionalWidth(0.5),
//        //                    heightDimension: .fractionalHeight(1)
//        //                )
//        //            )
//        //
//        //            let fullItem = NSCollectionLayoutItem(
//        //                layoutSize: NSCollectionLayoutSize(
//        //                    widthDimension: .fractionalWidth(1),
//        //                    heightDimension: .fractionalHeight(1)
//        //                )
//        //            )
//
//                let tripletItem = NSCollectionLayoutItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(0.33),
//                        heightDimension: .fractionalHeight(1)
//                    )
//                )
//                let threeItemGroup = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(160)
//                    ),
//                    subitem: tripletItem,
//                    count: 3
//                )
//
//                let finalGroup = NSCollectionLayoutGroup.vertical(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(320)
//                    ),
//                    subitems: [
//                        threeItemGroup,
//                        threeItemGroup
//                    ]
//                )
//                return NSCollectionLayoutSection(group: finalGroup)
//            }
//
//        //            let verticalGroup = NSCollectionLayoutGroup.vertical(
//        //                layoutSize: NSCollectionLayoutSize(
//        //                    widthDimension: .fractionalWidth(0.5),
//        //                    heightDimension: .fractionalHeight(1)
//        //                ),
//        //                subitem: fullItem,
//        //                count: 2
//        //            )
//        //
//        //            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
//        //                layoutSize: NSCollectionLayoutSize(
//        //                    widthDimension: .fractionalWidth(1),
//        //                    heightDimension: .absolute(160)
//        //                ),
//        //                subitems: [
//        //                    item,
//        //                    verticalGroup
//        //                ]
//        //            )
//
//                let threeItemGroup = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(160)
//                    ),
//                    subitem: tripletItem,
//                    count: 3
//                )
//
//                let finalGroup = NSCollectionLayoutGroup.vertical(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(320)
//                    ),
//                    subitems: [
//                        threeItemGroup,
//                        threeItemGroup
//                    ]
//                )
//                return NSCollectionLayoutSection(group: finalGroup)
//            }
//
//            view.addSubview(collectionView)
//            collectionView.delegate = self
//            collectionView.dataSource = self
//            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            collectionView.backgroundColor = .systemBackground
//            collectionView.register(PhotoCollectionViewCell.self,
//                                    forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//            return collectionView
//        }()
//    }
//}
