//
//  ExploreViewController.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import UIKit

/// Explore / Discover controller that also supports search
final class ExploreViewController: UIViewController, UISearchResultsUpdating {

    /// Search controller
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())

    /// Primary exploreo UI component
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { index, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1)
                )
            )

            let fullItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            let tripletItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.33),
                    heightDimension: .fractionalHeight(1)
                )
            )

            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1)
                ),
                subitem: fullItem,
                count: 2
            )
            

            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(160)
                ),
                subitems: [
                    item,
                    verticalGroup
                ]
            )

            let threeItemGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(160)
                ),
                subitem: tripletItem,
                count: 3
            )

            let finalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(320)
                ),
                subitems: [
                    horizontalGroup,
                    threeItemGroup
                ]
            )
            return NSCollectionLayoutSection(group: finalGroup)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()

    private var posts = [(post: Post, user: User)]()
    private var postsICare = [(post: Post, user: User)]()
    private var postsEachKind = [Int: [(post: Post, user: User)]]()
//    private var postsEachKind = [
//        "Forehand": [(post: Post, user: User)],
//        "Backhand": [(post: Post, user: User)],
//        "Volley": [(post: Post, user: User)],
//    ]()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Explore"
        view.backgroundColor = .systemBackground
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search..."
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    private func fetchData() {
        DatabaseManager.shared.explorePosts { [weak self] posts in
            //see what's in posts, can maybe add another dictionary key tag to seperate the posts
            
            DispatchQueue.main.async {
                self?.posts = posts
                self?.orderbyPosts()
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func orderbyPosts() {
        self.posts.forEach { post in
            if post.post.tag == "Forehand" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsICare.append(post)
                postsEachKind.append(element: post, toValueOfKey: 1)
                //self.postsICare.append(post)
            }
            else if post.post.tag == "Backhand" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[1]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 2)
                //self.postsICare.append(post)
            }
            else if post.post.tag == "Volley" {
                //private var postsEachKind = [String: [(post: Post, user: User)]]()
                //postsEachKind[2]?.append(post)
                postsEachKind.append(element: post, toValueOfKey: 3)
                //self.postsICare.append(post)
            }
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
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postsEachKind.count
        //return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        let model = postsEachKind[indexPath.section]![indexPath.row]
        cell.configure(with: URL(string: model.post.postImageUrlString), isVideo: true) //doesn't matter rn
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = postsEachKind[indexPath.section]![indexPath.row]
        //let model = posts[indexPath.row]
        let vc = PostViewController(post: model.post, owner: model.user.username)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExploreViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//extension Dictionary where Value: RangeReplaceableCollection {
//    public mutating func append(element: Value.Iterator.Element, toValueOfKey key: Key) -> Value? {
//        var value: Value = self[key] ?? Value()
//        value.append(element)
//        self[key] = value
//        return value
//    }
//}
