//
//  ToolBarCell.swift
//  Canvas-iOS
//
//  Created by BOONGKI KWAK on 2023/02/08.
//

import UIKit

class ToolBarCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var toolbarCellImage: UIImageView!
    
    // MARK: - Property
    static let uiNib = UINib(nibName: "ToolBarCell", bundle: nil)
    static let reuseIdentifier = String(describing: ToolBarCell.self)
    
    
    // MARK: - XibCell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    
}
