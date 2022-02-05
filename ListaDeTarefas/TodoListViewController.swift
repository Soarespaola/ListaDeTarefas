//
//  ViewController.swift
//  ListaDeTarefas
//
//  Created by Paola Alcantara Soares on 05/02/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Limpar casa", "Fazer compras", "Estudar"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            
            itemArray = items
            
        }
        
        let appearance = UINavigationBarAppearance()
               appearance.configureWithTransparentBackground()
               appearance.backgroundColor = UIColor.systemGray
               appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
               navigationItem.standardAppearance = appearance
               navigationItem.scrollEdgeAppearance = appearance
    }
//MARK: - UITableViewController Datasource Methods
    
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField ()
        
        let alert = UIAlertController(title: "Add new Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // aqui vai ser o que acontecerá quando o usuario clicar no botao adicionar item no UIAlert
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
            

        
        
    }
    
}

