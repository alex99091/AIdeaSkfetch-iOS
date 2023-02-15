//
//  FolderCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import UIKit

class OperatingCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var operatingIcon: UIImageView!
    
    // MARK: - Property
    static let uiNib = UINib(nibName: "OperatingCell", bundle: nil)
    static let reuseIdentifier = String(describing: OperatingCell.self)
    
    // MARK: - Cell LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func designCell() {
        
    }
}
