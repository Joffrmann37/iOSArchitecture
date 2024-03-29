//
// Copyright © Essential Developer. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	var cache = FriendsCache()
    var isFromSentTransfersScreen = false
    var shouldLoadFriendsFromCache = false
    var result: ((Result<[ItemViewModel], Error>) -> Void)!
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else { return }
		
		window = UIWindow(windowScene: windowScene)
		window?.rootViewController = makeRootViewController()
		window?.makeKeyAndVisible()
	}
	
	func makeRootViewController() -> MainTabBarController {
        MainTabBarController(friendsCache: cache, isSentFromTransfers: isFromSentTransfersScreen, shouldLoadFriendsFromCache: shouldLoadFriendsFromCache)
	}
}
