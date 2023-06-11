//
//  ProfileHeaderViewModel.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/23/21.
//

import Foundation

enum ProfileButtonType {
    case edit
    case follow(isFollowing: Bool)
}

struct ProfileHeaderViewModel {
    let profilePictureUrl: URL?
    let certificatePictureURL: URL?
//    let followerCount: Int
//    let followingICount: Int
    let experience: String?
    let age: String?
    let postCount: Int
    let location: String?
    let buttonType: ProfileButtonType
    let name: String?
    let bio: String?
    let topCommentAmount: Int?
    let playerLevel: String?
}
