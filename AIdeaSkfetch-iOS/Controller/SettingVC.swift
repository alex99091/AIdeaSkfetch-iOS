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
    
    @IBOutlet weak var brushValueLabel: UILabel!
    @IBOutlet weak var opacityValueLabel: UILabel!
    @IBOutlet weak var hexValueLabel: UILabel!
    
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
    func setupSliders() {
        // brush
        brushCircularSlider.minimumValue = 0
        brushCircularSlider.maximumValue = 100
        brushCircularSlider.endPointValue = 10
        brushCircularSlider.addTarget(self, action: #selector(updateBrush), for: .valueChanged)
        
        // opacity
        opacityCircularSlider.minimumValue = 0.0
        opacityCircularSlider.maximumValue = 1.0
        opacityCircularSlider.endPointValue = 1.0
        opacityCircularSlider.addTarget(self, action: #selector(updateOpacity), for: .valueChanged)
        
        // color
        colorPalletteSlider.addTarget(self, action: #selector(updateColors), for: .valueChanged)
    }
    
    
    // MARK: - User Interaction methods
    @objc func updateBrush() {
        var selectedBrush = Int(brushCircularSlider.endPointValue)
        selectedBrush = (selectedBrush == 0 ? 100 : selectedBrush)
        brushValueLabel.text = String(format: "%.1d", selectedBrush)
    }
    
    @objc func updateOpacity() {
        var selectedOpacity = Float(opacityCircularSlider.endPointValue)
        selectedOpacity = (selectedOpacity == 0 ? 1.0 : selectedOpacity)
        opacityValueLabel.text = String(format: "%.2f", selectedOpacity)
    }
    @objc func updateColors() {
        let color = selectedColor
        hexValueLabel.text = "#\(color.hexValue())"
    }
}


