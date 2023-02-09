//
//  ViewController.swift
//  Canvas-iOS
//
//  Created by BOONGKI KWAK on 2023/02/08.
//

import UIKit

class CanvasVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var canvasCollectionView: UICollectionView!
    
    // MARK: - Property
    static let identifier = String(describing: CanvasVC.self)
    var toolbarCell: ToolBarCell = ToolBarCell()
    var canvasCell: CanvasCell = CanvasCell()
    let buttonSystemImageList = ["pencil.and.outline", "seal", "crop.rotate", "magnifyingglass", "square.dashed", "command"]
    
    /// CanvasCell 그리기용도
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    
    // MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell 정보 등록
        self.canvasCollectionView.register(ToolBarCell.uiNib, forCellWithReuseIdentifier: ToolBarCell.reuseIdentifier)
        self.canvasCollectionView.register(CanvasCell.uiNib, forCellWithReuseIdentifier: CanvasCell.reuseIdentifier)
        // DataSource, Delegate 등록
        self.canvasCollectionView.dataSource = self
        self.canvasCollectionView.delegate = self
    }
    
    // MARK: - Method
    /// Canvas그리는 functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        canvasCell.drawImage.image?.draw(in: view.bounds)
        
        // 2
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        // 3
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        // 4
        context.strokePath()
        
        // 5
        canvasCell.drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        canvasCell.drawImage.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        // 6
        swiped = true
        let currentPoint = touch.location(in: view)
        drawLine(from: lastPoint, to: currentPoint)
        
        // 7
        lastPoint = currentPoint
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(canvasCell.canvasImage.frame.size)
        canvasCell.canvasImage.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        canvasCell.drawImage?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        canvasCell.canvasImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        canvasCell.drawImage.image = nil
    }
}

extension CanvasVC: UICollectionViewDataSource {
    // MARK: - Section
    /// section -> section.count = 2 -> section0 = toobar, section1 = canvas
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return buttonSystemImageList.count
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ToolBarCell.reuseIdentifier,
                for: indexPath) as! ToolBarCell
            for i in 0...indexPath.row {
                cell.toolbarCellImage.image = UIImage(systemName: buttonSystemImageList[i])
                cell.toolbarCellImage.frame.size = CGSize(width: 50, height: 50)
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CanvasCell.reuseIdentifier,
                for: indexPath) as! CanvasCell
            cell.backgroundColor = .lightGray
            return cell
        }
        return UICollectionViewCell()
    }
}

// cell 높이 사이즈
extension CanvasVC: UICollectionViewDelegateFlowLayout {
    // 셀 높이, 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (self.view.frame.width / 6) * 0.4
            return CGSize(width: width, height: width)
        }
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
    }
    // 셀 간격 inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        let inset = self.view.frame.width
        let inset = CGFloat(0)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    // 셀 높이 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    // 셀 아이템 간격 spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
}
