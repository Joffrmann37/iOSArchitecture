//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol ListItemViewModel {
    var title: String { get set }
    var subtitle: String { get set }
    var select: () -> Void { get set }
}

struct ViewModel: ListItemViewModel, Equatable {
    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        return lhs.title == rhs.title
    }
    
    var title: String
    var subtitle: String
    var select: () -> Void
}

extension ViewModel {
    init(friend: Friend, selection: @escaping () -> Void) {
        title = friend.name
        subtitle = friend.phone
        select = selection
    }
}

extension ViewModel {
    init(card: Card, selection: @escaping () -> Void) {
        title = card.number
        subtitle = card.holder
        select = selection
    }
}

extension ViewModel {
    init(transfer: Transfer, longDateStyle: Bool, selection: @escaping () -> Void) {
        let numberFormatter = Formatters.number
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = transfer.currencyCode
        
        let amount = numberFormatter.string(from: transfer.amount as NSNumber)!
        title = "\(amount) • \(transfer.description)"
        
        let dateFormatter = Formatters.date
        if longDateStyle {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            subtitle = "Sent to: \(transfer.recipient) on \(dateFormatter.string(from: transfer.date))"
        } else {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            subtitle = "Received from: \(transfer.sender) on \(dateFormatter.string(from: transfer.date))"
        }
        select = selection
    }
}
