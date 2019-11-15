import XCTest
@testable import Wattpad_Assessment

class StoryViewModelProtocol_Tests: XCTestCase {
    var storyViewModel: StoryViewModelProtocol!
    
    override func setUp() {
        let story = Story(author: "A Good Author", url: "123456789", title: "A Good Title")
        storyViewModel = StoryViewModel(story)
    }
    
    func testAuthorTextShouldEqualByAGoodAuthor() {
        XCTAssertEqual(storyViewModel.authorText, "By: A Good Author")
    }
    
    func testTitleShouldEqualAGoodTitle() {
        XCTAssertEqual(storyViewModel.title, "A Good Title")
    }
    
    func testImageDownloadStateShouldBeNew() {
        XCTAssertEqual(storyViewModel.imageDownloadState, .new)
    }
    
    func testShouldDownloadImageShouldBeTrue() {
        XCTAssertTrue(storyViewModel.shouldDownloadImage)
    }
    
    func testShouldDownloadImageShouldBeFalseAfterDownload() {
        storyViewModel.imageDownloadState = .downloaded
        XCTAssertFalse(storyViewModel.shouldDownloadImage)
    }

}
