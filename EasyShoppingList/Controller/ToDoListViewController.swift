//
//  ViewController.swift
//  EasyShoppingList
//
//  Created by eren cetin on 01/07/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [NoteItems]()
    var selectedCategory:Category? {
        didSet{
            loadData();
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        
    }
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].noteText;
        cell.accessoryType = itemArray[indexPath.row].isComplete ? .checkmark : .none
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        }
        else{
            cell.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    //MARK - Add new items
    @IBAction func btnAddNew(_ sender: UIBarButtonItem) {
        var txtAlert = UITextField()
        let alertController = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if txtAlert.text != nil && txtAlert.text != ""
            {
                let newNoteItem = NoteItems(context: self.context.self)
                newNoteItem.noteText = txtAlert.text!
                newNoteItem.isComplete = false;
                newNoteItem.category = self.selectedCategory;
                self.itemArray.append(newNoteItem)
                self.saveItems()
                
            }
            
            
        }
        
        
        alertController.addTextField { (alertTextField) in
            txtAlert = alertTextField;
            txtAlert.placeholder = "Create new item"
        }
        alertController.addAction(alertAction);
        present(alertController, animated: true, completion: nil);
    }
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadData(view request: NSFetchRequest<NoteItems> = NoteItems.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", (selectedCategory?.name)!);
        if let compoundPredictate =  predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,compoundPredictate])
            
        }
        else{
            request.predicate = categoryPredicate
        }
        do{
            
            itemArray = try context.fetch(request);
        }
        catch{
            print("There is an error when fetch data from db:  \(error)")
        }
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
            let request : NSFetchRequest<NoteItems> =  NoteItems.fetchRequest()
            
            let predicate = NSPredicate(format: "noteText CONTAINS [cd] %@", searchText != nil ? searchText! : searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "noteText", ascending: true)]
            loadData(view: request, predicate: predicate)
            
        }
        self.tableView.reloadData()
        
    }
}
