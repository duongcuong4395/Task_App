# MyTasks

## Design decisions and rationale
- Core Data for Persistence: Chosen for its robust integration with SwiftUI and support for complex data relationships, ideal for managing tasks and subtasks.
- Protocol-Oriented Programming (POP): Used to enhance flexibility and code reuse, allowing for easy extension and modification of task-related logic.
- MVVM Architecture: Separates UI from business logic, improving testability and maintainability, with TaskListViewModel handling data operations.
- User Experience: Designed a clean, intuitive interface with features like expandable subtasks and seamless navigation to enhance usability.
- Local Notifications: Implemented to remind users of tasks, ensuring they stay on top of their responsibilities.
- Haptic Feedback: Added for key interactions to improve user engagement and provide a responsive experience.
  
## Future improvements you would make if given more time
- Advanced Filtering: Introduce more filtering options and custom categories for better task management.
- Enhanced Subtask Management: Allow setting individual due dates and priorities for subtasks.
- Collaboration Features: Enable task sharing and real-time collaboration.
- Custom Notifications: Provide more control over notification settings, including custom times and recurring reminders.
- Calendar Integration: Sync tasks with calendar and email services for better organization.
- Improved Onboarding: Enhance onboarding with interactive tutorials to help new users quickly learn the app.
- Cross-Device Sync: Implement data synchronization across devices for consistent task management.
- Performance Optimization: Optimize Core Data and UI performance for handling large datasets and complex interactions smoothly.

## Design Decisions
- UI:
  - SwiftUI
  - MVVM Architecture
- Principals and Patterns:
  - SOLID conformance:
    - Features are separated into modules.
    - UseCases for business logic.
  - Utilizing IoC and DI.
  - Coordinator pattern for navigation.
- Dependency Manager:
  - Swift Package Manager
