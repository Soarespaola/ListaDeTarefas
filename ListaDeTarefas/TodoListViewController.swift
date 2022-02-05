//
//  ViewController.swift
//  ListaDeTarefas
//
//  Created by Paola Alcantara Soares on 05/02/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Limpar casa", "Fazer compras", "Estudar"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
               appearance.configureWithTransparentBackground()
               appearance.backgroundColor = UIColor.systemPink
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
}

