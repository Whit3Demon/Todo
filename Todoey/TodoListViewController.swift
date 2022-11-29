//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["xyu","pizda","zalupaSlonika"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell"  , for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType =  tableView.cellForRow(at: indexPath)?.accessoryType ==  .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "add new Todoey item", message: "", preferredStyle: .alert)
        
        alert.addTextField{alertTextField in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField
            
        }
        
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
            
            print("Normalek")
            self.itemArray.append(textFiled.text ?? "New Item")
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
}

