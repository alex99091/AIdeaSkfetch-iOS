//
//  ImageCell.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/15.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCellContentImage: UIImageView!
    
    static let reuseIdentifier = String(describing: ImageCell.self)
}
