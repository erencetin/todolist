//
//  CategoryViewController.swift
//  EasyShoppingList
//
//  Created by eren cetin on 31/07/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import UIKit
import RealmSwift
 class CategoryViewController: UITableViewController {
    
    var categories : Results<Category>!
    var realm: Realm!
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        LoadData()
        
    }
    
    //MARK - TableView overriden methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDoItems", sender: self);
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController;
        let rowId = tableView.indexPathForSelectedRow?.row;
        destinationViewController.selectedCategory = categories[rowId!];
    }
    //MARK - Control Events
    @IBAction func btnAddClick(_ sender: UIBarButtonItem) {
        var txtAlert = UITextField()
        let alertController = UIAlertController(title:"Add new category",message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if txtAlert.text != nil && txtAlert.text != ""{
                let newCategory = Category()
                newCategory.name = txtAlert.text!
            
                self.SaveData(category: newCategory)
                
            }
        }
        alertController.addTextField { (alertTextField) in
            txtAlert = alertTextField
            txtAlert.placeholder = "Create new category"
        }
        alertController.addAction(alertAction);
        present(alertController, animated: true, completion: nil);
    }
    //MARK - CRUD Methods
    func LoadData(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    func SaveData(category:Category){
        do{
            try realm.write {
                try realm.add(category)
            }
        }
        catch{
            print("error when create a new category. error : \(error)")
            
        }
        self.tableView.reloadData();
    }

}
