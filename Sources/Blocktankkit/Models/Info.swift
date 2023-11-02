
import Foundation

public struct Info: Codable {
    public let capacity: Capacity
    public let node_info: NodeInfo
    public let services: [Service]
    
    public struct Capacity: Codable {
        public let local_balance, remote_balance: Int
    }
    
    public struct NodeInfo: Codable {
        public let alias: String
        public let active_channels_count: Int
        public let uris: [String]
        public let public_key: String
    }
    
    public struct Service: Codable {
        public let available: Bool
        public let description, product_id: String
        public let min_channel_size, max_channel_size, min_chan_expiry, max_chan_expiry: Int
        public let max_node_usd_capacity: Int
        public let order_states: OrderStates
        public let max_chan_receiving, max_chan_receiving_usd, max_chan_spending: String
        public let max_chan_spending_usd: Double
    }
    
    public struct OrderStates: Codable {
        public let CREATED, PAID, REFUNDED, URI_SET, OPENING, CLOSING, GIVE_UP, EXPIRED, REJECTED, CLOSED, OPEN: Int
    }
}
