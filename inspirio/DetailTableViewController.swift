//
//  DetailTableViewController.swift
//  inspirio
//
//  Created by woo song on 2/1/19.
//  Copyright © 2019 Woo Song. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {
    
    // Link context to persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var posts: [Post] = []
    
    var transProjectName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(alertRemove(press:)))
        lpgr.minimumPressDuration = 0.5
        self.tableView.addGestureRecognizer(lpgr)
        
        // Change with the selected project title
        self.title = transProjectName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        // Reload collection view
        tableView.reloadData()
    }
    
    func getData() {
        // Read Entity from CoreData into peopleArray
        do {
            let fetchRequest : NSFetchRequest<Post> = Post.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "projectName == %@", transProjectName!)
            posts = try context.fetch(fetchRequest)
            print("Post Entity Fetching Successful")
        }
        catch {
            print("Post Entity Fetching Failed")
        }
    }
    
    // Handle long press to show remove option
    @objc func alertRemove(press:UILongPressGestureRecognizer) {
        if press.state == .began {
            let p = press.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: p) {
                let alertTitle = "Remove this post?"
                
                let alertObj = UIAlertController(title: alertTitle, message: "You can't undo this", preferredStyle: .alert)
                
                alertObj.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                    print("Console: Cancel")
                }))
                
                alertObj.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (UIAlertAction) in
                    print("Console: Remove")
                    
                    let post = self.posts[indexPath.row]
                    // Delete that person from context
                    self.context.delete(post)
                    // Save context back to CoreData
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    // get fresh data
                    self.getData()
                    // Reload table view
                    self.tableView.reloadData()
                }))
                
                self.present(alertObj, animated: true)
            }
        }
    }

    // MARK: - Table view data source
    // Function to adjust TextView height to its content
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        
        let post = posts[indexPath.row]
        
        // Configure the cell...
        cell.picItem?.image =  UIImage(data: post.image!)
        cell.noteItem?.text = post.note
        if post.isStarred {
            cell.starButton.tintColor = UIColor.white
        }else {
            cell.starButton.tintColor = UIColor.init(named: "starButtonInactiveColor")
        }
        
        // Adjust height for note textview according to content
        cell.noteItemHC.constant = cell.noteItem.contentSize.height
        
        // Add event to star button
        cell.starButton.tag = indexPath.row
        cell.starButton.addTarget(self, action: #selector(toggleStarred), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc func toggleStarred(sender: UIButton){
        let index = sender.tag
        let post = posts[index]

        post.isStarred = !post.isStarred
        
        // Save change and grab fresh data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addPost") {
            // Get the new view controller using [segue destinationViewController].
            let AddView = segue.destination as! AddViewController
            
            // Pass the selected object to the new view controller.
            AddView.transProjectName_Create = transProjectName!
        }
    }
}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
