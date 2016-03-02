//
//  MapSettingsViewController.swift
//  StoreLocJonathanC
//
//  Created by Jonny Cameron on 17/02/2016.
//  Copyright © 2016 Jonny Cameron. All rights reserved.
//

import UIKit

class MapSettingsViewController: UIViewController {

    @IBOutlet weak var colorPreview: UIImageView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var delegate: MapSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorPreview.backgroundColor = calculateColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateColor() -> UIColor {
        
        let redValue = CGFloat(redSlider.value)
        let greenValue = CGFloat(greenSlider.value)
        let blueValue = CGFloat(blueSlider.value)
        
        let color = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1)
        
        return color
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        colorPreview.backgroundColor = calculateColor()
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
        delegate = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? MapSettingsDelegate
        delegate?.didChangeLineColor(self.colorPreview.backgroundColor!)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
