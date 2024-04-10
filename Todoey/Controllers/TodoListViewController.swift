//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Find Me","Task1","Task2"]
    var itemArray = [Item]()
    let userDefault = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //Get the instance of AppDelgate. "UIApplication.shared" is the instance of running app
    //var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar.delegate = self
        
//        let newItem = Item()
//        newItem.title = "Do shopping"
//        newItem.done = false
//        itemArray.append(newItem)
        

        loadItemsFromDB()
        
    }
    

    
//MARK: - Tableview DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

//MARK: -TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true) //to remove the selection from list and it will behave like animation
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }  else {
            itemArray[indexPath.row].done = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
//        //To delete item from DB
//        context.delete(itemArray[indexPath.row]) //remvoe from context
//        itemArray.remove(at: indexPath.row) //removed from array
//        saveToDB()
        
    }
    
//MARK: - Add New Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newlyAdded = Item(context: self.context)
            newlyAdded.title = textField.text!
            newlyAdded.done = false
            self.itemArray.append(newlyAdded)
            self.saveToDB()

            
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    

    
//MARK: - modifing the models
    
    func saveItemToUserDefault() {
        // Saving the string array to default
        userDefault.set(itemArray, forKey: "TodoListArray1")
    }
    
    func saveToDB() {
        
        //This method is encoding the array and saving it to file
        do {
            
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItemsFromDB() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        } catch{
            print("Error while fetching data from DB \(error)")
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    //MARK: - Search releated functions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
           itemArray = try context.fetch(request)
            tableView.reloadData()
        } catch{
            print("Error while fetching data from DB \(error)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //To load all the items when nothing is typed in search or search textbox has been made empty
        if searchBar.text?.count == 0 {
            loadItemsFromDB()
            tableView.reloadData()
            DispatchQueue.main.async {
                //Close the keyboard and move the control out of search textbox
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

