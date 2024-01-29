//	
// Copyright © Essential Developer. All rights reserved.
//

import XCTest
@testable import iACC

///
/// When dealing with legacy code, you most likely won't be able to test screens independently
/// because all dependencies are accessed directly through Singletons or passed from one
/// view controller to another.
///
/// So the simplest way to start testing legacy code is to write Integration Tests covering the
/// behavior from the view controllers all the way to deeper dependencies such as database
/// and network classes.
///
/// Writing fast and reliable Integration Tests before making changes to a legacy codebase can
/// give you confidence that you don't break existing behavior. If you trust those tests and they
/// still pass after a change, you're sure you didn't break anything.
///
/// That's why it's important to write tests you trust before making a change in legacy code.
///
/// So good Integration Tests can give you the confidence you didn't break anything when they pass.
/// But when they fail, it can be hard to find out *why it failed* and *where is the problem* because
/// many components are being tested together. The problem could be in a view, or in a model,
/// or in the database, or in the network component... You probably will have to debug to find the issue.
///
/// Thus, Integration Tests shouldn't be your primary testing strategy. Instead, you should focus on
/// testing components in isolation. So if the tests fail, you know exactly why and where.
///
/// But Integration Tests can be a simple way to start adding coverage to a legacy project until you can
/// break down the components and test them in isolation.
///
/// So to make this legacy project realistic, we kept the entangled legacy classes to show how you can start
/// testing components in integration without making massive changes to the project.
///
class FriendsIntegrationTests: XCTestCase {
	
	override func tearDown() {
		SceneBuilder.reset()
		
		super.tearDown()
	}
	
	func test_friendsList_title() throws {
		let friendsList = try SceneBuilder().build().friendsList()
		
		XCTAssertEqual(friendsList.title, "Friends")
	}
	
	func test_friendsList_hasAddFriendButton() throws {
		let friendsList = try SceneBuilder().build().friendsList()
		
		XCTAssertTrue(friendsList.hasAddFriendButton, "add friend button not found")
	}
	
	func test_friendsList_addFriendButton_showsAddFriendViewOnTap() throws {
		let friendsList = try SceneBuilder().build().friendsList()
		
		XCTAssertFalse(friendsList.isPresentingAddFriendView, "precondition: shouldn't present add friend view before tapping button")
		
		friendsList.tapAddFriendButton()
		
		XCTAssertTrue(friendsList.isPresentingAddFriendView, "should present add friend view after tapping button")
	}
	
	func test_friendsList_withNonPremiumUser_showsFriends_whenAPIRequestSucceeds() throws {
		let friend0 = aFriend(name: "a name", phone: "a phone")
		let friend1 = aFriend(name: "another name", phone: "another phone")
		let friendsList = try SceneBuilder()
			.build(
				user: nonPremiumUser(),
                getFriendsUseCase: .once(GetFriendsUseCase.shared.getMappedItemViewModels(friends: [friend0, friend1])),
				friendsCache: .never
			)
			.friendsList()
		
		XCTAssertEqual(friendsList.numberOfFriends(), 2, "friends count")
		XCTAssertEqual(friendsList.friendName(at: 0), friend0.name, "friend name at row 0")
		XCTAssertEqual(friendsList.friendPhone(at: 0), friend0.phone, "friend phone at row 0")
		XCTAssertEqual(friendsList.friendName(at: 1), friend1.name, "friend name at row 1")
		XCTAssertEqual(friendsList.friendPhone(at: 1), friend1.phone, "friend name at row 1")
	}
		
	func test_friendsList_showsLoadingIndicator_untilAPIRequestSucceeds() throws {
		let friendsList = try SceneBuilder()
			.build(
                getFriendsUseCase: GetFriendsUseCase.resultBuilder(.success(GetFriendsUseCase.shared.getMappedItemViewModels(friends: [aFriend()]))),
				friendsCache: .never
			)
			.friendsList()
		
        XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request completes")
		
        friendsList.simulateRefresh()
		
        XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refresh request completes")
	}
		
	func test_friendsList_withNonPremiumUser_showsLoadingIndicator_whileRetryingAPIRequests() throws {
		let friendsList = try SceneBuilder()
			.build(
				user: nonPremiumUser(),
                getFriendsUseCase: GetFriendsUseCase.resultBuilder(.failure(anError())),
				friendsCache: .never
			)
			.friendsList()

		XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator after retrying API requests")

		friendsList.simulateRefresh()

		XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator after retrying API refresh requests")
	}
	
