//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct GetTransfersUseCase: UseCaseDelegate {
    var transfersRepo: TransfersRepo
    let select: (Transfer) -> Void
    let longDateStyle: Bool
    
    var service: ItemsService? {
        get {
            return TransfersRepoAdapter(repo: transfersRepo, select: select, longDateStyle: longDateStyle)
        }
        set {}
    }
}
