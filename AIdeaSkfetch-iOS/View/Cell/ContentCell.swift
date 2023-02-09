//
//  ContentCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/08.
//

import UIKit

class ContentCell: UICollectionViewCell {
    
    // MARK: - Outlet
    // MARK: - Property
    static let uiNib = UINib(nibName: "ContentCell", bundle: nil)
    static let reuseIdentifier = String(describing: ContentCell.self)
    
    // MARK: - Cell LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func designCell() {
        
    }
}
