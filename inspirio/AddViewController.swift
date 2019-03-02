//
//  AddViewController.swift
//  inspirio
//
//  Created by woo song on 2/9/19.
//  Copyright © 2019 Woo Song. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var inputImage: UIImageView!
    @IBOutlet weak var inputNote: UITextView!
    
    var transProjectName_Create:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inputNote.text = "describe your image..."
        inputNote.textColor = UIColor.lightGray
    }
    
    // Handle placeholder for text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "describe your image..." {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//        }
//        
//        return true
//    }
    
    
    // Handle uploading/importing of photo from ios album
    @IBAction func uploadImage(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){
            // After it is completed
        }
    }
    
    var selectedImage:UIImage!
    @IBAction func addPost(_ sender: Any) {
        // Link context to persistentContainer
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // link to entity People
        let post = Post(context: context)
        
        // Update atrributes with entity
        post.projectName = transProjectName_Create
        post.isStarred = false
        post.note = inputNote.text
        post.image = selectedImage!.pngData()
        
        
        // Save to Context back to CoreData
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Pop this view controller
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            inputImage.image = image
            selectedImage = image
        }else {
            // Error Message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
