//
//  ViewController.swift
//  Todoey
//
//  Created by Sam Bush on 3/30/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import UIKit
//be sure to import coreData
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : itemCategory?{
        //this is called as soon as the variable is set
        didSet{
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //create a file path to the documents folder, use .first since it is an array
      
        
        //set item array to stored default array
        //add if statement incase defaults array is empty
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }

        
    }

    //MARK - tableView datasource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")!
        //use .title to get title property of the itemArray object
      
        let item = itemArray[indexPath.row]
        
        let text = item.title
        cell.textLabel?.text = text
        
        //ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //the code above does the same as this if statement
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
       
        //this is how you update a value and then save using context.save()
      //  itemArray[indexPath.row].setValue("completed", forKey: "title")
        
        //how to delete an item. must remove it from the context first
       // context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)

        
        //using = ! means equals the opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        
//        //adds check mark on item.
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//
//        }
        saveItems()
//
        //removes row highlight old school method
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this area of code determines what happens when user clicks add item button in alert
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        //adds textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        //adds the action to the alert
        alert.addAction(action)
        
        //shows the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    //creating, updating and deleting requires a save
    func saveItems(){
        do{
         try context.save()
        }catch{
            print("error encoding itemArray")
        }
        
        tableView.reloadData()
    }
    
    //this function expects a request parameter but if there is not one then it makes item.fetchrequest the default value
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
       
        //query by parentCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
//
//        request.predicate = compoundPredicate
        
        
        //line below is how to fetch all items from coredata but not needed
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
        itemArray = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print(error)
        }
      
    }
    
  
}
//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //use NSPredicate to query coredata
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
     
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //ask the dispatch queue to run the main queue and then run this function. This will run the function in the background
            DispatchQueue.main.async {
                //removes keyboard and removes cursor from search
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
}