	func test_friendsList_showsLoadingIndicator_whileRetryingAPIRequest_andLoadingFromCache() throws {
		let friendsList = try SceneBuilder()
			.build(
				user: premiumUser(),
                getFriendsUseCase: GetFriendsUseCase.resultBuilder(.failure(anError())),
				friendsCache: .resultBuilder {
					return .failure(anError())
				}
			)
			.friendsList()
		
		XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator once Cache request completes")
		
		friendsList.simulateRefresh()
		
		XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator once Cache refresh request completes")
	}
	
	func test_friendsList_withNonPremiumUser_showsError_afterRetryingFailedAPIRequestTwice() throws {
        let cacheArray = FriendsCache.getMappedItemViewModels(friends: [aFriend(), aFriend()])
		let friendsList = try SceneBuilder()
			.build(
				user: nonPremiumUser(),
				getFriendsUseCase: .results([
					.failure(NSError(localizedDescription: "1st request error")),
					.failure(NSError(localizedDescription: "1st retry error")),
					.failure(NSError(localizedDescription: "2nd retry error"))
				]),
				friendsCache: .once(cacheArray)
			)
			.friendsList()
		
		XCTAssertEqual(friendsList.numberOfFriends(), 0, "friends count")
		XCTAssertEqual(friendsList.errorMessage(), "2nd retry error", "error message")
	}
	
	func test_friendsList_withPremiumUser_showsCachedFriends_afterRetryingFailedAPIRequestTwice() throws {
		let friend0 = aFriend(name: "a name", phone: "a phone")
		let friend1 = aFriend(name: "another name", phone: "another phone")
        let cacheArray = FriendsCache.getMappedItemViewModels(friends: [friend0, friend1])
        
		let friendsList = try SceneBuilder()
			.build(
				user: premiumUser(),
				getFriendsUseCase: .results([
					.failure(NSError(localizedDescription: "1st request error")),
					.failure(NSError(localizedDescription: "1st retry error")),
					.failure(NSError(localizedDescription: "2nd retry error"))
				]),
				friendsCache: .once(cacheArray)
			)
			.friendsList()
		
		XCTAssertEqual(friendsList.numberOfFriends(), 2, "friends count")
		XCTAssertEqual(friendsList.friendName(at: 0), friend0.name, "friend name at row 0")
		XCTAssertEqual(friendsList.friendPhone(at: 0), friend0.phone, "friend phone at row 0")
		XCTAssertEqual(friendsList.friendName(at: 1), friend1.name, "friend name at row 1")
		XCTAssertEqual(friendsList.friendPhone(at: 1), friend1.phone, "friend name at row 1")
	}
	
	func test_friendsList_withPremiumUser_showsError_whenCacheFails_afterRetryingFailedAPIRequestTwice() throws {
		let friendsList = try SceneBuilder()
			.build(
				user: premiumUser(),
				getFriendsUseCase: .results([
					.failure(NSError(localizedDescription: "1st request error")),
					.failure(NSError(localizedDescription: "1st retry error")),
					.failure(NSError(localizedDescription: "2nd retry error"))
				]),
				friendsCache: .once(NSError(localizedDescription: "cache error"))
			)
			.friendsList()
		XCTAssertEqual(friendsList.numberOfFriends(), 0, "friends count")
        XCTAssertNotNil(friendsList.errorMessage())
	}
	
	func test_friendsList_canRefreshData() throws {
        let refreshedFriend = aFriend(name: "refreshed name", phone: "refreshed phone")
        		
		var friendsList = try SceneBuilder()
			.build(
                getFriendsUseCase: .results([.success([])])
			)
			.friendsList()
		
		XCTAssertEqual(friendsList.numberOfFriends(), 0, "friends count before refreshing")
		
		friendsList.simulateRefresh()
        
        friendsList = try SceneBuilder()
            .build(
                getFriendsUseCase: .results([.success(GetFriendsUseCase.shared.getMappedItemViewModels(friends: [refreshedFriend]))])
            )
            .friendsList()
		
		XCTAssertEqual(friendsList.numberOfFriends(), 1, "friends count after refreshing")
		XCTAssertEqual(friendsList.friendName(at: 0), refreshedFriend.name, "refreshed friend name at row 0")
		XCTAssertEqual(friendsList.friendPhone(at: 0), refreshedFriend.phone, "refreshed friend phone at row 0")
	}
	
