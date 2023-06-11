//
//  NotificationCelltype.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/23/21.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel: FollowNotificationCellViewModel)
    case like(viewModel: LikeNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}
