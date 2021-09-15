<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 인증 방어 코드 : 로그인 전에만 페이지 열람 가능
	// session.getAttribute("loginMember") --> null
	
	if(session.getAttribute("loginMember") != null) {
		System.out.println("이미 로그인 되어 있습니다.");
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
	<!-- start : submenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="jumbotron">
	  <h1>로그인</h1>
	</div>
	
	<form method="post" action="<%=request.getContextPath() %>/loginAction.jsp">
  		<div class="form-group">
			<label>memberId : </label>
			<div><input type="text" name="memberId"></div>
		</div>
		
		<div class="form-group">
			<label>memberPw : </label>
			<div><input type="password" name="memberPw"></div>
		</div>
		<div>
			<input type="submit" value="로그인" class="btn btn-outline-dark">
			<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-dark">취소</a>
		</div>
	</form>
</div>
</body>
</html>