# Hello World GitHub Action with Slack Notification

This GitHub Action workflow sends a "Hello World" notification to a Slack channel after completing the pipeline.

## Setup Instructions

### 1. Configure Slack Incoming Webhook

1. Go to your Slack workspace and create a new app (or use an existing one):
   - Visit: https://api.slack.com/apps
   - Click "Create New App" > "From scratch"
   - Name your app (e.g., "GitHub Actions Notifier")
   - Select your workspace ("Jenkins_Notification")

2. Set up Incoming Webhooks:
   - Under "Add features and functionality", select "Incoming Webhooks"
   - Toggle "Activate Incoming Webhooks" to On
   - Click "Add New Webhook to Workspace"
   - Choose the "aws-cost-notification" channel
   - Copy the Webhook URL that is generated

### 2. Add Webhook URL to GitHub Repository Secrets

1. In your GitHub repository, go to "Settings" > "Secrets" > "Actions"
2. Click "New repository secret"
3. Name: `SLACK_WEBHOOK_URL`
4. Value: Paste the webhook URL from the previous step
5. Click "Add secret"

### 3. Workflow Execution

The workflow will run:
- When code is pushed to the main branch
- When a pull request is made to the main branch
- Manually via the "Actions" tab in GitHub

## Customization

You can customize the notification message by modifying the `custom_payload` in the `.github/workflows/hello-world-slack.yml` file.