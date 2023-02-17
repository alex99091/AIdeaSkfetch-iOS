//
//  UIImageView.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/18.
//

import UIKit

// url 링크 -> UIImage fetch
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
