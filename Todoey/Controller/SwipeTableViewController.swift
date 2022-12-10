//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Nikolai Kolmykov on 10.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func swift_release(_ object: AnyObject){
        print("hello world!")
    }

    func updateModel(at indexPath: IndexPath) {
           // Update our data model
       }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
            
        }
        
       
                // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
       
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell"  , for: indexPath) as! SwipeTableViewCell
       
        
        cell.delegate = self
        return cell
    }
    
   
   
}
