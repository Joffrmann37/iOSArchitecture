//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol UseCaseDelegate: AnyObject {
    var repo: Repo? { get set }
    func load<T>(_ result: (Result<[T], Error>), _ completion: @escaping (Result<[T], Error>) -> Void)
}
