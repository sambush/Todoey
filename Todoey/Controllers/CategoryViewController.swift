//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sam Bush on 4/14/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [itemCategory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
       
    }

 
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("button pressed")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = itemCategory(context: self.context)
            
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
           print("cancel")
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Tableview DataSource Methods (display all categories)
    
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        
        let item = categoryArray[indexPath.row]
        
        let categoryName = item.name
        
        cell.textLabel?.text = categoryName
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods (what happens when you click on a cell)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //this functions occurs right before the seque occurs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //the selectedCategory property is in the TodoListViewController
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        //get category that corresponds to the selected cell - determine what is the selected cell
        
        
    }
    
    
    //MARK: - Tableview Delegate Methods (save data and load data)
    
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(with request:NSFetchRequest<itemCategory> = itemCategory.fetchRequest()){
        
        do{
           categoryArray = try context.fetch(request)
           tableView.reloadData()
        }catch{
            print(error)
        }
        
    }
    


   
}
