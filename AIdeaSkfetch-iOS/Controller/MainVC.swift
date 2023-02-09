//
//  MainVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/07.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - Property
    
    // MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// MainVC - Cell등록
        self.mainCollectionView.register(UserCell.uiNib, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        self.mainCollectionView.register(ModifyingCell.uiNib, forCellWithReuseIdentifier: ModifyingCell.reuseIdentifier)
        self.mainCollectionView.register(FolderCell.uiNib, forCellWithReuseIdentifier: FolderCell.reuseIdentifier)
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
    }
    
}

// MARK: - Cell row/item
extension MainVC: UICollectionViewDataSource {
    // 메인뷰 섹션 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        else if section == 1 { return 1 }
        else if section == 2 { return 2 }
//        else if section == 3 { return 2 }
//        else if section == 4 { return 1 }
//        else if section == 5 { return 3 }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
            cell.backgroundColor = .lightGray
            return cell
        }
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModifyingCell.reuseIdentifier, for: indexPath) as! ModifyingCell
            cell.backgroundColor = .gray
            return cell
        }
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.reuseIdentifier, for: indexPath) as! FolderCell
            cell.backgroundColor = .lightGray
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// cell 높이 사이즈
extension MainVC: UICollectionViewDelegateFlowLayout {
    // 셀 높이, 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = self.view.frame.width
            return CGSize(width: width, height: width * 0.25)
        }
        if indexPath.section == 1 {
            let width = self.view.frame.width
            return CGSize(width: width, height: 40)
        }
        if indexPath.section == 2 {
            let width = self.view.frame.width/2
            return CGSize(width: width, height: 76)
        }
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    // 셀 섹션 간격 inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let inset = self.view.frame.width * 0.025
        let inset = CGFloat(0)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    // 셀 높이 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // self.view.frame.width * 0.025
        return CGFloat(0)
    }
    // 셀 아이템 간격 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}
