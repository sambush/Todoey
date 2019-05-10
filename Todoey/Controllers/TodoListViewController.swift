//
//  ViewController.swift
//  Todoey
//
//  Created by Sam Bush on 3/30/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
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

        tableView.rowHeight = 80.0
        
      
     
       
    }
    
    //this function loads just after the viewDidLoad
    override func viewWillAppear(_ animated: Bool){
        
        //use guard if if statement does not hane else and should pass 99% of time, use guard with optionals
        guard let colorHex = selectedCategory?.catColor else {fatalError()}
            
            title = selectedCategory?.name
            //change the color of the navigation controller
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colorHex)
            
            searchBar.barTintColor = UIColor(hexString: colorHex)
            
            navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)
        
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)]

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError()}
        
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
    }
    

    //MARK - tableView datasource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

      
        if let item = todoItems?[indexPath.row]{
        
        
        cell.textLabel?.text = item.title
    
            if let color = UIColor(hexString: selectedCategory?.catColor ?? "1D98F6")!.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
              
                cell.backgroundColor = color
                //this changes the color of the text depending upon the cell color 
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)

            }
            
    
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
    
    //MARK: - delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
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


