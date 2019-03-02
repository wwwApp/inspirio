//
//  CreateViewController.swift
//  inspirio
//
//  Created by woo song on 2/4/19.
//  Copyright © 2019 Woo Song. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var inputName: UITextField!
    
    var colorArray:[UIColor] = [UIColor(red: 0.9961, green: 0.6392, blue: 0.6667, alpha: 1.0), UIColor(red: 0.9725, green: 0.7216, blue: 0.5451, alpha: 1.0), UIColor(red: 0.9804, green: 0.9725, blue: 0.5176, alpha: 1.0), UIColor(red: 0.7294, green: 0.9294, blue: 0.5686, alpha: 1.0), UIColor(red: 0.698, green: 0.8078, blue: 0.9961, alpha: 1.0), UIColor(red: 0.949, green: 0.6353, blue: 0.9098, alpha: 1.0)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectColor(press:)))
        tap.numberOfTapsRequired = 1
        colorCollectionView.addGestureRecognizer(tap)
    }
    
    // Handle long press to show remove option
    var selectedColor:UIColor?
    @objc func selectColor(press:UITapGestureRecognizer) {
            // Remove border from all colors before selection
            let colors = colorCollectionView.visibleCells
            for color in colors {
                color.layer.borderWidth = 0
            }
        
            let p = press.location(in: colorCollectionView)
            if let indexPath = colorCollectionView.indexPathForItem(at: p) {
                let cell = colorCollectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
                
                cell.layer.borderWidth = 5
                cell.layer.borderColor = UIColor.white.cgColor
                
                selectedColor = cell.backgroundColor
            }
    }
    
    @IBAction func addProject(_ sender: Any) {
        // Link context to persistentContainer
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // link to entity People
        let projects = Project(context: context)
        
        // Update atrributes with entity
        projects.name = inputName.text
        projects.color = selectedColor?.toHexString()
        
        // Save to Context back to CoreData
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Pop this view controller
        let _ = navigationController?.popViewController(animated: true)
    }

    // Number of Views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return colorArray.count
    }
    
    // Populate Views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
        
//        cell.colorButton?.layer.backgroundColor = colorArray[indexPath.row].cgColor
        cell.backgroundColor = colorArray[indexPath.row]
        cell.layer.cornerRadius = 1.5
        
        return cell
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
