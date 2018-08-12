//
//  CategoryViewController.swift
//  EasyShoppingList
//
//  Created by eren cetin on 31/07/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import UIKit
import CoreData
 class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
        
    }
    
    //MARK - TableView overriden methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDoItems", sender: self);
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController;
        let rowId = tableView.indexPathForSelectedRow?.row;
        destinationViewController.selectedCategory = categoryArray[rowId!];
    }
    //MARK - Control Events
    @IBAction func btnAddClick(_ sender: UIBarButtonItem) {
        var txtAlert = UITextField()
        let alertController = UIAlertController(title:"Add new category",message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if txtAlert.text != nil && txtAlert.text != ""{
                let newCategory = Category(context: self.context.self)
                newCategory.name = txtAlert.text!
                self.categoryArray.append(newCategory)
                self.SaveData()
                
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
    func LoadData(view request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("something wrong during fetching data from databse error: \(error)")
        }
    }
    func SaveData(){
        do{
            try context.save()
        }
        catch{
            print("error when create a new category. error : \(error)")
            
        }
        self.tableView.reloadData();
    }

}
