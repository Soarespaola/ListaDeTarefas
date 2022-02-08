//
//  ViewController.swift
//  ListaDeTarefas
//
//  Created by Paola Alcantara Soares on 05/02/22.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?

    let realm = try! Realm()
    
   
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    var selectedCategory : Category? {
        didSet{
            
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        let appearance = UINavigationBarAppearance()
               appearance.configureWithTransparentBackground()
               appearance.backgroundColor = UIColor.systemPink
               appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
               navigationItem.standardAppearance = appearance
               navigationItem.scrollEdgeAppearance = appearance
        
     
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
        if let colourHex = selectedCategory?.colour {
                title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
                }
        if let navBarColour = UIColor(hexString: colourHex) {
            navBar.barTintColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                }
            }
        }
//MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return todoItems?.count ?? 1
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = super.tableView(tableView, cellForRowAt: indexPath)
           if let item = todoItems?[indexPath.row] {
               
               cell.textLabel?.text = item.title
               
               if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                   cell.backgroundColor = colour
                   cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
               }
               cell.accessoryType = item.done ? .checkmark : .none
           } else {
               cell.textLabel?.text = "Nenhum item adicionado"
           }
           
           return cell
       }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {

                    item.done = !item.done
                }
            } catch {
            print("Error saving done status, \(error)")
        }
    }
    
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField ()
        
        let alert = UIAlertController(title: "Adicionar novo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Adicionar Item", style: .default) { (action) in
            // aqui vai ser o que acontecerá quando o usuario clicar no botao adicionar item no UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
            

        
        
    }
    
    //MARK: - Model manipulation Methods
    
    func loadItems() {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
        
        override func updateModel(at indexPath: IndexPath) {
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write{
                        realm.delete(item)
                    }
                } catch {
                    print("Error deleting item, \(error)")
                }
            }
        }
    }
    
//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
//    //quando o usuario apagar os carecteres e ele for = 0 voltará para tela onde existe outros itens.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}
