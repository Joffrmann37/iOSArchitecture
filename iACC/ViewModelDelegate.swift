//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    var useCase: UseCaseDelegate? { get set }
}
