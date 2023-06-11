//
//  TrackingMoneyViewController.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/7/20.
//

import UIKit

class TrackingCoachViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView?
    
//    private let owner: String
    
    private var viewModels: [SinglePointCellType] = []
    
    private var viewModelsV2: [TrackingCommentCellType] = []
    
    private let pointsLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.backgroundColor = .systemYellow
        myLabel.numberOfLines = 0
        myLabel.textColor = .label
        myLabel.layer.borderColor = UIColor.black.cgColor
        myLabel.layer.borderWidth = 1
        myLabel.clipsToBounds = true
        myLabel.layer.cornerRadius = 8
        myLabel.text = ""
        myLabel.textAlignment = .center
        return myLabel
    }()
    
    private let noTransactionsYet: UILabel = {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.text = "No review of your comments yet!"
        myLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        myLabel.textColor = .lightGray
        myLabel.layer.borderWidth = 1
        myLabel.clipsToBounds = true
        myLabel.layer.cornerRadius = 8
        myLabel.textAlignment = .center
        return myLabel
    }()

    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "info.circle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPoints()
        configureCollectionView()
        view.addSubview(pointsLabel)
        view.addSubview(infoImageView)
        configureLabelText()
        title = "Tracking"
        //view.addSubview(collectionView)
        view.backgroundColor = .secondarySystemBackground
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//        DatabaseManager.shared.getIndividualPoints(for: username) { amount in
//            for x in 1...amount.count-1 {
//                for y in 0...6 {
//                    self.data.append(amount[x][y])
//                }
//            }
//        }
//        tableView.backgroundColor = .systemBlue
        //using a custom cell
//        self.tableView?.separatorStyle = .none
//        tableView?.register(TrackingTableCell.self, forCellReuseIdentifier: TrackingTableCell.identifier)
//        tableView?.delegate = self
//        tableView?.dataSource = self
    }
    
    
    private func configureLabelText() {
        guard let playerType = UserDefaults.standard.string(forKey: "playerType") else {
            return
        }
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
       
        pointsLabel.layer.opacity = 0.6
        pointsLabel.textColor = .systemGray
        self.pointsLabel.text = "     This is where you can track all your responses to posts, including the date and whether or not a player selected you as a top commenter."
        
//        DatabaseManager.shared.getPosOrNegPointAmount(for: playerType, for: username) { double in
//            if UserDefaults.standard.string(forKey: "playerType") == "Player" {
//                self.pointsLabel.text = "TOTAL SPENT: \(double)"
//            }
//            if UserDefaults.standard.string(forKey: "playerType") == "Coach" {
//                self.pointsLabel.text = "TOTAL EARNED: \(double)"
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pointsLabel.frame = CGRect(x: 0, y: view.safeAreaInsets.top+10, width: view.width, height: 80) //might have to fix view.top
        infoImageView.frame = CGRect(x: 10, y: pointsLabel.top+10, width: 20, height: 20)
        noTransactionsYet.frame = CGRect(x: (view.width-view.width/1.5)/2, y: (view.height-40)/2, width: view.width/1.5, height: 40)
       
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    private func fetchPoints() {
        guard let targetUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        self.createViewModel(targetUsername: targetUsername) { [weak self] success in
            guard success else {
                return 
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
                
            }
        }
        
        
    
        
//        DatabaseManager.shared.getIndividualPoints(for: username) { amount in
//            for x in 1...amount.count-1 {
//                for y in 0...6 {
//                    self.data.append(amount[x][y])
//                }
//            }
//
//        }
        
        
        
    }
    
    
    private func createViewModel(
        targetUsername: String,
        completion: @escaping (Bool) -> Void
    ) {
//        DatabaseManager.shared.getIndividualPoints(for: targetUsername) { prizedPoints in
//            var postData: [SinglePointCellType] = []
//            prizedPoints.forEach { Point in
//                postData.append(.points(viewModel: Point)
//                )
//            }
//            self.viewModels = postData
//            completion(true)
//        }
        DatabaseManager.shared.getCoachComments(commenter: targetUsername) { eachData in
            //have a openStatus variable only if over then add then evaluate it correctly
            var postData: [TrackingCommentCellType] = []
            eachData.forEach { Comment in
                if Comment.openStatus == false {
                    postData.append(.comment(viewModel: Comment)
                    )
                }
            }
            if postData.count < 1 {
                self.view.addSubview(self.noTransactionsYet)
            }
            self.viewModelsV2 = postData
            completion(true)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModelsV2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModelsV2[indexPath.row]
        switch cellType {
        case .comment(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackingCollectionViewCell.identifier, for: indexPath)
            as? TrackingCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.layer.cornerRadius = 8
            cell.delegate = self
            return cell
        }
    }
    

}

extension TrackingCoachViewController: TrackingCollectionViewCellDelegate {
    func trackingCollectionViewCellDidTapImage(_ cell: TrackingCollectionViewCell, postOwner: String, postID: String, postCaption: String, postDateCheck: String, postLikers: [String], postTag: String, postImageURL: String, postVideoURL: String, Date: String, postDateCheckTrack: String) {
        let vc = PostViewController(post: Post(id: postID, caption: postCaption, postedDate: Date, postImageUrlString: postImageURL, postVideoUrlString: postVideoURL, likers: postLikers, dateCheck: postDateCheck, tag: postTag, openStatus: false, dateCheckTrack: postDateCheckTrack), owner: postOwner)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TrackingCoachViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                let commentItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(200)
                    )
                )

                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    ),
                    subitems: [
                        commentItem
                    ]
                )
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0)

                return section
            })
        )
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackingCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrackingCollectionViewCell.identifier)

        collectionView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
        self.collectionView = collectionView
    }
}
    

