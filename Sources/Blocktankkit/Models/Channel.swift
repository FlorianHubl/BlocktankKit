
import Foundation

public struct Channel: Codable {
    let order_id, ln_invoice: String
    let total_amount: Int
    let btc_address: String
    let lnurl_channel: String
}
