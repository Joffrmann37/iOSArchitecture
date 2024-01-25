//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `FriendsViewModel` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension FriendsViewModel {
	static var never: FriendsViewModel {
		results([])
	}
	
	static func once(_ friends: [Friend]) -> FriendsViewModel {
		results([.success(friends)])
	}
	
	static func results(_ results: [Result<[Friend], Error>]) -> FriendsViewModel {
		var results = results
		return resultBuilder { results.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[Friend], Error>) -> FriendsViewModel {
		FriendsViewModelStub(resultBuilder: resultBuilder)
	}
	
	private class FriendsViewModelStub: FriendsViewModel {
		private let nextResult: () -> Result<[Friend], Error>
		
		init(resultBuilder: @escaping () -> Result<[Friend], Error>) {
			nextResult = resultBuilder
            super.init()
		}
		
		override func loadFriends(friends: [Friend], completion: @escaping (Result<[Friend], Error>) -> Void) {
			completion(nextResult())
		}
	}
}
