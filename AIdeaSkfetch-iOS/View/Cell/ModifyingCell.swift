//
//  ModifyingCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import UIKit

class ModifyingCell: UICollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var DeleteIcon: UIImageView!
    
    // MARK: - Property
    static let uiNib = UINib(nibName: "ModifyingCell", bundle: nil)
    static let reuseIdentifier = String(describing: ModifyingCell.self)
    
    // MARK: - Cell LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func designCell() {
        
    }
}
