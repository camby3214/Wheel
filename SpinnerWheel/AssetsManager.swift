//
//  AssetsManager.swift
//  Game1A2B
//
//  Created by 李韋辰 on 2023/6/1.
//

import Foundation
import UIKit

class AssetsManager {
    static let shared = AssetsManager()
    private let storyBoardId = "Main"
    
    func getViewController (fromMain id: String) -> UIViewController {
        return UIStoryboard(name: AssetsManager.shared.storyBoardId, bundle: nil).instantiateViewController(withIdentifier: id)
    }
}
