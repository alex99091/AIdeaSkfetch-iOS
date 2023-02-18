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
    let userData = ["새로운 사용자", "newUser01@example.com"]
    let regularCustomFont = "Sunflower-Light"
    let boldCustomFont = "Sunflower-Bold"
    let userIconConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
    let operatingIconConfiguration = UIImage.SymbolConfiguration(pointSize: 16)
    let backgroundColor = UIColor(rgb: 0xFFF44F)
    var introCell = IntroCell()
    
    var canvasDatasource = CanvasDataSource()
    var dataStatus: Bool = false
    let filemanegerUrlPaths: [String] = []
    var canvasVC: CanvasVC = CanvasVC()
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromUserDefault()
        /// MainVC - Cell등록
        self.mainCollectionView.register(UserCell.uiNib, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        self.mainCollectionView.register(IntroCell.uiNib, forCellWithReuseIdentifier: IntroCell.reuseIdentifier)
        self.mainCollectionView.register(OperatingCell.uiNib, forCellWithReuseIdentifier: OperatingCell.reuseIdentifier)
        self.mainCollectionView.register(CanvasCell.uiNib, forCellWithReuseIdentifier: CanvasCell.reuseIdentifier)
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataStatus == true {
            print("activated")
            self.mainCollectionView.reloadData()
            saveDatasourceToUserDefaults(canvasDatasource)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Method
    
    // 앱이 종료되기 전 남아있는 데이터를 userdefaults에 저장해주는 function
    func saveDatasourceToUserDefaults(_ willSaveData: CanvasDataSource) {
        if !canvasDatasource.data.isEmpty {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(canvasDatasource.data), forKey: "canvasLists")
        }
    }
    // 저장된 데이터소스가 userdefaults에 있으면 load해주는 function
    func loadDataFromUserDefault() {
        if let data = UserDefaults.standard.value(forKey: "canvasLists") as? Data {
            canvasDatasource.data = try! PropertyListDecoder().decode([Canvas].self, from: data)
        }
    }
    
    /// contentVC에 셀 이미지를 클릭하면 canvas View로 넘어가는 function
    @IBAction func nextVC(_ uniqueId: String) {
        guard let canvasVC = self.storyboard?.instantiateViewController(withIdentifier: CanvasVC.identifier) as? CanvasVC
        else { return }
        canvasVC.delegate = self
        canvasVC.dataStatus = dataStatus
        // 이때 cell이 선택된 Canvas의 정보를 같이 넘겨준다. (canvasDataSource.data == canvas)
        canvasVC.canvasDataSource = canvasDatasource
        canvasVC.canvasUUID = uniqueId
        self.navigationController?.pushViewController(canvasVC, animated: true)
    }
}

// MARK: - Cell row/item
extension MainVC: UICollectionViewDataSource {
    // 메인뷰 섹션 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
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
                cell.operatingIcon.image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: operatingIconConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
            }
            
            return cell
        }
        if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasCell.reuseIdentifier, for: indexPath) as! CanvasCell
            
            for i in 0..<canvasDatasource.data.count {
                if indexPath.row == i {
                    if canvasDatasource.data.count > 0 {
                        let uniqueId: String = canvasDatasource.data[i].canvasId!
                        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: uniqueId) {
                            cell.canvasImage.image = image
                        }
                    }
                    cell.canvasNameLabel.text = canvasDatasource.data[i].canvasName
                    cell.canvasNameLabel.font = UIFont(name: regularCustomFont, size: 12.0)
                    cell.canvasCreatedDate.text = canvasDatasource.data[i].createdDate
                    cell.canvasCreatedDate.font = UIFont(name: regularCustomFont, size: 10.0)
                }
            }
            cell.backgroundColor = UIColor(rgb:0x20A0D0)
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
            let width = self.view.frame.width * 0.4
            let height = self.view.frame.width * 0.65
            return CGSize(width: width, height: height)
        }
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    // 셀 섹션 간격 inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = CGFloat(0)
        if section == 3 {
            let verticalInset = self.view.frame.width * 0.05
            let horizontalInset = self.view.frame.width * 0.1/3
            return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    // 셀 높이 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // self.view.frame.width * 0.025
        if section == 3 {
            let spacing = self.view.frame.width * 0.05
            return spacing
        }
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
                let path = ImageFileManager.shared.getSavedImageDir(named: uuidData)
                
                let canvas = Canvas(id: uuidData, canvasImageUrl: path,
                                    name: "새로운 캔버스 \(canvasDatasource.data.count + 1)",
                                    date: String(date.string(from: now)))
                
                canvasDatasource.addData(canvas)
                self.mainCollectionView.reloadData()
                
            } else if indexPath.row == 1 {
                print("indexPath: \(indexPath.row), delete icon touched")
            }
        }
        if indexPath.section == 3 {
            print("show CanvasVC")
            for i in 0..<canvasDatasource.data.count {
                var uniqueId: String = ""
                if indexPath.row == i {
                    uniqueId = canvasDatasource.data[i].canvasId!
                    nextVC(uniqueId)
                }
            }
        }
        
    }
}

// MARK: - CanvasVCDelegate
// canvasVC에서 선택한 값 가져오기
extension MainVC: CanvasVCDelegate {
    func canvasVCFinished(_ canvasVC: CanvasVC) {
        dataStatus = canvasVC.dataStatus
        print("MainVC - dataStatus: \(dataStatus)")
        dismiss(animated: true)
    }
}
