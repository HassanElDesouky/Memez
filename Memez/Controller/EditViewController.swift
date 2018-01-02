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
   
    
    // array to save the images
    var sentImges: [Meme] {
        return savedImage
    }
    
    
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
        
        // disable share button
        shareButton.isEnabled = false
        
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
                NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 45)!,
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
    
    
    
    //MARK: KEYBOARD
    
    
    // get keyboard hight
    func keyboardHight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        //return
        return keyboardSize.cgRectValue.height
    }
    
    // control sliding up and down of view
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0 - keyboardHight(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    
    // subscribe to keyboard notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // return key dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       return view.endEditing(true)
    }
    
    // click away dismisses keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // replace the default text with the user's
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    
   
    
    
    //MARK: IMAGE SELECTION
    
     // camera button
    @IBAction func cameraAction(_ sender: UIBarButtonItem) {
        // check if a camera is available on the device, disable button if not
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        shareButton.isEnabled = true
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
            shareButton.isEnabled = true
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
    
    
    //MARK: CREATE IMAGE
    
    
    func generateMemedImage() -> UIImage {
        // hide navbar and toolbar
        navBar.isHidden = true
        toolBar.isHidden = true
        // render image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return finalImage
    }
    
    
    //MARK: SAVE IMAGE
    
    
    func saveImage() {
        let image = Meme(topText: topText.text!, bottomText: bottomText.text!, image: photoView.image!, finalImage: generateMemedImage())
        savedImage.append(image)
    }
    
    
    
    
    //MARK: SHARE IMAGE
    
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        let shareImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, success, itemes, error) in
            self.saveImage()
        }
        present(activityController, animated: true, completion: nil)
    }
    
}

