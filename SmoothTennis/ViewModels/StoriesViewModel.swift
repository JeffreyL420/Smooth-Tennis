//
//  StoriesViewModel.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/25/21.
//

import Foundation
import UIKit

struct StoriesViewModel {
    let stories: [Story]
}

struct Story {
    let username: String
    let image: UIImage?
}
