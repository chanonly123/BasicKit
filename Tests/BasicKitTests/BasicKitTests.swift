import XCTest
@testable import BasicKit

struct User: Codable, Equatable {
    var _id: String
    var userName: String
}

final class BasicKitTests: XCTestCase {
    
    @SomeDefault("username")
    var username: String?
    
    @SomeDefault("user")
    var user: User?
    
    @SomeDefault("int")
    var int: Int?
    
    func testSomeDefaults() throws {
        
        username = "abcde"
        XCTAssert(username == "abcde")
        username = nil
        XCTAssert(username == nil)
        
        let testUser = User(_id: "abc", userName: "xyz")
        user = testUser
        XCTAssert(user == testUser)
        user = nil
        XCTAssert(user == nil)
        
        int = 10
        XCTAssert(int == 10)
        int = nil
        XCTAssert(int == nil)
    }
}
