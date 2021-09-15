<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<!-- 방어코드 -->
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
%>
<div>
	<nav class="navbar navbar-expand-sm bg-light navbar-light">
		<ul class="navbar-nav">
		<li class="nav-item">
			<a class="nav-link" href="<%=request.getContextPath() %>/admin/adminIndex.jsp">admin menu1</a>
		</li>
		<li class="nav-item"><a class="nav-link" href="">admin menu2</a></li>
		<li class="nav-item"><a class="nav-link" href="">admin menu3</a></li>
		<li class="nav-item"><a class="nav-link" href="">admin menu4</a></li>
		<li class="nav-item"><a class="nav-link" href="">admin menu5</a></li>
		</ul>
	</nav>
</div>