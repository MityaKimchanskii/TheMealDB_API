//
//  CategoryTests.swift
//  TheMealDB_APIUnitTests
//
//  Created by Mitya Kim on 4/9/23.
//

import Foundation
import XCTest

@testable import TheMealDB_API

class CategoryTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    func testCanParse() throws {
        let json = """
            {
                "strCategory" : "Beef",
            }
        """
        
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(Category.self, from: data)
        
        XCTAssertEqual(result.categoryName, "Beef")
    }
}

