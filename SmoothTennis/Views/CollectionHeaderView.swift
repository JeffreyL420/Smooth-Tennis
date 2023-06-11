//
//  CollectionHeaderViewCollectionReusableView.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/6.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource {
    static let identifier = "HeaderReusableView"
    
    private var viewModels: String = "Hi"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        //layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
//        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionViewReusableHeaderViewCell.self,
                                forCellWithReuseIdentifier: CollectionViewReusableHeaderViewCell.identifier)
        return collectionView
    }()
    
    // MARK: -Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //Correct
        collectionView.frame = self.bounds
    }
    
    func configure(with viewModel: String) {
        self.viewModels = viewModel
    }
    
    //CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewReusableHeaderViewCell.identifier,
                for: indexPath
        ) as? CollectionViewReusableHeaderViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels)
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.height, height: collectionView.height)
//    }
}
