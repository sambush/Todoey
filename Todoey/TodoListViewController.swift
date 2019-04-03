//
//  ViewController.swift
//  Todoey
//
//  Created by Sam Bush on 3/30/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Walk Dogs", "Empty Dishwasher", "Clean Patio"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        //set item array to stored default array
        //add if statement incase defaults array is empty
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
        super.viewDidLoad()
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
        
        let text = itemArray[indexPath.row]
        cell.textLabel?.text = text
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //adds check mark on item. 
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        
        //removes row highlight
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this area of code determines what happens when user clicks add item button in alert
            print("this is a test")
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
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
    

}

