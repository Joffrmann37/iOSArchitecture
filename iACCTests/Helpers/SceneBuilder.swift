//	
// Copyright © Essential Developer. All rights reserved.
//

import UIKit
@testable import iACC

///
/// This SceneBuilder test helper provides a simple way of injecting global dependencies into legacy codebases
/// and resetting them back to prevent a test from influencing the result of the next test. It lets you inject all global
/// dependencies such as time zone, locale, cache, and API services. Moreover, it wraps the root view controller
/// into a `ContainerViewControllerSpy` to enable testing modal view controller presentations in a fast and reliable way.
///
/// ---
///
/// When dealing with legacy code, you usually will have to replace global dependencies
/// with test doubles to enable testability without using slow and fragile components
/// such as network requests.
///
/// Replacing global dependencies is not ideal because changing global state can affect multiple
/// parts of the system at once, leading to slow and fragile tests.
///
/// Moreover, replacing global dependencies will prevent running tests in parallel
/// (because replacing the dependency for one test would affect other tests running in parallel!).
///
/// But it's a simple way to start testing legacy code until you can inject the dependencies
/// with proper Dependency Injection patterns.
///
/// So to make this legacy project realistic, we kept the global dependencies to show how you
/// can start testing components without making massive changes to the project.
///
struct SceneBuilder {
	static func reset() {
		User.shared = nil
		
        FriendsViewModel.shared = FriendsViewModel()
		SceneDelegate.main.cache = FriendsCache()
		TransfersViewModel.shared = TransfersViewModel()
		CardsViewModel.shared = CardsViewModel()
		
		Formatters.date.locale = .autoupdatingCurrent
		Formatters.date.timeZone = .autoupdatingCurrent
		Formatters.number.locale = .autoupdatingCurrent
	}
	
	func build(
		user: User? = nil,
		friendsViewModel: FriendsViewModel = .once([]),
		friendsCache: FriendsCache = .never,
		transfersViewModel: TransfersViewModel = .once([]),
		cardsViewModel: CardsViewModel = .once([]),
		timeZone: TimeZone = .GMT,
		locale: Locale = .en_US_POSIX
	) throws -> ContainerViewControllerSpy {
        SceneDelegate.main.window?.rootViewController = nil
        SceneDelegate.main.cache = friendsCache
        
        User.shared = user
        FriendsViewModel.shared = friendsViewModel
        TransfersViewModel.shared = transfersViewModel
        CardsViewModel.shared = cardsViewModel
		
		Formatters.date.locale = locale
		Formatters.date.timeZone = timeZone
		Formatters.number.locale = locale
		
		return ContainerViewControllerSpy(SceneDelegate.main.makeRootViewController())
	}
}

private extension SceneDelegate {
	static var main: SceneDelegate {
		(UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate)
	}
}
