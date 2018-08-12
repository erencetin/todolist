//
//  ViewController.swift
//  EasyShoppingList
//
//  Created by eren cetin on 01/07/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = ["Yogurth","Apple juice", "Egg", "Patatoes"]
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
         if let  items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items;
        }
        
    }
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row];
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let row = tableView.cellForRow(at: indexPath)!
        
        if row.accessoryType == .checkmark {
            row.accessoryType = .none;
        }
        else
        {
            row.accessoryType = .checkmark;
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - Add new items
    @IBAction func btnAddNew(_ sender: UIBarButtonItem) {
        var txtAlert = UITextField()
        let alertController = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if txtAlert.text != nil && txtAlert.text != ""
            {
                self.itemArray.append(txtAlert.text!)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData();
            }
            
            
        }
       
       
        alertController.addTextField { (alertTextField) in
            txtAlert = alertTextField;
            txtAlert.placeholder = "Create new item"
        }
         alertController.addAction(alertAction);
         present(alertController, animated: true, completion: nil);
    }
    
    
}

