//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 20/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import Firebase

class ChatListController: UITableViewController,UISearchResultsUpdating{
    
    let cellId = "cellId"
    var matchs = [User]()
    var filteredUsers = [User]()
    var curUsr = User()
    let email = ""
    let uid = FIRAuth.auth()?.currentUser?.uid
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Regresar", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        getCurUser()
        
        fetchMatchs()
        
        observeMessages()

    }
    
    func observeMessages(){
        
        FIRDatabase.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let message = Message()
                
                message.id = snapshot.key
                message.setValuesForKeys(dictionary)
                print("Msg: \(message.text)")
            }
            
            }, withCancel: nil)
    }
    
    func fetchMatchs(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            
            //print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                
                
                //print(user.name,user.email)
                if self.curUsr.email != user.email{
                    self.matchs.append(user)
                }
                
             
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
             
             }
            
            }, withCancel: nil)
    }
    
    func getCurUser(){
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with:
            {snapshot in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.curUsr.setValuesForKeys(dictionary)
                }
        
            })
    }
    
    //Hola hola
    func handleCancel(){
        /*let chatL = MainController()
        let navController = UINavigationController(rootViewController: chatL)
        present(navController,animated: true,completion: nil)*/
        dismiss(animated: true,completion:nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return matchs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user: User
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            user = matchs[indexPath.row]
        }
        
        cell.textLabel?.text = user.petname!
        cell.detailTextLabel?.text = "Su dueño es "+user.name!
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatL = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        /*chatL.user = matchs[indexPath.row]*/
        if searchController.isActive && searchController.searchBar.text != "" {
            chatL.user = filteredUsers[indexPath.row]
        } else {
            chatL.user = matchs[indexPath.row]
        }
        let navController = UINavigationController(rootViewController: chatL)
        present(navController,animated: true,completion: nil)
        
    }

    
    func showChatLogController(_ user : User){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    class UserCell: UITableViewCell {
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = matchs.filter { user in
            return (user.petname?.lowercased().contains((searchController.searchBar.text?.lowercased())!))!
        }
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    

    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    
    
    
    
}

