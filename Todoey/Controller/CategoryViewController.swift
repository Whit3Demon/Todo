//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nikolai Kolmykov on 05.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    
    var realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        tableView.rowHeight = 80
        //swift_release(t)
    }
   
    
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField{alertTextField in
            alertTextField.placeholder = "Create new category"
            textFiled = alertTextField
            
        }
        
        let action = UIAlertAction(title: "Add category", style: .default){ (action) in
            
            print("Normalek")
             
            
            let a = Category()
            a.name = textFiled.text ?? "New Category"
            self.swift_release(a)
            
            self.save(category: a)
            
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    func save(category: Category){
         
        do{
  
            try realm.write{
                realm.add(category)
            }
        } catch{
            print("error saving \(error)")
        }
    }
    
    func load(){

        categoryArray = realm.objects(Category.self)

    }

    override func updateModel(at indexPath: IndexPath) {
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
            }
        }
}
