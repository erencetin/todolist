//
//  ViewController.swift
//  EasyShoppingList
//
//  Created by eren cetin on 01/07/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {
    var realm : Realm! 
    var items : Results<NoteItem>!
    var selectedCategory:Category? {
        didSet{
            loadData();
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        loadData()
        
        
    }
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.noteText;
            cell.accessoryType = item.isCompleted ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
        do{
            try realm.write {
                if let currentItem = items?[indexPath.row]{
                    currentItem.isCompleted = !currentItem.isCompleted
                    self.tableView.reloadData()
                }
            }
        }
        catch{
            print("noteItem couldnt be updated. because of : \(error)");
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
                if let currentCategory = self.selectedCategory{
                    do{
                        
                        try self.realm.write {
                            let newNoteItem = NoteItem()
                            newNoteItem.noteText = txtAlert.text!
                            newNoteItem.isCompleted = false;
                            newNoteItem.dateCreated = Date()
                            currentCategory.noteItems.append(newNoteItem);
                        }
                    }
                    catch{
                        print("error during inserting new noteItem into the database error:\(error)")
                    }
                    
                }
                
                self.loadData()
            }
        }
        alertController.addTextField { (alertTextField) in
            txtAlert = alertTextField;
            txtAlert.placeholder = "Create new item"
        }
        alertController.addAction(alertAction);
        present(alertController, animated: true, completion: nil);
    }
    //MARK: - Save and load items
    func saveItems(noteItem : NoteItem){
        do{
            try realm.write {
                try realm.add(noteItem)
            }
        }
        catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadData(){
        let sortDescriptors = [SortDescriptor(keyPath: "isCompleted", ascending: false),SortDescriptor(keyPath: "dateCreated", ascending: true)]
        items = selectedCategory?.noteItems.sorted(by: sortDescriptors)//.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData();
    }
    
}
extension ToDoListViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar: searchBar,searchText: "")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchBar: searchBar,searchText: searchText)
    }
    func search(searchBar: UISearchBar, searchText: String?){
        if searchText == "" {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        else{
            items = items?.filter("noteText CONTAINS[cd] %@",searchText).sorted(byKeyPath: "dateCreated",ascending: true)
            
        }
        self.tableView.reloadData()
        
    }
}
