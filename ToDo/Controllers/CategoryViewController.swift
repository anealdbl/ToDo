//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Anil Dhaubhadel on 21/3/19.
//  Copyright © 2019 Anil Dhaubhadel. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let categoryItem = categoryArray[indexPath.row]
        cell.textLabel?.text = categoryItem.name
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
                
                let categoryItem = Category(context: self.context)
                categoryItem.name = textField.text!
                
                self.categoryArray.append(categoryItem)
                
                self.saveItem()
                
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
    
    func loadItem() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("Error on fetching data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func saveItem() {
        do {
            try  context.save()
        }catch {
            print("Error on saving data \(error)")
        }
        
    }
    
    //MARK: - Helper Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
}
