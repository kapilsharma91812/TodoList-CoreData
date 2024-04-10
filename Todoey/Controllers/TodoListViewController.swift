//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Find Me","Task1","Task2"]
    var itemArray = [Item]()
    let userDefault = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
//        let newItem = Item()
//        newItem.title = "Do shopping"
//        newItem.done = false
//        itemArray.append(newItem)
        
        //loadStringArrayFromUserDefault()
        loadCustomItemsFromFile()
        
    }
    

    
//MARK - Tableview DataSource methods
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

//MARK -TableView Delegate Methods
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
    }
    
//MARK - Add New Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newlyAdded = Item()
            newlyAdded.title = textField.text!
            newlyAdded.done = false
            self.itemArray.append(newlyAdded)
            //self.saveItemToUserDefault()
            self.saveItemToFile()

            
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
//MARK - modifing the models
    
    func saveItemToUserDefault() {
        // Saving the string array to default
        userDefault.set(itemArray, forKey: "TodoListArray1")
    }
    
    func saveItemToFile() {
        
        //This method is encoding the array and saving it to file
        do {
            
            //Enconding & Saving the Custom Item Array to file Items.plist
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCustomItemsFromFile() {
        //This method will decode the data from Items.plist via userDefaults and will load in array
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error in decoding item array, \(error)")
            }
            
        }
    }
    
    func loadStringArrayFromUserDefault() {
        //Reading String array from user Defaults
        //        if let items = userDefault.array(forKey: "TodoListArray1") as? [String] {
        //            itemArray = items
        //        }
    }
}

