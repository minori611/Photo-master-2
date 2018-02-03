//
//  editPhotoViewController.swift
//  photo
//
//  Created by Minori_n on 2017/09/09.
//  Copyright © 2017年 那須美律. All rights reserved.
//

import UIKit
import Accounts

class editPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    var originalImage: UIImage!
    var filter: CIFilter!
    var brightness = 1.0
    var contrast = 1.0
    var exposure = 0.5
    var saturation = 1.0
    let slider = UISlider(frame: CGRect(x:0, y:0, width:300, height:30))
    private var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openAlbum()
    }
    
    func addSlider() {
        slider.layer.position = CGPoint(x:self.view.frame.midX, y:600)
        slider.layer.cornerRadius = 10.0
        slider.layer.shadowOpacity = 0.5
        slider.layer.masksToBounds = false
        slider.tintColor = UIColor.gray
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.setValue(0.0, animated: true)
    }
    
    func addButton() {
        button = UIButton()
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        let posX: CGFloat = self.view.frame.width/2 - bWidth/2
        let posY: CGFloat = self.view.frame.height/2 - bHeight/2
        button.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.removeSlider(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo Info: [String : Any]) {
        imageView.image = Info[UIImagePickerControllerEditedImage] as? UIImage
        
        originalImage = imageView.image
        
        dismiss(animated: true, completion: nil)
    }
    
    //スライダーの削除
    @objc func removeSlider(sender: UIButton) {
        slider.removeFromSuperview()
        button.removeFromSuperview()
    }
    
    //brightness
    @IBAction func brightnessButton() {
        addSlider()
        addButton()
        slider.addTarget(self, action: #selector(self.changeBrightness(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
        
    }
    
    @objc func changeBrightness(sender: UISlider) {
        brightness = Double(sender.value)
        changeFilter()
        
    }
    
    /*//contrast
    @IBAction func contrastButton() {
        addSlider()
        addButton()
        slider.addTarget(self, action: #selector(self.changeContrast(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
    }
    
    @objc func changeContrast(sender: UISlider) {
        print(sender.value)
        contrast = Double(sender.value)*10
        //changeFilter()
    }
    
    //exposure
    @IBAction func exposureButton() {
        addSlider()
        addButton()
        slider.addTarget(self, action: #selector(self.changeExposure(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
    }
    
    @objc func changeExposure(sender: UISlider) {
        exposure = Double(sender.value)
        changeFilter()
    }
    
    //saturation
    @IBAction func saturaionButton() {
        addSlider()
        addButton()
        slider.addTarget(self, action: #selector(self.changeSaturation(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
    }
    
    @objc func changeSaturation(sender: UISlider) {
        saturation = Double(sender.value)
        changeFilter()
    }*/
    
    func changeFilter() {
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //filter
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        //brightness
        filter.setValue(brightness, forKey: "inputBrightness")
        
        //contrast
        filter.setValue(contrast, forKey: "inputContrast")
        
        //exposure
        filter.setValue(exposure, forKey: "inputEV")
        
        //saturation
        filter.setValue(saturation, forKey: "inputSaturation")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        imageView.image = UIImage(cgImage: cgImage!)
    }
    
    @IBAction func sharePhoto(){
        let shareImage = imageView.image!
        let activityItems: [Any] = [shareImage]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let excludeAcitivityTypes = [UIActivityType.postToWeibo, .saveToCameraRoll, .print]
        activityViewController.excludedActivityTypes = excludeAcitivityTypes
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

