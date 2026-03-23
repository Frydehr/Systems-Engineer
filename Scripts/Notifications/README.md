# 📧 Mail & Notifications Suite

This module provides the communication layer for the entire toolkit, transforming raw script data into actionable alerts and professional reports for stakeholders.

## 📋 Scripts Included

### 1. Send-BasicEmailNotification.ps1
* **Purpose:** Sends quick, plain-text SMTP alerts for general task completion.
* **Value:** Provides immediate feedback for automated tasks without the overhead of complex formatting.

### 2. Send-HTMLReport.ps1
* **Purpose:** Programmatically converts PowerShell objects into clean, CSS-styled HTML tables.
* **Value:** Turns raw technical data into "Management-Ready" reports that are easy to read on both desktop and mobile.

### 3. Send-CriticalAlert.ps1
* **Purpose:** A high-priority alerting script designed for system failures or threshold breaches.
* **Value:** Includes "Importance: High" headers and specific formatting to trigger on-call notification systems or SMS gateways.

### 4. Get-MailQueueStatus.ps1
* **Purpose:** Monitors local SMTP relays or Exchange queues for stuck or delayed messages.
* **Value:** Ensures that critical system alerts aren't silently failing due to mail flow bottlenecks.

### 5. Send-AttachmentReport.ps1
* **Purpose:** Automates the distribution of log files, CSV audits, or backup reports as email attachments.
* **Value:** Facilitates "Hands-Off" administration by delivering raw audit data directly to the necessary departments.

## ⚙️ Configuration
Update the `$SmtpServer` and `$DefaultSender` variables within the scripts or via a centralized `config.json` to match your organization's mail environment.
