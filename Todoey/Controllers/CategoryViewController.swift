//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mia Tsung on 6/27/19.
//  Copyright © 2019 allenlsy. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }

   
    
    // Mark:- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel!.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    // Mark:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
       if let indexPath = tableView.indexPathForSelectedRow {
        
        destinationVC.selectedCategory = categories[indexPath.row]
        
        }
    }
    
    // Mark:- Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
            tableView.reloadData()
    }
    
    func loadCategory() {

        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
        categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // Mark:- add New Categories
    
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle:.alert )
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                
                let newCategory = Category(context: self.context)
                
                newCategory.name = textField.text!
                
                self.categories.append(newCategory)
               
                self.saveCategories()
            }
            
            alert.addTextField { (field) in
                
                field.placeholder = "Create New Category"
                
                textField = field
                
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            
    }
    
}
