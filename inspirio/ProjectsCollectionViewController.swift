//
//  ProjectsCollectionViewController.swift
//  inspirio
//
//  Created by woo song on 2/2/19.
//  Copyright © 2019 Woo Song. All rights reserved.
//

import UIKit

class ProjectsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    // Link context to persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config item size per row
        // Do any additional setup after loading the view.
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(alertRemove(press:)))
        lpgr.minimumPressDuration = 0.5
        self.collectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        // Reload collection view
        collectionView.reloadData()
    }
    
    func getData() {
        // Read Entity from CoreData into peopleArray
        do {
            projects = try context.fetch(Project.fetchRequest())
            print("Project Entity Fetching Successful")
        }
        catch {
            print("Project Entity Fetching Failed")
        }
    }
    
    // Handle long press to show remove option
    @objc func alertRemove(press:UILongPressGestureRecognizer) {
        if press.state == .began {
            let p = press.location(in: self.collectionView)
            if let indexPath = self.collectionView.indexPathForItem(at: p) {
                let cell = self.collectionView!.cellForItem(at: indexPath) as! ProjectsCollectionViewCell
                let alertTitle = "Remove " + (cell.projectName.text)! + "?"
                
                let alertObj = UIAlertController(title: alertTitle, message: "You can't undo this", preferredStyle: .alert)
                
                alertObj.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                    print("Console: Cancel")
                }))
                
                alertObj.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (UIAlertAction) in
                    print("Console: Remove")
                    // extract person from array
                    let project = self.projects[indexPath.row]
                    // Delete that person from context
                    self.context.delete(project)
                    // Save context back to CoreData
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    // get fresh data
                    self.getData()
                    // Reload table view
                    self.collectionView.reloadData()
                }))
                
                self.present(alertObj, animated: true)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showProjectDetail") {
            // Get the new view controller using [segue destinationViewController].
            let PDView = segue.destination as! DetailTableViewController
            
            // Pass the selected object to the new view controller.
            PDView.transProjectName = projects[selRowNum].name
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return projects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectsCollectionViewCell
    
        let project = projects[indexPath.row]
        
        // Configure the cell
        cell.projectName?.text = project.name
        cell.projectName.sizeToFit()
        cell.backgroundColor = UIColor(hexString: project.color ?? "#111111")
        cell.layer.cornerRadius = 8.0
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let sizeW = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        let sizeH = Int(0.5 * (collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: sizeW, height: sizeH)
    }
    
    var selRowNum:Int = 0
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Assign project name of the selected collection cell
        selRowNum = indexPath.row
        self.performSegue(withIdentifier: "showProjectDetail", sender: nil)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
