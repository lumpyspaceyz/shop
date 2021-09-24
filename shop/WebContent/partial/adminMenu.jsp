<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
%>
<div>
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark justify-content-center">
		<ul class="navbar-nav">
		<li class="nav-item">
			<!-- 회원 관리 : 목록, 수정(등급, 비밀번호), 강제탈퇴 -->
			<a class="nav-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp">회원관리</a>
		</li>
			<!-- 전자책 카테고리 관리 : 목록, 추가 -->
		<li class="nav-item">
			<a class="nav-link" href="<%=request.getContextPath() %>/admin/selectCategoryList.jsp">전자책 카테고리 관리</a>
		</li>
		<li class="nav-item">
			<!-- 전자책 관리 : 목록, 추가(이미지 추가), 수정, 삭제 -->
			<a class="nav-link" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp">전자책 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="<%=request.getContextPath() %>/admin/selectOrderList.jsp">주문 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="">상품평 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="">공지게시판 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="">QnA게시판 관리</a>
		</li>
		</ul>
	</nav>
</div>