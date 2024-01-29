//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct GetTransfersUseCaseAdapter: ItemsUseCaseAdapter {
    static var shared = GetTransfersUseCase()
    let longDateStyle: Bool
    let select: (Transfer) -> Void
    var useCase: GetTransfersUseCase
    
    init(longDateStyle: Bool, select: @escaping (Transfer) -> Void, useCase: GetTransfersUseCase) {
        self.longDateStyle = longDateStyle
        self.select = select
        self.useCase = useCase
    }
    
    func load(_ completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        useCase.loadTransfers(completion: completion)
    }
}
