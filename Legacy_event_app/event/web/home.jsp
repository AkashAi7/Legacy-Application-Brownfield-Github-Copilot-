

<%
String role=(String)session.getAttribute("role");
if(role==null){ response.sendRedirect("login.jsp"); }
else if("ADMIN".equals(role)){ response.sendRedirect("eventCreate.jsp"); }
else if("CREATOR".equals(role)){ response.sendRedirect("nominate.jsp"); }
else if("APPROVER".equals(role)){ response.sendRedirect("approveList.jsp"); }
%>
