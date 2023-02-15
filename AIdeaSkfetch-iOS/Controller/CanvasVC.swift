//
//  CanvasVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import UIKit

class CanvasVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var canvasImage: UIImageView!
    @IBOutlet weak var drawImage: UIImageView!
    
    // MARK: - Property
    static let identifier = String(describing: CanvasVC.self)
    
    var lastPoint = CGPoint.zero
    // default value
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var fetchedImageUrl: String = ""
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Method
    // 터치 이벤트 시작 - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    // 라인 그리기 - drawSketch
    func drawSketch(from fromPoint: CGPoint, to toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawImage.image?.draw(in: view.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        context.strokePath()
        
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        drawImage.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // 터치 움직이는 이벤트 - touchesMoved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        swiped = true
        let currentPoint = touch.location(in: view)
        drawSketch(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    
    // 터치가 끝나는 이벤트
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawSketch(from: lastPoint, to: lastPoint)
        }
        // 터치가 끝나면 drawImage를 canvas에 합치고 darwImage를 nil로 리터
        UIGraphicsBeginImageContext(canvasImage.frame.size)
        canvasImage.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        drawImage?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        canvasImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        drawImage.image = nil
    }
    
    // 세팅버튼 터치하면 세팅화면으로 이동하는 function
    @IBAction func settingButtonTabbed(_ sender: Any) {
        print("settingButton Tabbed")
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: SettingVC.identifier) as! SettingVC
        // 세팅VC의 값 가져오기
        settingVC.delegate = self
        settingVC.brushValue = brushWidth
        settingVC.opacityValue = opacity
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        settingVC.red = red
        settingVC.green = green
        settingVC.blue = blue
        
        settingVC.modalPresentationStyle = .overFullScreen
        settingVC.modalTransitionStyle = .crossDissolve
        
        self.present(settingVC, animated: true, completion: nil)
    }
    
    // Search 버튼 누르면 search뷰로 이동하는 function
    @IBAction func searchButtonTapped(_ sender: Any) {
        print("searchButton Tapped")
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: SearchVC.identifier) as! SearchVC
        searchVC.delegate = self
        searchVC.fetchedImageUrl = fetchedImageUrl
        
        searchVC.modalPresentationStyle = .overCurrentContext
        searchVC.providesPresentationContextTransitionStyle = true
        searchVC.definesPresentationContext = true
        searchVC.modalTransitionStyle = .crossDissolve
        
        self.present(searchVC, animated: true, completion: nil)
    }
    
    
    // 상단에 backButton을 누르면 mainVc로 돌아가는 backVC function
    @IBAction func backVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - SettingVCDelegate
// settingVC에서 선택한 값 가져오기
extension CanvasVC: SettingVCDelegate {
    func settingsVCFinished(_ settingVC: SettingVC) {
        brushWidth = settingVC.brushValue
        opacity = settingVC.opacityValue
        color = UIColor(red: settingVC.red,
                        green: settingVC.green,
                        blue: settingVC.blue,
                        alpha: opacity)
        dismiss(animated: true)
    }
}

// MARK: - SearchVCDelegate
// settingVC에서 선택한 값 가져오기
extension CanvasVC: SearchVCDelegate {
    func searchVCFinished(_ searchVC: SearchVC) {
        fetchedImageUrl = searchVC.fetchedImageUrl
        dismiss(animated: true)
    }
}
