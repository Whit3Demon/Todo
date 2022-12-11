//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ==  false ? .none : .checkmark
            
        }
        else{
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch{
                print("error saving")
            }
        }
        
        tableView.reloadData()
        
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
            
            if let currentCategory = self.selectedCategory{
                
                do{
                    
                    try self.realm.write{
                        let a = Item()
                        a.title = textFiled.text?.count == 0 ? "New Item" : textFiled.text!
                        a.dataCreated = Date()
                        currentCategory.items.append(a)
                    }
                    
                } catch{
                    
                    print("error saving new item with \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel)

        alert.addAction(action)
        alert.addAction(cancelButton)
        present(alert, animated: true)
        
    }
    
    func save(item: Item){
        
        do{
            
            try realm.write(){
                realm.add(item)
            }
        } catch{
            print("error saving \(error)")
        }
    }
    
    
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    override func updateModel(at indexPath: IndexPath) {
            if let itemForDeletion = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
            }
        }
    
    override func updateModelChange(at indexPath: IndexPath) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Еnter a new items name", message: "", preferredStyle: .alert)
        
        alert.addTextField{alertTextField in
            alertTextField.placeholder = "new name item"
            textFiled = alertTextField
            
            
            let action = UIAlertAction(title: "Update", style: .default){ (action) in
                
                if let updateItem = self.todoItems?[indexPath.row]{
                    try! self.realm.write{
                        updateItem.title = textFiled.text?.count != 0 ? textFiled.text! : "New item"
                    }

                self.tableView.reloadData()
                }
            }
            
            let cancelButton = UIAlertAction(title: "cancel", style: .cancel)
  
            alert.addAction(action)
            alert.addAction(cancelButton)
            self.present(alert, animated: true)
            
        }
    }

    
}



extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dataCreated", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
