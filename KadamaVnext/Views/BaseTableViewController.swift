//
//  BaseTableViewController.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import UIKit
import Foundation

class BaseTableViewController<T: BaseTableViewCell<U>, U>: UITableViewController {
    
    let cellId = "id"
    var viewModel : PokemonManager?
    var items = [U]() {
        didSet{
            tableView?.reloadData()
        }
    }
    
    func loadData(){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(T.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = rc
        self.loadData()
    }
    
    @objc func handleRefresh() {
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: TableView delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell<U>
        cellForRowAt(indexPath: indexPath, cell: cell)
        cell.item = items[indexPath.row]
        if indexPath.row == (self.items.count) - 50 { // last 50th cell
            self.loadData()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(indexPath: indexPath)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {}
    func cellForRowAt(indexPath: IndexPath,cell:BaseTableViewCell<U>) {}
}
