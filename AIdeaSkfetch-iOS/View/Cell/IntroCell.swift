//
//  IntroCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import UIKit

class IntroCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var introTextView: UITextView!
    
    // MARK: - Property
    static let uiNib = UINib(nibName: "IntroCell", bundle: nil)
    static let reuseIdentifier = String(describing: IntroCell.self)
    
    // MARK: - Cell LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    
}
