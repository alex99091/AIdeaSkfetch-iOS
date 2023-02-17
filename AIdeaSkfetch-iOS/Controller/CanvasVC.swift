//
//  CanvasVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import UIKit

protocol CanvasVCDelegate: AnyObject {
  func canvasVCFinished(_ canvasVC: CanvasVC)
}

class CanvasVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var canvasImage: UIImageView!
    @IBOutlet weak var drawImage: UIImageView!
    @IBOutlet weak var fetchedImage: UIImageView!
    
    @IBOutlet weak var trayButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var reviseStackView: UIStackView!
    
    @IBOutlet var trayButtonCollection: [UIButton]!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Delegate
    weak var delegate: CanvasVCDelegate?
    
    // MARK: - Property
    static let identifier = String(describing: CanvasVC.self)
    
    var canvasDataSource: CanvasDataSource = CanvasDataSource()
    var IndexOfdataSource: Int = 0
    var dataStatus: Bool = false
    
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var dataFetched = false
    
    var drawCommand: [[String: Any]] = [[:]]
    var buttonTappedStatus: [String: Bool] = ["settingButton":false, "eraserButton":false,
                                              "undoButton":false, "redoButton":false, "searchButton": false]
    
    let IconConfiguration = UIImage.SymbolConfiguration(pointSize: 35)
    let regularCustomFont = "Sunflower-Light"
    let menuIconConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
    var tappedCount: Int = 0
    var fetchedImageUrl: String = ""
    
    var imageStack: [UIImage] = []
    var poppedImageStack: [UIImage] = []
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAndload()
        trayButtonCollection.forEach{ $0.addTarget(self, action: #selector(ButtonCollectionTapped(_:)), for: .touchUpInside)}
        setMoreButtonMenuBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Method
    // 기존 파일이 존재하면 로드해주기
    func checkAndload(){
        let uniqueFileName: String = canvasDataSource.findUUID(IndexOfdataSource, data: canvasDataSource.data)
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: uniqueFileName) {
            drawImage.image = image
        }
    }
    
    
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
        
        // 다시 그려질때 poppedImageStack 초기화
        poppedImageStack = []
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
        // 터치가 끝나면 drawImage를 canvas에 합치고 darwImage를 nil로 리턴
        UIGraphicsBeginImageContext(canvasImage.frame.size)
        canvasImage.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        drawImage?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        canvasImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // imageStack에 액션별 이미지 담아주기
        imageStack.append(canvasImage.image!)
        
        drawImage.image = nil
    }
    
    
    // 이미지를 선택하면 이미지를 canvas에 옮기는 이벤트
    func fetchImageToCanvas() {
        
        UIGraphicsBeginImageContext(canvasImage.frame.size)
        canvasImage.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        fetchedImage.load(url: URL(string: fetchedImageUrl)!)
        fetchedImage?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        canvasImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        fetchedImage.image = nil
        dataFetched = false
        // ImageView : View Hiearchy 조정
        // self.fetchImage.sendSubViewToBack(self.mainImage)
    }
    
    // 도구버튼이 탭되면 아래 도구모음을 보여주고, 색이 변하는 action
    @IBAction func trayButtonTapped(_ sender: Any) {
        print("trayButtonTapped")
        tappedCount += 1
        if tappedCount % 2 == 0 {
            reviseStackView.isHidden = true
            let image = UIImage(systemName: "tray", withConfiguration: IconConfiguration)
            trayButton.setImage(image, for: .normal)
            trayButton.tintColor = UIColor(rgb: 0x20A0D0)
        } else {
            let image = UIImage(systemName: "tray.and.arrow.down", withConfiguration: IconConfiguration)
            trayButton.setImage(image, for: .normal)
            trayButton.tintColor = UIColor(rgb: 0x80C610)
            reviseStackView.isHidden = false
        }
    }
    
    // 더보기 버튼의 메뉴바 세팅 function
    func setMoreButtonMenuBar() {
        let saveTitle = "Save Canvas to Album"
        let saveImage = UIImage(systemName: "square.and.arrow.down", withConfiguration: menuIconConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let deleteTitle = "Delete Canvas"
        let deleteImage = UIImage(systemName: "trash", withConfiguration: menuIconConfiguration)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let importMenu = UIAction(title: saveTitle,
                                  image: saveImage,
                                  handler: {_ in self.saveImagetoAlbum() })
        let deleteMenu = UIAction(title: deleteTitle,
                                  image: deleteImage,
                                  attributes: .destructive,
                                  handler: {_ in self.deleteAndBacktoMainVC() })
        let buttonMenu = UIMenu(children: [importMenu, deleteMenu])
        moreButton.menu = buttonMenu
    }
    
    // 메뉴바에서 saveMenu를 탭하면 해당 이미지가 앨범에 저장되는 function
    func saveImagetoAlbum() {
        if !imageStack.isEmpty{
            let image = imageStack.last!
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        }
        let alertController = UIAlertController(title: nil, message: "Successfully Saved", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
          print("OK")
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    // 메뉴바에서 deleteMenu를 탭하면 해당 canvas셀이 삭제되고 mainVC로 돌아가는 function
    func deleteAndBacktoMainVC() {
        let alertController = UIAlertController(title: nil, message: "Are you sure to delete?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel")
        }
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print("Delete")
            self.canvasDataSource.delete(self.IndexOfdataSource)
            self.dataStatus = true
            print("CanvasVC - dataStatus: \(self.dataStatus)")
            self.delegate?.canvasVCFinished(self)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    // 도구버튼콜렉션에서 1개의 도구가 선택될때 그 도구의 색이 변하고 나머지는 원래대로 action
    func oneButtonCollectionTapped() {
        for (key, value) in buttonTappedStatus {
            value == true ? changeButtonTintColor(key) : changeButtonDefaultColor(key)
        }
        print(buttonTappedStatus)
    }
    
    func changeButtonTintColor(_ key: String) {
        switch key {
        case "settingButton":
            settingButton.tintColor = UIColor(rgb:0xF40F20)
        case "eraserButton":
            let image = UIImage(named: "eraserTapped")
            eraserButton.setImage(image, for: .normal)
        case "undoButton":
            undoButton.tintColor = UIColor(rgb:0xF40F20)
        case "redoButton":
            redoButton.tintColor = UIColor(rgb:0xF40F20)
        case "searchButton":
            searchButton.tintColor = UIColor(rgb:0xF40F20)
        default:
            print("none selected")
        }
    }
    
    func changeButtonDefaultColor(_ key: String) {
        switch key {
        case "settingButton":
            settingButton.tintColor = UIColor(rgb:0x80C610)
        case "eraserButton":
            let image = UIImage(named: "eraser")
            eraserButton.setImage(image, for: .normal)
        case "undoButton":
            undoButton.tintColor = UIColor(rgb:0x80C610)
        case "redoButton":
            redoButton.tintColor = UIColor(rgb:0x80C610)
        case "searchButton":
            searchButton.tintColor = UIColor(rgb:0x80C610)
        default:
            print("none selected")
        }
    }
    
    @objc fileprivate func ButtonCollectionTapped(_ sender: UIButton) {
        switch sender{
        case settingButton:
            buttonTappedStatus = ["settingButton":true, "eraserButton":false,
                                  "undoButton":false, "redoButton":false, "searchButton": false]
            oneButtonCollectionTapped()
        case eraserButton:
            buttonTappedStatus = ["settingButton":false, "eraserButton":true,
                                  "undoButton":false, "redoButton":false, "searchButton": false]
            oneButtonCollectionTapped()
        case undoButton:
            buttonTappedStatus = ["settingButton":false, "eraserButton":false,
                                  "undoButton":true, "redoButton":false, "searchButton": false]
            oneButtonCollectionTapped()
        case redoButton:
            buttonTappedStatus = ["settingButton":false, "eraserButton":false,
                                  "undoButton":false, "redoButton":true, "searchButton": false]
            oneButtonCollectionTapped()
        case searchButton:
            buttonTappedStatus = ["settingButton":false, "eraserButton":false,
                                  "undoButton":false, "redoButton":false, "searchButton": true]
            oneButtonCollectionTapped()
        default:
            print("none selected")
        }
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
    
    // Eraser가 탭되면 지우개 선택되는 function
    @IBAction func eraserButtonTapped(_ sender: Any) {
        print(eraserButtonTapped)
        brushWidth = 10.0
        opacity = 1.0
        color = UIColor.white
    }
    
    // Undo가 탭되면 전에 했던 액션이 되돌리기
    @IBAction func undoButtonTapped(_ sender: Any) {
        if imageStack.count > 1 {
            poppedImageStack.append(imageStack.removeLast())
            canvasImage.image = imageStack[imageStack.count - 1]
        }
        print("imageStack.count - \(imageStack.count), poppedImageStack.count - \(poppedImageStack.count)")
    }
    
    // Redo가 탭되면 전에 했던 액션 앞으로가기
    @IBAction func redoButtonTapped(_ sender: Any) {
        if poppedImageStack.count > 1 {
            imageStack.append(poppedImageStack.removeLast())
            canvasImage.image = nil
            canvasImage.image = imageStack[imageStack.count - 1]
        }
        print("imageStack.count - \(imageStack.count), poppedImageStack.count - \(poppedImageStack.count)")
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
        searchVC.view.layer.cornerRadius = 10
        
        self.present(searchVC, animated: true, completion: nil)
    }
    
    // backVC에 누르면 마지막 이미지를 fileManager에 저장하는 함수
    func saveLastCanvasImage() {
        if !imageStack.isEmpty {
            // Save Image
            let image = imageStack.last!
            let uniqueFileName: String = canvasDataSource.findUUID(IndexOfdataSource, data: canvasDataSource.data)
            
            ImageFileManager.shared.saveImage(image: image, name: uniqueFileName) { onSuccess in
              print("saveImage onSuccess: \(onSuccess)")
            }
        }
    }
    
    // 상단에 backButton을 누르면 mainVc로 돌아가는 backVC function
    @IBAction func backVC(_ sender: Any) {
        self.dataStatus = true
        print("CanvasVC - dataStatus: \(self.dataStatus)")
        self.delegate?.canvasVCFinished(self)
        saveLastCanvasImage()
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
// searchVC에서 선택한 값 가져오기
extension CanvasVC: SearchVCDelegate {
    func searchVCFinished(_ searchVC: SearchVC) {
        fetchedImageUrl = searchVC.fetchedImageUrl
        self.dataFetched = true
        print("current: CanvasVC, fetchedImageUrl: \(fetchedImageUrl), status: \(dataFetched)")
        self.fetchImageToCanvas()
        dismiss(animated: true)
    }
}

