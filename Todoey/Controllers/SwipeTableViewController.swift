//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Sam Bush on 5/1/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //must got into the identity inspector for the cell and change to class SwipeTableViewCell
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        
        
        
        //add swipetableView delegate as an extension
        cell.delegate = self
        
        return cell
    }
    
    
    //copied entire method and then modified
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath){
        
    }
    
    
}


