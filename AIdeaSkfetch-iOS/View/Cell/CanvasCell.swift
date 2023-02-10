//
//  ContentCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/08.
//

import UIKit

class CanvasCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var canvasImage: UIImageView!
    @IBOutlet weak var canvasNameLabel: UILabel!
    @IBOutlet weak var canvasCreatedDate: UILabel!
    
    
    // MARK: - Property
    
    
    static let uiNib = UINib(nibName: "CanvasCell", bundle: nil)
    static let reuseIdentifier = String(describing: CanvasCell.self)
    
    // MARK: - Cell LifeCycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
}

