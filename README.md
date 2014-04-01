Google App Engine (GAE) Demo
=============================

Guestbook Java JSP application that demonstrate the use of Google App Engine with two storage options: Cloud Datastorage and the Cloud SQL.

* Step 0: Intitalizing the projet with Maven.
* Step 1: Adding application code and UI
* Step 2: Storing User-Supplied Data in Datastore.

In this part of the tutorial, we'll create an app that integrates with Google Accounts so users can sign in using their Google accounts. In App Engine, the integration with Google accounts is achieved via the App Engine Users service. We'll use this to personalize our application's greeting.

This application consists of these main logical "parts":

- A JSP page that the user interacts with to make requests to the app.
- A servlet named GuestbookServlet.java that prompts the user to log in and then displays a personalized greeting.
