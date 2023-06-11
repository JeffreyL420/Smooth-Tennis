//
//  User.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import Foundation

struct User: Codable {
    let username: String
    let email: String
    let playerType: String
    let topComments: Int?
    let playerLevel: String
}
