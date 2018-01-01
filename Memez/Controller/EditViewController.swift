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
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
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
    
}

