//
//  ViewController.swift
//  Filtros
//
//  Created by ENRIQUE VERGARA  on 10/1/19.
//  Copyright © 2019 ENRIQUE VERGARA . All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    
    var currentImage : UIImage!
    var context : CIContext!
    var currentFilter : CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filtros"
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }

    @objc func importPicture() {
        let piker = UIImagePickerController()
        piker.allowsEditing = true
        piker.delegate = self
        present(piker, animated: true)
    }
    
    @objc func image(_ image : UIImage, didFinishPickingMediaWithError error: Error?, contextInfo : UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!!", message: "Se ha guardado en tus fotos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}
        currentImage = image
        let beginImage = CIImage(image: currentImage)
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        guard let image = imageView.image  else { return }
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       #selector(image(_:didFinishPickingMediaWithError:contextInfo:)),
                                       nil)
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Selecciona el filtro", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    @IBAction func intensityChange(_ sender: UISlider) {
        applyProcessing()
    }
    
    func applyProcessing() {
//        guard let image = currentFilter.outputImage else { return }
//        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)

        //        if let cgimg = context.createCGImage(image, from: image.extent) {
        //            let processedImage = UIImage(cgImage: cgimg)
        //            imageView.image = processedImage
        //        }

        let inputKEys = currentFilter.inputKeys
        if inputKEys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKEys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKEys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKEys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
        
        
    }
    
    func setFilter(action : UIAlertAction) {
        guard currentImage != nil else {return}
        
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    }

}

