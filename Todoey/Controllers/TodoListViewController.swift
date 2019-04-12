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
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create a file path to the documents folder, use .first since it is an array
      
        
        //set item array to stored default array
        //add if statement incase defaults array is empty
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }

        loadItems()
        
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
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)

        
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
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
        itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
      
    }
    

}

