# ExpenseTracker
A Swift-based Expense Tracking app   Authentication: Login/Signup with Google, Facebook, Apple, OpenID, SMS-based OTP, and authenticator app integration. Expense Management: Add expenses with attributes (title, amount, type), bulk upload via bill/receipt scanning, edit, and delete expenses. Tracking &amp; Analytics: Track recurring expenses



Phase 1: Authentication
Goal: Implement a robust, user-friendly login and signup mechanism.

Integrate Social Logins:
Add Google, Facebook, and Apple login support using respective SDKs or Firebase Authentication.
Ensure compliance with platform guidelines (e.g., Apple’s mandatory "Sign in with Apple").
Add OpenID Support:
Use an OpenID Connect library to support broader authentication options.
SMS-Based OTP:
Integrate Firebase Phone Authentication for OTP-based login.
Authenticator App Integration:
Enable time-based one-time password (TOTP) support for 2FA via authenticator apps like Google Authenticator or Authy.
Phase 2: Expense Management
Goal: Create a seamless workflow for managing user expenses.

Expense CRUD Operations:
Add Expenses: Develop a form to input attributes like title, amount, type (personal/business).
Edit/Delete Expenses: Implement swipe actions or menu options for editing and deletion.
Bulk Upload via Receipt/Bill Scanning:
Use a text recognition library (e.g., Tesseract or Firebase ML Kit) to extract details from images.
Map extracted fields to expense attributes.
Category Assignment:
Auto-categorize expenses using predefined rules or user input during creation.
Phase 3: Tracking & Analytics
Goal: Provide users insights into their financial habits.

Recurring Expense Tracking:
Identify patterns and prompt users to set recurring reminders for specific expenses.
Build notifications to remind users of upcoming recurring expenses.
Expense Visualization:
Create dashboards with:
Monthly summaries.
Category-wise breakdowns.
Trends (e.g., line or bar charts).
Expense Comparison:
Develop a feature for comparing expenses across timeframes (e.g., month-to-month or year-over-year).
Phase 4: Advanced Enhancements
Goal: Refine the user experience and expand capabilities.

ARKit-Based Expense Visualization:


![Simulator Screenshot - iPhone 16 Pro - 2024-11-08 at 17 00 22](https://github.com/user-attachments/assets/b399881e-dbde-44df-9b3b-a73d5a00bc56) | ![Simulator Screenshot - iPhone 16 Pro - 2024-11-08 at 16 59 58](https://github.com/user-attachments/assets/28e3b987-061e-41fa-a549-d44ed71539ee)

======
![Simulator Screenshot - iPhone 16 Pro - 2024-11-08 at 17 00 45](https://github.com/user-attachments/assets/17a0d5d0-b2d5-41e3-b2f4-409407099645)
