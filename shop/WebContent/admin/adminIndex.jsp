<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// 방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
	<!-- start : 관리자 메뉴 include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="jumbotron">
	  <h1>관리자 페이지</h1>
	</div>
	
	<table class="table table-hover text-center">
		<tr>
			<td>
				<%=loginMember.getMemberName()%>님 반갑습니다.
			</td>
		</tr>
		
		<tr>
			<td>
				<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp">회원관리</a>
			</td>
		</tr>
		
		<tr>
			<td>
				<a href="<%=request.getContextPath() %>/admin/selectCategoryList.jsp">전자책 카테고리 관리</a>
			</td>
		</tr>
		
		<tr>
			<td>
				<a href="<%=request.getContextPath() %>/admin/selectEbookList.jsp">전자책 관리</a>
			</td>
		</tr>
		
		<tr>
			<td>
				<a href="<%=request.getContextPath() %>/admin/selectOrderList.jsp">주문 관리</a>
			</td>
		</tr>
	
</div>
</body>
</html>