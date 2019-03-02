//
//  StarredTableViewController.swift
//  inspirio
//
//  Created by woo song on 2/2/19.
//  Copyright © 2019 Woo Song. All rights reserved.
//

import UIKit
import CoreData

class StarredTableViewController: UITableViewController {
    
    // Link context to persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            fetchRequest.predicate = NSPredicate(format: "isStarred == %@", NSNumber(booleanLiteral: true))
            posts = try context.fetch(fetchRequest)
            print("Post Entity Fetching Successful")
        }
        catch {
            print("Post Entity Fetching Failed")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "starredCell", for: indexPath) as! StarredTableViewCell

        let post = posts[indexPath.row]
        
        // Configure the cell...
        cell.picItem?.image =  UIImage(data: post.image!)

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
        
        // Reload with new data
        tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
