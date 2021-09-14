<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 로그인 상태에서는 페이지 접근불가
	if(session.getAttribute("loginMember") != null) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect("./index.jsp");
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
		<jsp:include page="/partial/submenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="jumbotron">
	  <h1>회원가입</h1>
	</div>
	<form method="post" action="<%=request.getContextPath() %>/insertMemberAction.jsp">
	<table class="table table-hover text-center">
		<!-- memberId -->
		<tr>
			<th>memberId : </th>
			<td><input type="text" name="memberId"></td>
		</tr>
		<!-- memberPw -->
		<tr>
		<th>memberPw : </th>
		<td><input type="password" name="memberPw"></td>
		</tr>
		<!-- memberName -->
		<tr>
		<th>memberName : </th>
		<td><input type="text" name="memberName"></td>
		</tr>
		<!-- memberAge -->
		<tr>
		<th>memberAge : </th>
		<td><input type="text" name="memberAge"></td>
		</tr>
		<!-- memberGender -->
		<tr>
		<th>memberGender : </th>
		<td>
			<input type="radio" name="memberGender" value="남"> 남
			<input type="radio" name="memberGender" value="여"> 여
		</td>
		</tr>
		<br>
	</table>
		<div class="text-center">
			<input type="submit" value="회원가입" class="btn btn-outline-dark">
			<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-dark">취소</a>
		</div>
	</form>
</div>
</body>
</html>