//
//  MainVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/07.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    // MARK: - Property
    
    // MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// UINib, Datasource, delegate 등록
        self.contentCollectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderView.reuseIdentifier)
        self.contentCollectionView.register(UINib(nibName: "ContentCell", bundle: nil), forCellWithReuseIdentifier: ContentCell.reuseIdentifier)
        self.contentCollectionView.dataSource = self
        self.contentCollectionView.delegate = self
    }
    
}

// MARK: - Cell row/item
extension MainVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseIdentifier, for: indexPath) as? ContentCell else { fatalError() }
        return cell
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    // Header 등록
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let mainHeaderView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MainHeaderView.reuseIdentifier,
            for: indexPath) as? MainHeaderView else { fatalError() }
        mainHeaderView.backgroundColor = .red
        
        return mainHeaderView
    }
    // 헤더 높이, 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    // 셀 높이, 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width * 0.25
        return CGSize(width: width, height: width)
    }
    // 셀 inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = self.view.frame.width * 0.025
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    // 셀 높이 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.view.frame.width * 0.025
    }
    // 셀 아이템 간격 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.view.frame.width * 0.025
    }
}
