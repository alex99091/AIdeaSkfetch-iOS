//
//  SearchVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/14.
//

import UIKit
import SwiftUI

class SearchVC: UIViewController {
 
    // MARK: - Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var secondImageView: UIImageView!
    
    // MARK: - Property
    static let identifier = String(describing: SearchVC.self)
    
    let regularCustomFont = "Sunflower-Light"
    
    var data: [Datum] = []
    
    var searchTermDispatchWorkItem: DispatchWorkItem? = nil
    var userInput = ""
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        print("SearchView Loaded")
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Method
    func setupView() {
        explainLabel.text = "If you entered search-term, you would get two Images below. Tap what you prefer to use"
        explainLabel.font = UIFont(name: regularCustomFont, size: 12.0)
        self.searchBar.searchTextField.addTarget(self, action: #selector(searchTermInput(_:)), for: .editingChanged)
        
        // prompt -> 위에 입력된 userInput 넣기
        SearchAPI.searchSketch(prompt: "A cute baby sea otter sketch", n: 2, size: "1024x1024", completion: { result in
            switch result {
            case .success(let response):
                if let imageUrls: [Datum] = response.data {
                    DispatchQueue.main.async {
                        self.reloadInputViews()
                    }
                    // image 1, 2 에 각각  url로 링크 걸어주기
                    if imageUrls.count == 2 {
                        self.firstImageView.load(url: URL(string: imageUrls[0].url!)!)
                        self.secondImageView.load(url: URL(string: imageUrls[1].url!)!)
                    }
                }
            case .failure(let failure):
                print("failure: \(failure)")
            }
            
        })
    }
    
    // MARK: - User Interaction methods
    // 검색어 입력
    @objc func searchTermInput(_ sender: UITextField) {
        searchTermDispatchWorkItem?.cancel()
        
        let dispatchWorkItem = DispatchWorkItem(block: {
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async{
                    self.userInput = sender.text ?? ""
                }
            }
        })
        self.searchTermDispatchWorkItem = dispatchWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: dispatchWorkItem)
    }
}

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
