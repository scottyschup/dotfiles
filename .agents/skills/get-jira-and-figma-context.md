---
name: get-jira-and-figma-context
description: Instructions for retrieving context from Jira and Figma.
---

# Instructions for Retrieving Context from Jira and Figma
To retrieve context from Jira and Figma, follow these steps:
0. A Jira ticket number will be provided in the prompt. Use this ticket number to find the relevant Jira ticket and Figma design files. If there isn't one, ask for the ticket number.
1. Ensure Figma MCP and Rovo MCP are running. If not, start them.
2. First use the provided Jira ticket number to open the relevant Jira ticket. The URL will be in the format `https://enovaagile.atlassian.net/browse/NCFE-10099` where `NCFE-10099` is the Jira ticket number and the subdomain is the `cloudId`.
3. Read the Jira ticket description and comments to gather context about the task or issue at hand.
4. Look for any links to Figma design files in the Jira ticket. If there are links, open the Figma design files to review the designs and gather additional context use `#get_design_context [figma_file_url]` command.
5. If there are no links to Figma design files in the Jira ticket, ask the user if there are any Figma design files related to the Jira ticket. If the user provides a Figma file URL, use the `#get_design_context [figma_file_url]` command to retrieve context from the Figma design file.
6. Provide a summary of the context gathered from both Jira and Figma and create a plan to implement the component or feature based on the gathered context.

# General instructions
* do not open any links in a browser, instead use the appropriate commands to retrieve context from th relevant MCPs.
* Use the skill `/create-new-component` from this same dir anytime a new component is needed. Use the skill `/implement-component` from this same dir to complete the implementation once the new component is created.
