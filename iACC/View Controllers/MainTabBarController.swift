//	
// Copyright © Essential Developer. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    private var friendsCache: FriendsCache!
    private var isSentFromTransfers: Bool = false
    private var shouldLoadFriendsFromCache: Bool = false
    
    convenience init(friendsCache: FriendsCache, isSentFromTransfers: Bool, shouldLoadFriendsFromCache: Bool) {
		self.init(nibName: nil, bundle: nil)
        self.friendsCache = friendsCache
        self.isSentFromTransfers = isSentFromTransfers
        self.shouldLoadFriendsFromCache = shouldLoadFriendsFromCache
		self.setupViewController()
	}

	private func setupViewController() {
		viewControllers = [
			makeNav(for: makeFriendsList(), title: "Friends", icon: "person.2.fill"),
			makeTransfersList(),
			makeNav(for: makeCardsList(), title: "Cards", icon: "creditcard.fill")
		]
	}
	
	private func makeNav(for vc: UIViewController, title: String, icon: String) -> UIViewController {
		vc.navigationItem.largeTitleDisplayMode = .always
		
		let nav = UINavigationController(rootViewController: vc)
		nav.tabBarItem.image = UIImage(
			systemName: icon,
			withConfiguration: UIImage.SymbolConfiguration(scale: .large)
		)
		nav.tabBarItem.title = title
		nav.navigationBar.prefersLargeTitles = true
		return nav
	}
	
	private func makeTransfersList() -> UIViewController {
		let sent = makeSentTransfersList()
		sent.navigationItem.title = "Sent"
		sent.navigationItem.largeTitleDisplayMode = .always
		
		let received = makeReceivedTransfersList()
		received.navigationItem.title = "Received"
		received.navigationItem.largeTitleDisplayMode = .always
		
		let vc = SegmentNavigationViewController(first: sent, second: received)
		vc.tabBarItem.image = UIImage(
			systemName: "arrow.left.arrow.right",
			withConfiguration: UIImage.SymbolConfiguration(scale: .large)
		)
		vc.title = "Transfers"
		vc.navigationBar.prefersLargeTitles = true
		return vc
	}
	
	private func makeFriendsList() -> ListViewController {
		let vc = ListViewController()
        vc.friendsCache = friendsCache
        vc.title = "Friends"
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: vc, action: #selector(addFriend))
        let isPremium = User.shared?.isPremium ?? false
        let cache = isPremium ? self.friendsCache : NullFriendsCache()
        FriendsViewModel.shared.select = { item in
            vc.select(item)
        }
        let serviceAdapter = FriendsViewModelAdapter(select: { friend in
            vc.select(friend)
        }, viewModel: FriendsViewModel.shared).retry(2)
        let cacheAdapter = FriendsViewModelCacheAdapter(cache: cache ?? FriendsCache(), select: { friend in
            vc.select(friend)
        }, viewModel: FriendsViewModel.shared)
        let shouldLoadCache = isPremium && shouldLoadFriendsFromCache
        vc.itemsVMAdapter = shouldLoadCache ? serviceAdapter.fallback(cacheAdapter) : serviceAdapter
		return vc
	}
	
	private func makeSentTransfersList() -> ListViewController {
		let vc = ListViewController()
        vc.navigationItem.title = "Sent"
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: vc, action: #selector(sendMoney))
        TransfersViewModel.shared.select = { item in
            vc.select(item)
        }
        vc.itemsVMAdapter = TransfersViewModelAdapter(longDateStyle: true, select: { transfer in
            vc.select(transfer)
        }, viewModel: TransfersViewModel.shared).retry(1)
		return vc
	}
	
	private func makeReceivedTransfersList() -> ListViewController {
		let vc = ListViewController()
        vc.navigationItem.title = "Received"
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Request", style: .done, target: vc, action: #selector(requestMoney))
        if !isSentFromTransfers {
            TransfersViewModel.shared.select = { item in
                vc.select(item)
            }
        }
        vc.itemsVMAdapter = TransfersViewModelAdapter(longDateStyle: false, select: { transfer in
            vc.select(transfer)
        }, viewModel: TransfersViewModel.shared).retry(1)
		return vc
	}
	
	private func makeCardsList() -> ListViewController {
		let vc = ListViewController()
        vc.title = "Cards"
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: vc, action: #selector(addCard))
        CardsViewModel.shared.select = { item in
            vc.select(item)
        }
        vc.itemsVMAdapter = CardsViewModelAdapter(select: { card in
            vc.select(card)
        }, viewModel: CardsViewModel.shared)
		return vc
	}
	
}

// Null Object Pattern

class NullFriendsCache: FriendsCache {
    override func save(_ newFriends: [ViewModel]) {}
}
