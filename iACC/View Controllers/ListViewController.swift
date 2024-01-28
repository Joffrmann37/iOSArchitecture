//
// Copyright © Essential Developer. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
	var items = [ViewModel]()
    var friendsCache: FriendsCache!
    var friendsDidComplete: (() -> Void)!
    var itemsVMAdapter: ItemsViewModelAdapter?
	var retryCount = 0
	var maxRetryCount = 0
	var shouldRetry = false
	
	var longDateStyle = false
	
	var fromReceivedTransfersScreen = false
	var fromSentTransfersScreen = false
	var fromCardsScreen = false
	var fromFriendsScreen = false
	
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
        itemsVMAdapter?.load([], handleAPIResult)
//        if fromFriendsScreen {
//            friendsDidComplete()
//        } else if fromCardsScreen {
//            CardsViewModel.shared.select = { [weak self] item in
//                self?.select(item)
//            }
//            CardsViewModel.shared.loadCards(completion: handleAPIResult)
//		} else if fromSentTransfersScreen || fromReceivedTransfersScreen {
//            TransfersViewModel.shared.select = { [weak self] item in
//                self?.select(item)
//            }
//            TransfersViewModel.shared.loadTransfers(completion: handleAPIResult)
//		}
	}
	
	private func handleAPIResult(_ result: Result<[ViewModel], Error>) {
		switch result {
		case let .success(items):
			self.retryCount = 0
			
            self.items = items
			self.refreshControl?.endRefreshing()
			self.tableView.reloadData()
			
		case let .failure(error):
			if shouldRetry && retryCount < maxRetryCount {
				retryCount += 1
				
				refresh()
				return
			}
			
			retryCount = 0
			
			if fromFriendsScreen && User.shared?.isPremium == true {
				(UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).cache.loadFriends { [weak self] result in
                    guard let self = self else { return }
					DispatchQueue.mainAsyncIfNeeded {
						switch result {
						case let .success(items):
                            self.items = items.map { item in
                                ViewModel(friend: item) {
                                    FriendsViewModel.shared.select(item)
                                    self.select(item)
                                }
                            }
							self.tableView.reloadData()
							
						case let .failure(error):
                            self.show(error: error)
                        }
						self.refreshControl?.endRefreshing()
					}
				}
			} else {
                self.show(error: error)
				self.refreshControl?.endRefreshing()
			}
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
		cell.configure(item, longDateStyle: longDateStyle)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].select()
	}
}

extension UITableViewCell {
    func configure(_ vm: ViewModel, longDateStyle: Bool) {
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
