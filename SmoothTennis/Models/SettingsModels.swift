//
//  SettingsModels.swift
//  SmoothTennis
//
//  Created by Afraz Siddiqui on 3/25/21.
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    let image: UIImage?
    let color: UIColor
    let handler: (() -> Void)
}
