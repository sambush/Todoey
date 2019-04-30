//
//  ViewController.swift
//  Todoey
//
//  Created by Sam Bush on 3/30/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
  var selectedCategory : Category?{
    //this is called as soon as the variable is set
      didSet{
         loadItems()
    }
   }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //create a file path to the documents folder, use .first since it is an array
      
        
        //set item array to stored default array
        //add if statement incase defaults array is empty
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            todoItems = items
//        }

        
    }

    //MARK - tableView datasource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")!
        //use .title to get title property of the todoItems object
      
        if let item = todoItems?[indexPath.row]{
        
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        }else{
            cell.textLabel?.text = "No items"

        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //check to see if todo list items is not nil, if it is not..
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write{
                //this is how you delete with realm
                //realm.delete(item)
                //item done equals the opposite of item done
                item.done = !item.done
            }
            }catch{
                print(error)
            }
        }
        
        tableView.reloadData()
        //removes row highlight old school method
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this area of code determines what happens when user clicks add item button in alert
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date() 
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
                
            }
            
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
    

    
   
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

        
}
//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
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


