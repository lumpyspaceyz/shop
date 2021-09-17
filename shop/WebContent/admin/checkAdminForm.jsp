<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String prevPage = request.getParameter("prevPage");
	System.out.println(prevPage+"prevPage");
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
	<!-- start : submenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="jumbotron">
	  <h1>관리자 권한 확인</h1>
	</div>
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
	<form class="text-center" method="post" action="<%=request.getContextPath() %>/admin/checkAdminAction.jsp?prevPage=<%=prevPage%>">
  		<div class="form-group">
			<label>memberId : </label>
			<div><input type="text" name="adminId"></div>
		</div>
		
		<div class="form-group">
			<label>memberPw : </label>
			<div><input type="password" name="adminPw"></div>
		</div>
		<div>
			<input type="submit" value="로그인" class="btn btn-outline-dark">
			<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-dark">취소</a>
		</div>
	</form>
</div>
</body>
</html>