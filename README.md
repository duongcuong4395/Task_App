# MyTasks

## Screenshots and Video

List Task | SubTasks | Edit | Options | Dashboard
:-: | :-: | :-: | :-: | :-:
<img src="https://github.com/user-attachments/assets/5e365565-3c92-40b7-b725-b4befa010a7f"> | <img src="https://github.com/user-attachments/assets/4b14943b-370d-4d53-8f79-4d4aa4c3472d"> | <img src="https://github.com/user-attachments/assets/0d69df5c-42f8-4e97-b6db-e75bf1b01416"> | <img src="https://github.com/user-attachments/assets/fcb0545a-a08b-4d2a-8d25-665fb95d82d8"> | <img src="https://github.com/user-attachments/assets/8e629319-e7e8-410d-9def-4e07767b6456">

Video
:-: 
<video src="https://github.com/user-attachments/assets/622a9a05-a080-4076-ba67-6e9cb711f5f0"></video>

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
