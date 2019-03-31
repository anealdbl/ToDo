//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Anil Dhaubhadel on 21/3/19.
//  Copyright © 2019 Anil Dhaubhadel. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategores()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  categories?.count ?? 1
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added yet."
        //cell.delegate = self
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text?.count != 0 {
                
                let categoryItem = Category()
                categoryItem.name = textField.text!
                
                //self.categories.append(categoryItem)
                
                self.save(category:categoryItem)
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Add New Item"
            textField = UITextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //MARK : - Data Manipulation Methods
    
    func loadCategores() {
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //
        //        do {
        //            categoryArray = try context.fetch(request)
        //        }catch {
        //            print("Error on fetching data \(error)")
        //        }
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error on saving data \(error)")
        }
        //        do {
        //            try  context.save()
        //        }catch {
        //            print("Error on saving data \(error)")
        //        }
        
    }
    
    // MARK :- Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error on deleting row \(error)")
            }
        }
    }
    
    //MARK: - Helper Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
}


