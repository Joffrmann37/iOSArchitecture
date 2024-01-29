//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `GetFriendsUseCase` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension GetFriendsUseCase {
    static var never: GetFriendsUseCase {
        results([])
    }
    
    static func once(_ friends: [ViewModel]) -> GetFriendsUseCase {
        results([.success(friends)])
    }
    
    static func results(_ results: [Result<[ViewModel], Error>]) -> GetFriendsUseCase {
        var results = results
        var currentResult: Result<[ViewModel], Error> = results.removeFirst()
        for result in results {
            currentResult = result
        }
        return resultBuilder(currentResult)
    }
    
    static func resultBuilder(_ resultBuilder: Result<[ViewModel], Error>) -> GetFriendsUseCase {
        return GetFriendsUseCaseStub(resultBuilder: resultBuilder)
    }
    
    func getMappedViewModels(friends: [Friend]) -> [ViewModel] {
        return friends.map { item in
            ViewModel(friend: item) {
                
            }
        }
    }
    
    func getMappedResults(_ results: [Result<[Friend], Error>]) -> [Result<[ViewModel], Error>] {
        return results.map { result in
            switch result {
            case let .success(items):
                let vms = items.map { item in
                    ViewModel(friend: item) {
                        
                    }
                }
                return .success(vms)
            case let .failure(error):
                return .failure(error)
            }
        }
    }
	
	private class GetFriendsUseCaseStub: GetFriendsUseCase {
		private let nextResult: Result<[ViewModel], Error>
		
		init(resultBuilder: Result<[ViewModel], Error>) {
			nextResult = resultBuilder
            super.init()
		}
        
        override func loadFriends(friends: [Friend], completion: @escaping (Result<[ViewModel], Error>) -> Void) {
            completion(nextResult)
        }
	}
}
