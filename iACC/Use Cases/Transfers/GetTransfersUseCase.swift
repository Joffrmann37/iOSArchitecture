//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

class GetTransfersUseCase {
    private let transfersAPI: TransfersAPI
    
    init(transfersAPI: TransfersAPI) {
        self.transfersAPI = transfersAPI
    }
    
    func loadTransfers(result: (Result<[Transfer], Error>), completion: @escaping (Result<[Transfer], Error>) -> Void) {
        transfersAPI.loadTransfers(result: result, completion: completion)
    }
}
