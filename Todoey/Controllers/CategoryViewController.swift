//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sam Bush on 4/14/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{

    let realm = try! Realm()
    
    //inorder to use Realm the categories variable must be of data type Results
    //use question mark to make it an optional
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
     loadCategories()
        

       
    }

 
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("button pressed")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.catColor = UIColor(randomFlatColorOf:.light).hexValue()
            
            self.save(category: newCategory)
            
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
        //if categories is nill then return 1
        return categories?.count ?? 1
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //must got into the identity inspector for the cell and change to class SwipeTableViewCell
        //calling super goes into super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        //if categores is nil then return string text
        let item = categories?[indexPath.row].name ?? "No Categories Added"
        
        cell.textLabel?.text = item
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].catColor ?? "1D98F6")
        
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (categories?[indexPath.row].catColor)!)!, returnFlat: true)

        
        
        //add swipetableView delegate as an extension
       // cell.delegate = self
        
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        //get category that corresponds to the selected cell - determine what is the selected cell
        
        
    }
    
    
    //MARK: - Tableview Delegate Methods (save data and load data)
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        //fetch all of the objects that belong to the category datatype
        //categories was initalized and set as a Results
        categories = realm.objects(Category.self)
        tableView.reloadData()
    
    }
    //MARK: - delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }


    
   
}//end of class

