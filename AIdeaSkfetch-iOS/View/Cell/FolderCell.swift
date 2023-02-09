//
//  FolderCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import UIKit

class FolderCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    // MARK: - Property
    static let uiNib = UINib(nibName: "FolderCell", bundle: nil)
    static let reuseIdentifier = String(describing: FolderCell.self)
    
    // MARK: - Cell LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func designCell() {
        
    }
}
