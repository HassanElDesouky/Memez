//
//  EditViewController.swift
//  Memez
//
//  Created by Hassan El Desouky on 12/16/17.
//  Copyright © 2017 Hassan El Desouky. All rights reserved.
//

import UIKit
import Foundation

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let imagePicker = UIImagePickerController()
   
    //MARK: OUTLETS
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        // assign delegates
        imagePicker.delegate = self
        topText.delegate = self
        bottomText.delegate = self
        
        //set default text in the textboxe
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        // function to apply styles
        func textStyles(text: UITextField) {
            // style the field
            text.backgroundColor = UIColor.clear
            text.borderStyle = .none
            text.tintColor = UIColor.white
            // characters attributes
            let textAttributes: [String:Any] = [
                NSAttributedStringKey.strokeWidth.rawValue: -3.0,
                NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
                NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 30)!,
            ]
            
            topText.defaultTextAttributes = textAttributes
            topText.textAlignment = .center
            bottomText.defaultTextAttributes = textAttributes
            bottomText.textAlignment = .center
            
        }
        // applying the text function
        textStyles(text: topText)
        textStyles(text: bottomText)
    }
    
    

   
    //MARK: IMAGE SELECTION
    
     // camera button
    @IBAction func cameraAction(_ sender: UIBarButtonItem) {
        // check if a camera is available on the device, disable button if not
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)

    }
    
    // select an image from album
    @IBAction func albumAction(_ sender: UIBarButtonItem) {
        // opens album on phone
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage! {
            photoView.contentMode = .scaleAspectFill
            photoView.image = selectedImage
        }
            dismiss(animated: true, completion: nil)
    }
    
    // dismiss the image picker if the user presses cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: CANCEL BUTTON
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