	func test_friendsList_refreshData_retriesTwiceOnAPIFailure() throws {
        var getTransfersUseCase: [Result<[ItemViewModel], Error>] = ([
            .failure(NSError(localizedDescription: "1st request error")),
            .failure(NSError(localizedDescription: "1st retry error")),
            .failure(NSError(localizedDescription: "2nd retry error")),
        ])
		var friendsList = try SceneBuilder()
			.build(
				getFriendsUseCase: .results(getTransfersUseCase),
				friendsCache: .never
			)
			.friendsList()
		
		XCTAssertEqual(friendsList.errorMessage(), "2nd retry error", "error message before refresh")
		
		friendsList.hideError()
		
		XCTAssertEqual(friendsList.errorMessage(), nil, "error message after hiding error")
		
		friendsList.simulateRefresh()
        
        getTransfersUseCase.append(contentsOf: [.failure(NSError(localizedDescription: "1st refresh error")),
                         .failure(NSError(localizedDescription: "1st refresh retry error")),
                         .failure(NSError(localizedDescription: "2nd refresh retry error"))])
        friendsList = try SceneBuilder()
            .build(
                getFriendsUseCase: .results(getTransfersUseCase),
                friendsCache: .never
            )
            .friendsList()
		
		XCTAssertEqual(friendsList.errorMessage(), "2nd refresh retry error", "error message after refresh")
	}
	
	func test_friendsList_refreshData_withPremiumUser_showsCachedFriends_afterRetryingFailedAPIRequestTwice() throws {
		let friend0 = aFriend(name: "a name", phone: "a phone")
		let friend1 = aFriend(name: "another name", phone: "another phone")
        let cacheArray = FriendsCache.getMappedItemViewModels(friends: [friend0, friend1])
        let getTransfersUseCase: GetFriendsUseCase = .results([
            .success([]),
            .failure(NSError(localizedDescription: "1st request error")),
            .failure(NSError(localizedDescription: "1st retry error")),
            .failure(NSError(localizedDescription: "2nd retry error"))
        ])
		
		var friendsList = try SceneBuilder()
			.build(
				user: premiumUser(),
				getFriendsUseCase: getTransfersUseCase,
				friendsCache: .once([])
			)
			.friendsList()
		
		XCTAssertEqual(friendsList.numberOfFriends(), 0, "friends count before refreshing")
		
		friendsList.simulateRefresh()
        
        friendsList = try SceneBuilder()
            .build(
                user: premiumUser(),
                getFriendsUseCase: getTransfersUseCase,
                friendsCache: .once(cacheArray)
            )
            .friendsList()
        		
		XCTAssertEqual(friendsList.numberOfFriends(), 2, "friends count after refreshing")
		XCTAssertEqual(friendsList.friendName(at: 0), friend0.name, "friend name at row 0")
		XCTAssertEqual(friendsList.friendPhone(at: 0), friend0.phone, "friend phone at row 0")
		XCTAssertEqual(friendsList.friendName(at: 1), friend1.name, "friend name at row 1")
		XCTAssertEqual(friendsList.friendPhone(at: 1), friend1.phone, "friend name at row 1")
	}
	
	func test_friendsList_withNonPremiumUser_doesntCacheItems_whenAPIRequestSucceeds() throws {
		let friend0 = aFriend()
		let friend1 = aFriend()
		var cachedItems = [[ItemViewModel]]()
        let vms = GetFriendsUseCase.shared.getMappedItemViewModels(friends: [friend0, friend1])
		
		_ = try SceneBuilder()
			.build(
				user: nonPremiumUser(),
                getFriendsUseCase: .once(GetFriendsUseCase.shared.getMappedItemViewModels(friends: [friend0, friend1])),
                friendsCache: .saveCallback(vms, { friends in
                    cachedItems.append(friends)
                })
			)
			.friendsList()
		
		XCTAssertEqual(cachedItems, [], "Shouldn't have cached items")
	}
	
