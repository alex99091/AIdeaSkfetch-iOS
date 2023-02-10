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
    let userData = ["New User", "newUser@example.com"]
    let regularCustomFont = "Sunflower-Light"
    let boldCustomFont = "Sunflower-Bold"
    let userIconConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
    let operatingIconConfiguration = UIImage.SymbolConfiguration(pointSize: 16)
    let backgroundColor = UIColor(rgb: 0xFFF44F)
    var introCell = IntroCell()
    
    let canvasDatasource = CanvasDataSource()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .systemCyan
        /// MainVC - Cell등록
        self.mainCollectionView.register(UserCell.uiNib, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        self.mainCollectionView.register(IntroCell.uiNib, forCellWithReuseIdentifier: IntroCell.reuseIdentifier)
        self.mainCollectionView.register(OperatingCell.uiNib, forCellWithReuseIdentifier: OperatingCell.reuseIdentifier)
        self.mainCollectionView.register(CanvasCell.uiNib, forCellWithReuseIdentifier: CanvasCell.reuseIdentifier)
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
    }
    
    // MARK: - Method
    
    /// contentVC에 셀 이미지를 클릭하면 canvas View로 넘어가는 function
    @IBAction func nextVC() {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: CanvasVC.identifier)
        else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        else if section == 3 { return canvasDatasource.data.count }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
            cell.userNameLabel.text = userData[0]
            cell.userNameLabel.font = UIFont(name: regularCustomFont, size: 20.0)
            cell.userEmailLabel.text = userData[1]
            cell.userEmailLabel.font = UIFont(name: regularCustomFont, size: 10.0)
            cell.userIconImage.image = UIImage(systemName: "person", withConfiguration: userIconConfiguration)
            return cell
        }
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroCell.reuseIdentifier, for: indexPath) as! IntroCell
            cell.introTextView.font = UIFont(name: boldCustomFont, size: 24.0)
            return cell
        }
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OperatingCell.reuseIdentifier, for: indexPath) as! OperatingCell
            if indexPath.row == 0 {
                cell.operatingIcon.image = UIImage(systemName: "plus", withConfiguration: operatingIconConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
            } else if indexPath.row == 1 {
                cell.operatingIcon.image = UIImage(systemName: "trash", withConfiguration: operatingIconConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
            }
            
            return cell
        }
        if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasCell.reuseIdentifier, for: indexPath) as! CanvasCell
            
            for i in 0..<canvasDatasource.data.count {
                if indexPath.row == i {
                    cell.canvasImage.image = canvasDatasource.data[i].canvasImage
                    cell.canvasNameLabel.text = canvasDatasource.data[i].canvasName
                    cell.canvasNameLabel.font = UIFont(name: regularCustomFont, size: 12.0)
                    cell.canvasCreatedDate.text = canvasDatasource.data[i].createdDate
                    cell.canvasCreatedDate.font = UIFont(name: regularCustomFont, size: 10.0)
                }
            }
            
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
            return CGSize(width: width, height: 50)
        }
        if indexPath.section == 1 {
            let width = self.view.frame.width
            // guard let height = introCell.introTextView.frame.height else { return }
            return CGSize(width: width, height: 70)
        }
        if indexPath.section == 2 {
            return CGSize(width: 40, height: 30)
        }
        if indexPath.section == 3 {
            let width = self.view.frame.width/2 * 0.9
            return CGSize(width: width, height: width)
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
    // ContentCell 클릭하면 CanvasVC로 이동하는 nextVC function
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print("Intro Textfield Clicked")
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                print("indexPath: \(indexPath.row), add icon touched")
                
                
                let uuidData = UUID().uuidString
                let now = Date()
                let date = DateFormatter()
                date.dateFormat = "yyyy-MM-dd"
                
                let icon = UIImage(systemName: "note", withConfiguration: operatingIconConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
                
                let canvas = Canvas(id: uuidData, image: icon, name: "New Canvas \(canvasDatasource.data.count + 1)", date: String(date.string(from: now)), commands: [])
                
                canvasDatasource.addData(canvas)
                self.mainCollectionView.reloadData()
                
            } else if indexPath.row == 1 {
                print("indexPath: \(indexPath.row), delete icon touched")
            }
            
        }
        if indexPath.section == 3 {
            print("show CanvasVC")
            nextVC()
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
