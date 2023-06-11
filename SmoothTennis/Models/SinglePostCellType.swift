//
//  SinglePostCellType.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/25/21.
//

import Foundation

enum SinglePostCellType {
    case poster(viewModel: PosterCollectionViewCellViewModel)
    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
    case post(viewModel: PostCollectionViewCellViewModel)
    case actions(viewModel: PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel: PostLikesCollectionViewCellViewModel)
    case timestamp(viewModel: PostDatetimeCollectionViewCellViewModel)
    case comment(viewModel: Comment2)
    
}

enum SinglePostandCommentCellType {
    case post(value: SinglePointCellType)
    case comment(viewModel: Comment)
}

enum SingleProfilePostCellType {
    case post(viewModel: PostCollectionViewCellViewModel)
    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
}

enum TrackingCommentCellType {
    case comment(viewModel: CoachComment)
    }

enum TrackingPlayerCommentCellType {
    case comment(viewModel: PlayerComment)
}
