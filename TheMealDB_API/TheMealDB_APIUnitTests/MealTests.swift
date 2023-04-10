//
//  File.swift
//  TheMealDB_APIUnitTests
//
//  Created by Mitya Kim on 4/9/23.
//

import Foundation
import XCTest

@testable import TheMealDB_API

class MealTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    func testCanParse() throws {
        let json = """
            {
                "strMeal" : "English Breakfast",
                "idMeal" : "12343",
                "strMealThumb" : "https://www.themealdb.com",
            }
        """
        
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(Meal.self, from: data)
        
        XCTAssertEqual(result.mealName, "English Breakfast")
        XCTAssertEqual(result.mealID, "12343")
        XCTAssertEqual(result.mealThumb, "https://www.themealdb.com")
    }
}

