//
//  UserCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userIconImage: UIImageView!
    @IBOutlet weak var introductionLabel: UILabel!
    // MARK: - Outlet
    // MARK: - Property
    static let uiNib = UINib(nibName: "UserCell", bundle: nil)
    static let reuseIdentifier = String(describing: UserCell.self)
    
    // MARK: - Cell LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func designLabel() {
        
    }
    
    
}
