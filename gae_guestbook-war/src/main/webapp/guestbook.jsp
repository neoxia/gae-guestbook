<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title> [GAE] ~ Guestbook </title>
    <!-- Bootstrap -->
    <link type="text/css" rel="stylesheet" href="/stylesheets/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet" href="/stylesheets/jumbotron-narrow.css"/>

</head>

<body>

<div class="container">

  <div class="header">
    <ul class="nav nav-pills pull-right">
      <li class="active"><a href="/#">Home</a></li>
      <li><a href="/#">About</a></li>
      <li><a href="/#">Contact</a></li>
    </ul>
    <h3 class="text-muted">GAE ~ Guestbook</h3>
  </div>

  <div class="jumbotron">

    <%
        String guestbookName = request.getParameter("guestbookName");
        if (guestbookName == null) {
            guestbookName = "default";
        }
        pageContext.setAttribute("guestbookName", guestbookName);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user != null) {
            pageContext.setAttribute("user", user);
    %>

    <p>Hello, ${fn:escapeXml(user.nickname)}! (You can
        <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
    <%
    } else {
    %>
    <p>Hello!
        <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
        to include your name with greetings you post.</p>
    <%
        }
    %>


    <%
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
        // Run an ancestor query to ensure we see the most up-to-date
        // view of the Greetings belonging to the selected Guestbook.
        Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
        List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
        if (greetings.isEmpty()) {
    %>
    <p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
    <%
    } else {
    %>
    <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
    <%
        for (Entity greeting : greetings) {
            pageContext.setAttribute("greeting_content",
                    greeting.getProperty("content"));
            if (greeting.getProperty("user") == null) {
    %>
    <p>An anonymous person wrote:</p>
    <%
    } else {
        pageContext.setAttribute("greeting_user",
                greeting.getProperty("user"));
    %>
    <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
    <%
        }
    %>
    <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
    <%
            }
        }
    %>

    <form action="/sign" method="post">
        <p><textarea class="form-control" name="content" rows="3" cols="60"></textarea></p>
        <span/>
        <p><input class="btn btn-success" type="submit" value="Post Greeting"/></p>
        <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>


  </div>


    <form action="/guestbook.jsp" method="get">
      <div class="row">
        <div class="col-md-6">
          <input class="form-control" type="text" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
        </div>
        <div class="col-md-6">
          <input class="btn btn-primary btn-block" type="submit" value="Switch Guestbook"/>
        </div>
      </div>
    </form>



  <div class="footer">
    I'm your father! ~ Darth Vader
  </div>
<div>


</body>
</html>
