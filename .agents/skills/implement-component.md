---
name: implement-component
description: Instructions for implementing a component based on context retrieved from Jira and Figma.
---

# Instructions for Implementing a Component
0. The component_name should be provided in the prompt or clear from the context. If it isn't, ask for the name of the component to be implemented.
1. Use the context gathered from Jira and Figma to create a plan for implementing the component or feature. If the context is unavailable, ask for the Jira ticket number and use `/get-jira-and-figma-context [ticket_number]` command to retrieve context from Jira and Figma.
2. If the component already exists, review the existing implementation and determine what changes need to be made based on the context gathered from Jira and Figma. If there is no existing component, use `/create-new-component [component_name]` command to create the new component. 
3. Break down the implementation into smaller tasks and create a checklist of these tasks. Be sure to include tasks for writing tests and updating documentation if necessary. As you complete each task, check it off the list to keep track of your progress and ensure that all necessary steps are completed before finalizing the implementation.
4. Once the implementation is complete, review the code to ensure it meets the requirements and follows best practices. If there are any issues or improvements that can be made, make the necessary changes before finalizing the implementation. Make sure to test the component thoroughly to ensure it works as expected and does not introduce any new issues or bugs. If any issues are found during testing, address them before finalizing the implementation.
5. Ensure the git pre-push hook passes if there is one. It will be called `pre-push` and will usually reside in `bin` or `.husky` at the project root. If the pre-push hook fails, review the error message, address the issues, and try running the pre-push hook again until it passes. If it fails three times, ask for help resolving the issues.

# General instructions
* Changes to existing code should always be minimal and only what is necessary to implement the new feature or fix the issue described in the Jira ticket.
* Always try to use existing components, utilities, and styles before creating new ones. If you need to create new ones, make sure to follow the existing patterns and conventions in the codebase.
* If you encounter any issues or have questions during the implementation, refer back to the context gathered from Jira and Figma, and if necessary, ask for clarification or additional context.