	func test_friendsList_withPremiumUser_cachesItems_whenAPIRequestSucceeds() throws {
		let friend0 = aFriend()
		let friend1 = aFriend()
        let cacheArray = FriendsCache.getMappedItemViewModels(friends: [friend0, friend1])
		var cachedItems = [[ItemViewModel]]()
        let vms = GetFriendsUseCase.shared.getMappedItemViewModels(friends: [friend0, friend1])
		
		_ = try SceneBuilder()
			.build(
				user: premiumUser(),
                getFriendsUseCase: .once(vms),
                friendsCache: .saveCallback(uuids: [friend0.id, friend1.id], vms, { friends in
                    cachedItems.append(friends)
                })
			)
			.friendsList()
		
		XCTAssertEqual(cachedItems, [cacheArray], "Should have cached items")
	}
	
	func test_friendsList_canSelectAPIFriend() throws {
		let friend0 = aFriend(name: "a name", phone: "a phone")
		let friend1 = aFriend(name: "another name", phone: "another phone")
        let getTransfersUseCase: GetFriendsUseCase = .results([
            .success(GetFriendsUseCase.shared.getMappedItemViewModels(friends: [friend0, friend1])),
        ])
        let friendsList = try SceneBuilder()
			.build(
				user: premiumUser(),
                getFriendsUseCase: getTransfersUseCase,
				friendsCache: .never
			)
			.friendsList()
        getTransfersUseCase.select(friend0)
        friendsList.selectFriend(at: 0)
		XCTAssertTrue(friendsList.isShowingDetails(for: friend0), "should show friend details at row 0")
		
        getTransfersUseCase.select(friend1)
		friendsList.selectFriend(at: 1)
		XCTAssertTrue(friendsList.isShowingDetails(for: friend1), "should show friend details at row 1")
	}

	func test_friendsList_canSelectCachedFriend() throws {
		let friend0 = aFriend(name: "a name", phone: "a phone")
		let friend1 = aFriend(name: "another name", phone: "another phone")
        let cacheArray = FriendsCache.getMappedItemViewModels(friends: [friend0, friend1])
        let getTransfersUseCase: GetFriendsUseCase = .results([
            .failure(anError()),
            .failure(anError()),
            .failure(anError())
        ])
		
		let friendsList = try SceneBuilder()
			.build(
				user: premiumUser(),
				getFriendsUseCase: getTransfersUseCase,
				friendsCache: .once(cacheArray)
			)
			.friendsList()
		
        getTransfersUseCase.select(friend0)
		friendsList.selectFriend(at: 0)
		XCTAssertTrue(friendsList.isShowingDetails(for: friend0), "should show friend details at row 0")
		
        getTransfersUseCase.select(friend1)
		friendsList.selectFriend(at: 1)
		XCTAssertTrue(friendsList.isShowingDetails(for: friend1), "should show friend details at row 1")
	}

}

private extension ContainerViewControllerSpy {
	///
	/// Provides ways of extracting the "friends" list view controller from the root tab bar
	/// without coupling the tests with internal implementation details, such as the tab item index.
	/// So we can later change those internal details easily without breaking the tests.
	///
	func friendsList() throws -> ListViewController {
		let vc = try XCTUnwrap((rootTab(atIndex: 0) as UINavigationController).topViewController as? ListViewController, "couldn't find friends list")
		vc.prepareForFirstAppearance()
		return vc
	}
}

///
/// This `ListViewController` test helper extension provides ways of extracting values
/// from the view controller without coupling the tests with internal implementation details, such as
/// table views, labels, and buttons. So we can later change those internal details without
/// breaking the tests.
///
private extension ListViewController {
	func numberOfFriends() -> Int {
		numberOfRows(atSection: friendsSection)
	}
	
	func friendName(at row: Int) -> String? {
		title(at: IndexPath(row: row, section: friendsSection))
	}
	
	func friendPhone(at row: Int) -> String? {
		subtitle(at: IndexPath(row: row, section: friendsSection))
	}
	
	func selectFriend(at row: Int) {
		select(at: IndexPath(row: row, section: friendsSection))
		RunLoop.current.run(until: Date())
	}
	
	func isShowingDetails(for friend: Friend) -> Bool {
		let vc = navigationController?.topViewController as? FriendDetailsViewController
		return vc?.friend == friend
	}
	
	var hasAddFriendButton: Bool {
		navigationItem.rightBarButtonItem?.systemItem == .add
	}
	
	var isPresentingAddFriendView: Bool {
		navigationController?.topViewController is AddFriendViewController
	}
	
	func tapAddFriendButton() {
		navigationItem.rightBarButtonItem?.simulateTap()
		RunLoop.current.run(until: Date())
	}
	
	private var friendsSection: Int { 0 }
}
