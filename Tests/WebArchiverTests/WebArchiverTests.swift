import XCTest
@testable import WebArchiver

final class WebArchiverTests: XCTestCase {
    
    func testArchiving() {
        
        let url = URL(string: "https://nshipster.com/wkwebview/")!
        let expectation = self.expectation(description: "Archiving job finishes")
        
        WebArchiver.archive(url: url) { result in
            
            expectation.fulfill()
            
            guard let data = result.plistData else {
                XCTFail("No data returned!")
                return
            }
            
            XCTAssertTrue(data.count > 0)
            XCTAssertTrue(result.errors.isEmpty)
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testArchieWithMainResource() {
        
        let url = URL(string: "https://nshipster.com/wkwebview/")!
        let group = DispatchGroup()
        var htmlStr = ""
        
        group.enter()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                XCTFail("No data returned!")
                return
            } else if let data = data {
                htmlStr = String(data: data, encoding: .utf8) ?? ""
            }
            group.leave()
        }
        task.resume()
        group.wait()
        
        
        let expectation = self.expectation(description: "Archiving job finishes")
        
        WebArchiver.archiveWithMainResource(url: url, htmlContent: htmlStr) { result in
            
            expectation.fulfill()
            
            guard let data = result.plistData else {
                XCTFail("No data returned!")
                return
            }
            
            XCTAssertTrue(data.count > 0)
            XCTAssertTrue(result.errors.isEmpty)
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    static var allTests = [
        ("Test Archiving", testArchiving),
    ]
}
