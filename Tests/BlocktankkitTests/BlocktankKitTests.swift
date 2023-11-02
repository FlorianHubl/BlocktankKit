import XCTest
@testable import BlocktankKit

@available(iOS 13.0.0, *)
final class BlocktankKitTests: XCTestCase {
    
    let blocktank = Blocktank()
    
    func testInfo() async throws {
        let info = try await blocktank.getInfo()
        print(info)
    }
}
