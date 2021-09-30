<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
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
	<!-- start : adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : adminMenu include -->
	
	<div class="jumbotron">
	  <h1>관리자 페이지 - 카테고리 추가</h1>
	</div>
	
	<%
		String categoryCheck = "";
		if(request.getParameter("categoryCheck") != null) {
			categoryCheck = request.getParameter("categoryCheck");
		}
	%>
	
	<!-- 초기화 값은 null, selectCategoryNameCheckAction의 else를 타고 와야 값 출력 -->
	<div><%=request.getParameter("categoryNameCheckResult") %></div>
	
	<!-- 카테고리 중복 체크 -->
	<form class="text-center" action="<%=request.getContextPath() %>/admin/selectCategoryNameCheckAction.jsp" method="post">
 		<div class="form-group">
			<label>categoryName : </label>
			<div><input type="text" name="categoryCheck"></div>
			<br>
			<div><button type="submit" class="btn btn-outline-dark btn-sm">카테고리 중복체크</button></div>
		</div>
	</form>
	
	<!-- 카테고리 추가 폼 -->
	<form class="text-center" method="post" action="<%=request.getContextPath() %>/admin/insertCategoryAction.jsp">
		<!-- categoryName -->
		<div class="form-group">
			<label>categoryName : </label>
			<div><input type="text" name="categoryName" readonly="readonly" value="<%=categoryCheck %>"></div>
		</div>
		<!-- categoryState -->
		<div class="form-group">
			<label>categoryState : </label>
			<div>
				<input type="radio" name="categoryState" value="Y" checked> 공개
				<input type="radio" name="categoryState" value="N"> 비공개
			</div>
		</div>
		<br>
		<div>
			<input type="submit" value="추가" class="btn btn-outline-dark">
			<a href="<%=request.getContextPath() %>/admin/selectCategoryList.jsp" class="btn btn-outline-dark">취소</a>
		</div>
	</form>
</div>
</body>
</html>