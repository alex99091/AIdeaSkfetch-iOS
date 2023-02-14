//
//  SettingVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/12.
//

import UIKit
import HGCircularSlider
import FlexColorPicker

protocol SettingVCDelegate: class {
  func settingsVCFinished(_ settingVC: SettingVC)
}

class SettingVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var brushCircularSlider: CircularSlider!
    @IBOutlet weak var opacityCircularSlider: CircularSlider!
    @IBOutlet weak var colorPalletteSlider: RadialPaletteControl!
    @IBOutlet weak var brightnessSlider: BrightnessSliderControl!
    
    @IBOutlet weak var brushValueLabel: UILabel!
    @IBOutlet weak var opacityValueLabel: UILabel!
    @IBOutlet weak var hexValueLabel: UILabel!
    
    @IBOutlet weak var previewImage: UIImageView!
    
    // MARK: - Delegate
    weak var delegate: SettingVCDelegate?
    
    // MARK: - Property
    static let identifier = String(describing: SettingVC.self)
    
    var brushValue: CGFloat = 10.0
    var opacityValue: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var selectedColor: UIColor {
        get {
            return colorPalletteSlider.selectedColor
        }
        set {
            colorPalletteSlider.selectedColor = newValue
        }
    }
    
    var changedColor: UIColor {
        get {
            return brightnessSlider.selectedColor
        }
        set {
            brightnessSlider.selectedColor = newValue
        }
    }
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliders()
        drawPreview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Method
    @IBAction func heartButtonTab(_ sender: Any) {
        delegate?.settingsVCFinished(self)
    }
    
    func setupSliders() {
        // brush
        brushCircularSlider.minimumValue = 0
        brushCircularSlider.maximumValue = 50.0
        brushCircularSlider.endPointValue = 10.0
        brushCircularSlider.addTarget(self, action: #selector(updateBrush), for: .valueChanged)
        
        // opacity
        opacityCircularSlider.minimumValue = 0
        opacityCircularSlider.maximumValue = 1.00
        opacityCircularSlider.endPointValue = 1.00
        opacityCircularSlider.addTarget(self, action: #selector(updateOpacity), for: .valueChanged)
        
        // color
        colorPalletteSlider.addTarget(self, action: #selector(updateColors), for: .valueChanged)
        brightnessSlider.addTarget(self, action: #selector(matchColor), for: .valueChanged)
    }
    
    
    // MARK: - User Interaction methods
    @objc func updateBrush() {
        brushValue = brushCircularSlider.endPointValue
        brushValue = brushValue == 0 ? 50 : brushValue
        brushValueLabel.text = String(format: "%.1f", brushValue)
        drawPreview()
    }
    
    @objc func updateOpacity() {
        opacityValue = opacityCircularSlider.endPointValue
        opacityValue = opacityValue == 0 ? 1.0 : opacityValue
        opacityValueLabel.text = String(format: "%.2f", opacityValue)
        drawPreview()
    }
    @objc func updateColors() {
        let color = selectedColor
        hexValueLabel.text = "#\(color.hexValue())"
        drawPreview()
    }
    
    @objc func matchColor() {
        let color = changedColor
        hexValueLabel.text = "#\(color.hexValue())"
        brightnessSlider.selectedColor = colorPalletteSlider.selectedColor
        brightnessSlider.selectedColor = changedColor
        drawPreview()
    }
    
    func hexStringToRGB (hex:String) -> [CGFloat] {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return [red, green, blue]
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(previewImage.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        brushValue = brushCircularSlider.endPointValue
        opacityValue = opacityCircularSlider.endPointValue
        let color = selectedColor
        let rgb = hexStringToRGB(hex: color.hexValue())
        red = rgb[0]
        green = rgb[1]
        blue = rgb[2]
        context.setLineCap(.round)
        context.setLineWidth(brushValue)
        context.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        context.move(to: CGPoint(x: 45, y: 45))
        context.addLine(to: CGPoint(x: 45, y: 45))
        context.strokePath()
        previewImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
