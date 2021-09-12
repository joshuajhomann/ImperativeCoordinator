# Imperative Coordinator
This is the demo project for the Flock of Swifts Meetup on 11-Spet-2021.  We discussed how the uncooridnated app violates SOLID design principles by conflating business logic, view logic and navigation logic in a single object, resulting in code that is tightly coupled, not reusuable and not testable.  We then separated the busisness logic into a viewmodel and lifted the navigation logic into an imperative coordinator.
Next week we will write the type erases for AnyCoordinator then show how the app can be made testable and write some tests before replacing this pattern with a reactive coordinator and exploring the implications of this pattern for routing and dependency injection in SwiftUI.