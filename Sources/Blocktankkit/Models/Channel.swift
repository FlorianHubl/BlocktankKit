
import Foundation

public struct Channel: Codable {
    public let order_id, ln_invoice: String
    public let total_amount: Int
    public let btc_address: String
    public let lnurl_channel: String
}
