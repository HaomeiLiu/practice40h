//
//  ShareViewController.swift
//  practice40h
//
//  Created by 刘昊嵋 on 2021/5/5.
//

import UIKit
import Photos

class ShareViewController: UIViewController, UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self

    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func userDidTappedDone(_ sender: UIButton) {
        shareToInstagramFeed(image: imageView.image ?? UIImage(imageLiteralResourceName: "practice_bg"))
    }
    
    @IBAction func userDidTappedExit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageView.contentMode = .scaleAspectFit
                imageView.image = pickedImage
            }
            
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    func shareToInstagramFeed(image: UIImage) {
        // build the custom URL scheme
        guard let instagramUrl = URL(string: "instagram://app") else {
            return
        }

        // check that Instagram can be opened
        if UIApplication.shared.canOpenURL(instagramUrl) {
            // build the image data from the UIImage
            guard let imageData = image.jpegData(compressionQuality: 100) else {
                return
            }

            // build the file URL
            let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.ig")
            let fileUrl = URL(fileURLWithPath: path)

            // write the image data to the file URL
            do {
                try imageData.write(to: fileUrl, options: .atomic)
            } catch {
                // could not write image data
                return
            }

            // instantiate a new document interaction controller
            let documentController = UIDocumentInteractionController(url: fileUrl)
            documentController.delegate = self
            // the UTI is given by Instagram
            documentController.uti = "com.instagram.photo"

            // open the document interaction view to share to Instagram feed
            documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Failed to connect to Facebook", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

