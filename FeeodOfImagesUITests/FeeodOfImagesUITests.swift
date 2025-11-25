import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        let app = XCUIApplication()
        app.launch()
        
        let authenticateButton = app.buttons["Войти"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5))
        authenticateButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        sleep(3)
        
        // Ввод логина
        let loginTextField = webView.textFields.element(boundBy: 0)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        sleep(2)
        loginTextField.typeText("...")
        
        // Переход к паролю
        webView.tap()
        sleep(1)
        
        let passwordTextField = webView.secureTextFields.element(boundBy: 0)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        // Пытаемся ввести пароль разными способами
        passwordTextField.tap()
        sleep(3)
        
        // Способ 1: Обычный ввод
        passwordTextField.typeText("..")
        sleep(1)
        
        // Проверяем, ввелось ли
        if passwordTextField.value as? String != "..." {
            // Способ 2: Через paste
            UIPasteboard.general.string = "..."
            passwordTextField.doubleTap()
            sleep(1)
            if app.menuItems["Paste"].waitForExistence(timeout: 2) {
                app.menuItems["Paste"].tap()
            }
        }
        
        sleep(1)
        
        // Нажимаем кнопку входа
        let loginButton = webView.buttons["Login"]
        if loginButton.waitForExistence(timeout: 5) {
            loginButton.tap()
        }
        
        // Ждем загрузки
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["name lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        app.buttons["logout_button"].tap()
        
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
