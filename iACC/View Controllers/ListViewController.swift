//
// Copyright © Essential Developer. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
	var items = [ItemViewModel]()
    var friendsCache: FriendsCache!
    var friendsDidComplete: (() -> Void)!
    var itemsVMAdapter: ItemsUseCaseAdapter?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if tableView.numberOfRows(inSection: 0) == 0 {
			refresh()
		}
	}
	
	@objc private func refresh() {
		refreshControl?.beginRefreshing()
        itemsVMAdapter?.load(handleAPIResult)
	}
	
	private func handleAPIResult(_ result: Result<[ItemViewModel], Error>) {
		switch result {
		case let .success(items):
            self.items = items
			self.refreshControl?.endRefreshing()
			self.tableView.reloadData()
			
		case let .failure(error):
            self.show(error: error)
            self.refreshControl?.endRefreshing()
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = items[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
		cell.configure(item)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].select()
	}
}

extension UITableViewCell {
    func configure(_ vm: ItemViewModel) {
        textLabel?.text = vm.title
        detailTextLabel?.text = vm.subtitle
	}
}

extension UIViewController {
    func select(_ friend: Friend) {
        let vc = FriendDetailsViewController()
        vc.friend = friend
        show(vc, sender: self)
    }
    
    func select(_ card: Card) {
        let vc = CardDetailsViewController()
        vc.card = card
        show(vc, sender: self)
    }
    
    func select(_ transfer: Transfer) {
        let vc = TransferDetailsViewController()
        vc.transfer = transfer
        show(vc, sender: self)
    }
    
    @objc func addCard() {
        show(AddCardViewController(), sender: self)
    }
    
    @objc func addFriend() {
        show(AddFriendViewController(), sender: self)
    }
    
    @objc func sendMoney() {
        show(SendMoneyViewController(), sender: self)
    }
    
    @objc func requestMoney() {
        show(RequestMoneyViewController(), sender: self)
    }
    
    func show(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.showDetailViewController(alert, sender: self)
    }
}
