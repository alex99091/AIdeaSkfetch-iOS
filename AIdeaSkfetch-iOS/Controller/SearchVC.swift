//
//  SearchVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/14.
//

import UIKit
import SwiftUI

protocol SearchVCDelegate: AnyObject {
  func searchVCFinished(_ searchVC: SearchVC)
}

class SearchVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var progressSlider: UIProgressView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // MARK: - Delegate
    weak var delegate: SearchVCDelegate?
    
    // MARK: - Property
    static let identifier = String(describing: SearchVC.self)
    
    let regularCustomFont = "Sunflower-Light"
    
    var data: [Datum] = []
    var fetchedImageUrlList: [Datum] = []
    var fetchedImageUrl: String = ""
    
    var searchTermDispatchWorkItem: DispatchWorkItem? = nil
    private var observation: NSKeyValueObservation?
    var searchTerm: String = ""
    var userInputStatus: Bool = false
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        print("SearchView Loaded")
        super.viewDidLoad()
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        setupView()
        reloadInputViews()
    }
    
    // MARK: - Method
    func setupView() {
        self.view.layer.cornerRadius = 10
        explainLabel.text = "If you entered search-term, you would get two Images below. Tap what you prefer to use"
        explainLabel.font = UIFont(name: regularCustomFont, size: 12.0)
        self.searchBar.searchTextField.addTarget(self, action: #selector(searchTermInput(_:)), for: .editingChanged)
    }
    // MARK: - User Interaction methods
    // 검색어 입력
    @objc func searchTermInput(_ sender: UITextField) {
        searchTermDispatchWorkItem?.cancel()
        
        let dispatchWorkItem = DispatchWorkItem(block: {
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async { [weak self] in
                    guard let userInput = sender.text,
                          let self = self else { return }
                    print(#fileID, #function, #line)
                    self.searchTerm = userInput
                    self.userInputStatus = true
                    self.progressCheck()
                    self.imageCollectionView.reloadData()
                }
            }
        })
        self.searchTermDispatchWorkItem = dispatchWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: dispatchWorkItem)
    }
    // progressbar 설정하기 -> refactoring 필요 download 함수 호출되면 속도에 맞추어 지금은 평균시간으로 계산함
    func progressCheck() {
        var value = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { timer in
            value += 0.075
            self.progressSlider.setProgress(Float(value), animated: true)
            if value > 20.0 {
                timer.invalidate()
            }
        })
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        
        if userInputStatus == true {
            SearchAPI.searchSketch(prompt: searchTerm + "colored sketch",
                                   n: 4,
                                   size: "1024x1024",
                                   completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if let imageUrls: [Datum] = response.data {
                        self.fetchedImageUrlList = imageUrls
                        DispatchQueue.main.async {
                            self.reloadInputViews()
                        }
                        for i in 0...3 {
                            if indexPath.row == i{
                                cell.imageCellContentImage.load(url: URL(string: imageUrls[i].url!)!)
                            }
                        }
                    }
                    
                case .failure(let failure):
                    print("failure: \(failure)")
                }
            })
        } else if userInputStatus == false {
            for i in 0...3 {
                if indexPath.row == i{
                    cell.imageCellContentImage.image = UIImage(named: "blankImage")
                }
            }
        }
        //cell.backgroundColor = .black
        return cell
    }
}

// MARK: - Cell Layout
extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    // 셀 높이, 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = imageCollectionView.frame.width * 0.45
        return CGSize(width: width, height: width)
    }
    // 셀 섹션 간격 inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let verticalInset = self.view.frame.width * 0.025
        let horizontalInset = self.view.frame.width * 0.05/3
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}

// Mark: - Cell이 선택되었을때 action
extension SearchVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...3 {
            if indexPath.row == i {
                self.fetchedImageUrl = fetchedImageUrlList[i].url!
                print("current: SearchVC, fetchedUrl = \(fetchedImageUrl)")
                delegate?.searchVCFinished(self)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}



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
