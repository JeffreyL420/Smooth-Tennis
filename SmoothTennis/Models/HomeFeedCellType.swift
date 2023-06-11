//
//  HomeFeedCellType.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import Foundation

enum HomeFeedCellType {
    case poster(viewModel: PosterCollectionViewCellViewModel)
    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
    case post(viewModel: PostCollectionViewCellViewModel)
    case actions(viewModel: PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel: PostLikesCollectionViewCellViewModel)
    case timestamp(viewModel: PostDatetimeCollectionViewCellViewModel)
}
