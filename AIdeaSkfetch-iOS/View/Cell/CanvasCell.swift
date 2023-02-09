//
//  CanvasCell.swift
//  Canvas-iOS
//
//  Created by BOONGKI KWAK on 2023/02/08.
//

import UIKit

class CanvasCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var canvasImage: UIImageView!
    @IBOutlet weak var drawImage: UIImageView!
    
    // MARK: - Property
    static let uiNib = UINib(nibName: "CanvasCell", bundle: nil)
    static let reuseIdentifier = String(describing: CanvasCell.self)
    
    // MARK: - XibCell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
}
