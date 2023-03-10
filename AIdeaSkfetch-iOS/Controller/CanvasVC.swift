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
    var canvasUUID: String = ""
    var indexOfSelectedData: Int = -1
    var dataStatus: Bool = false
    var searchStatus: Bool = true
    
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
        checkCurrentIndexOfDataSource()
        print("CanvasVC uniquename: \(canvasUUID)")
        print("CanvasVC data index: \(indexOfSelectedData)")
        checkAndload()
        trayButtonCollection.forEach{ $0.addTarget(self, action: #selector(ButtonCollectionTapped(_:)), for: .touchUpInside)}
        setMoreButtonMenuBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if searchStatus == false {
            searchFailed()
        }
        reloadInputViews()
    }
    // ????????? ???????????? Alert???????????? ??????
    func searchFailed() {
        let alertController = UIAlertController(title: "Failure", message: "Currently OPENAI API is not being provided", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
            print("okay")
            self.navigationController?.popViewController(animated: true)
            self.searchStatus = false
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Method
    // ?????? ????????? ???????????? ???????????????
    func checkAndload(){
        if canvasDataSource.data.count > 0 {
            if let image: UIImage = ImageFileManager.shared.getSavedImage(named: canvasUUID) {
                drawImage.image = image
            }
        }
    }
    
    
    // ?????? ????????? ?????? - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    // ?????? ????????? - drawSketch
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
        
        // ?????? ???????????? poppedImageStack ?????????
        poppedImageStack = []
    }
    
    // ?????? ???????????? ????????? - touchesMoved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        swiped = true
        let currentPoint = touch.location(in: view)
        drawSketch(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    
    // ????????? ????????? ?????????
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawSketch(from: lastPoint, to: lastPoint)
        }
        // ????????? ????????? drawImage??? canvas??? ????????? darwImage??? nil??? ??????
        UIGraphicsBeginImageContext(canvasImage.frame.size)
        canvasImage.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        drawImage?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        canvasImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // imageStack??? ????????? ????????? ????????????
        imageStack.append(canvasImage.image!)
        
        drawImage.image = nil
    }
    
    
    // ???????????? ???????????? ???????????? canvas??? ????????? ?????????
    func fetchImageToCanvas() {
        
        UIGraphicsBeginImageContext(canvasImage.frame.size)
        canvasImage.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        if fetchedImageUrl.count > 0 {
            fetchedImage.load(url: URL(string: fetchedImageUrl)!)
        }
        fetchedImage?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        canvasImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        fetchedImage.image = nil
        dataFetched = false
        // ImageView : View Hiearchy ??????
        // self.fetchImage.sendSubViewToBack(self.mainImage)
    }
    
    // ??????????????? ????????? ?????? ??????????????? ????????????, ?????? ????????? action
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
    
    // ????????? ????????? ????????? ?????? function
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
    
    // ??????????????? saveMenu??? ????????? ?????? ???????????? ????????? ???????????? function
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
    
    // ?????? ????????????, ?????? ????????? ???????????? ???????????? function
    func deleteImageFileTogether() {
        if canvasDataSource.data.count > 0 {
            ImageFileManager.shared.deleteImage(named: canvasUUID) { onSuccess in
                print("delete = \(onSuccess)")
            }
        }
    }
    // ?????? ???????????? ??? ?????? ?????????????????? ????????? ?????????????????? ?????????????????? ?????? index??? return?????? ??????
    func checkCurrentIndexOfDataSource() {
        indexOfSelectedData = canvasDataSource.findTargetedIndexWithUUID(canvasDataSource.data, selectedUUID: canvasUUID)
    }
    
    // ??????????????? deleteMenu??? ????????? ?????? canvas?????? ???????????? mainVC??? ???????????? function
    func deleteAndBacktoMainVC() {
        let alertController = UIAlertController(title: nil, message: "Are you sure to delete?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel")
        }
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print("Delete")
            self.canvasDataSource.delete(self.indexOfSelectedData)
            self.deleteImageFileTogether()
            self.dataStatus = true
            print("CanvasVC - dataStatus: \(self.dataStatus)")
            self.delegate?.canvasVCFinished(self)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    // ??????????????????????????? 1?????? ????????? ???????????? ??? ????????? ?????? ????????? ???????????? ???????????? action
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
    
    
    // ???????????? ???????????? ?????????????????? ???????????? function
    @IBAction func settingButtonTabbed(_ sender: Any) {
        print("settingButton Tabbed")
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: SettingVC.identifier) as! SettingVC
        // ??????VC??? ??? ????????????
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
    
    // Eraser??? ????????? ????????? ???????????? function
    @IBAction func eraserButtonTapped(_ sender: Any) {
        print(eraserButtonTapped)
        brushWidth = 10.0
        opacity = 1.0
        color = UIColor.white
    }
    
    // Undo??? ????????? ?????? ?????? ????????? ????????????
    @IBAction func undoButtonTapped(_ sender: Any) {
        if imageStack.count > 1 {
            poppedImageStack.append(imageStack.removeLast())
            canvasImage.image = imageStack[imageStack.count - 1]
        }
        print("imageStack.count - \(imageStack.count), poppedImageStack.count - \(poppedImageStack.count)")
    }
    
    // Redo??? ????????? ?????? ?????? ?????? ???????????????
    @IBAction func redoButtonTapped(_ sender: Any) {
        if poppedImageStack.count > 1 {
            imageStack.append(poppedImageStack.removeLast())
            canvasImage.image = nil
            canvasImage.image = imageStack[imageStack.count - 1]
        }
        print("imageStack.count - \(imageStack.count), poppedImageStack.count - \(poppedImageStack.count)")
    }
    
    // Search ?????? ????????? search?????? ???????????? function
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
    
    // backVC??? ????????? ????????? ???????????? fileManager??? ???????????? ??????
    func saveLastCanvasImage() {
        if !imageStack.isEmpty {
            // Save Image
            let image = imageStack.last!
            deleteImageFileTogether() // ?????????????????? imageFile clear
            ImageFileManager.shared.saveImage(image: image, name: canvasUUID) { onSuccess in
              print("saveImage onSuccess: \(onSuccess)")
            }
        }
    }
    
    // ????????? backButton??? ????????? mainVc??? ???????????? backVC function
    @IBAction func backVC(_ sender: Any) {
        self.dataStatus = true
        print("CanvasVC - dataStatus: \(self.dataStatus)")
        self.delegate?.canvasVCFinished(self)
        saveLastCanvasImage()
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - SettingVCDelegate
// settingVC?????? ????????? ??? ????????????
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
// searchVC?????? ????????? ??? ????????????
extension CanvasVC: SearchVCDelegate {
    func searchVCFinished(_ searchVC: SearchVC) {
        fetchedImageUrl = searchVC.fetchedImageUrl
        self.dataFetched = true
        searchStatus = false
        print("current: CanvasVC, fetchedImageUrl: \(fetchedImageUrl), status: \(dataFetched)")
        self.fetchImageToCanvas()
        dismiss(animated: true)
    }
}

