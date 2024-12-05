 

**ExpenseTracker: Expense Tracker App with SwiftUI and some ARKit Magic**

Managing expenses is no longer a chore! Introducing ExpenseTracker, a Swift-based app designed to simplify personal and business expense management. With advanced features like multi-platform authentication, expense categorization, and insightful tracking & analytics, it’s your one-stop solution to financial organization.

Note: Some features mentioned above, like ARKit-Based Expense Visualizations, are planned for future releases. Stay tuned for updates as I continue to enhance the app’s functionality and user experience.

**Key Features**

Authentication: Seamlessly log in or sign up via Google, Facebook, Apple, OpenID
Expense Management: Add, edit, delete, and bulk upload expenses using receipt or bill scanning.
Tracking & Analytics: Monitor recurring expenses and visualize spending trends with interactive dashboards.
Phases of Development

Phase 1: Authentication

Goal: Build a robust and user-friendly login system.
Authentication is the backbone of the app, ensuring secure and seamless access for users.

**Implementation Highlights:**

**Social Logins:**
Integrated Google, Facebook, and Apple logins using SDKs and Firebase Authentication.
Ensured compliance with platform-specific guidelines, like Apple’s “Sign in with Apple” mandate.
OpenID Support:
Used OpenID Connect libraries to provide users with additional authentication options.
SMS-Based OTP Authentication:
Leveraged Firebase Phone Authentication for secure and user-friendly OTP-based logins.
Authenticator App Integration:
Enabled two-factor authentication (2FA) using TOTP via Google Authenticator or Authy.
Phase 2: Expense Management

Goal: Create a seamless workflow for managing user expenses.
Expense management is the heart of the app, focusing on simplifying how users handle their financial data.

**Key Features:**

**Expense CRUD Operations:**
Add expenses with attributes like title, amount, and type (personal/business).
Enable swipe actions for quick edit and delete options.
Bulk Upload via Receipt/Bill Scanning:
Integrated OCR technology (using Firebase ML Kit or Tesseract) to extract data from receipts.
Mapped extracted fields (e.g., amount, date) to expense attributes for automatic entry.
Category Assignment:
Auto-categorized expenses using predefined rules or user input during entry.
Phase 3: Tracking & Analytics

**Goal: Empower users with insights into their financial habits.**

**Features:**

Recurring Expense Tracking:
Identified patterns and prompted users to set reminders for recurring expenses.
Built notifications for timely updates on recurring expenses.
Expense Visualization:
Designed interactive dashboards to display:
Monthly summaries
Category-wise breakdowns
Spending trends via line or bar charts.
Expense Comparison:
Developed comparison tools for analyzing expenses across different timeframes, like month-to-month or year-over-year.
Phase 4: Advanced Enhancements

Goal: Take the user experience to the next level.

Key Innovations:

ARKit-Based Expense Visualization:
Introduced 3D visuals for expense trends using ARKit to make data exploration more engaging.
Screenshots

(Include visually appealing images of your app's interface, dashboards, ARKit visualizations, and key features to make this section more dynamic.)

**Technologies Used**

Programming Languages: Swift, SwiftUI
Authentication: Firebase, OpenID, TOTP
OCR: Firebase ML Kit, Tesseract (Some feature in Features are in Future Scope)
Analytics & Charts: Chart libraries (e.g., Swift Charts or similar)
Augmented Reality: ARKit
Lessons Learned

User-Centric Design: Understanding user behavior was crucial in designing features like recurring reminders and dashboards.
Security Challenges: Implementing robust authentication mechanisms required compliance with multiple platform guidelines.
Optimizing Performance: Processing receipts and OCR scans efficiently was a significant technical challenge.
Tags

**Swift, Expense Management, Authentication, Firebase, ARKit, Tracking & Analytics, OCR, Mobile App, iOS, Social Login, SMS OTP, OpenID**
