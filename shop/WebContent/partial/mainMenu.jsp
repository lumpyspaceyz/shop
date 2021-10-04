<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
%>
<div>
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark justify-content-center">
		<ul class="navbar-nav">
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/deleteMemberForm.jsp">회원탈퇴</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/selectMemberOne.jsp?memberNo=<%=loginMember.getMemberNo() %>">회원정보</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/index.jsp">main</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp">나의주문</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=1">공지게시판</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=1">Qna게시판</a></li>
		</ul>
	</nav>
</div>