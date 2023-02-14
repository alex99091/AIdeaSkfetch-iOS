//
//  SettingVC.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/12.
//

import UIKit
import HGCircularSlider
import FlexColorPicker

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
    
    // MARK: - Property
    static let identifier = String(describing: SettingVC.self)
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Method
    @IBAction func heartButtonTab(_ sender: Any) {
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
        var selectedBrush = Float(brushCircularSlider.endPointValue)
        selectedBrush = (selectedBrush == 0 ? 50 : selectedBrush)
        brushValueLabel.text = String(format: "%.1f", selectedBrush)
        drawPreview()
    }
    
    @objc func updateOpacity() {
        var selectedOpacity = Float(opacityCircularSlider.endPointValue)
        selectedOpacity = (selectedOpacity == 0 ? 1.0 : selectedOpacity)
        opacityValueLabel.text = String(format: "%.2f", selectedOpacity)
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
        let selectedBrush = Int(brushCircularSlider.endPointValue)
        let selectedOpacity = Float(opacityCircularSlider.endPointValue)
        let color = selectedColor
        let rgb = hexStringToRGB(hex: color.hexValue())
        
        context.setLineCap(.round)
        context.setLineWidth(CGFloat(selectedBrush))
        context.setStrokeColor(UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: CGFloat(selectedOpacity)).cgColor)
        context.move(to: CGPoint(x: 45, y: 45))
        context.addLine(to: CGPoint(x: 45, y: 45))
        context.strokePath()
        previewImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
