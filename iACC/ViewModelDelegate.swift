//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    var useCase: UseCaseDelegate? { get set }
}

protocol UseCaseDelegate: AnyObject {
    var repo: Repo? { get set }
    func load(repoType: RepoType)
}
