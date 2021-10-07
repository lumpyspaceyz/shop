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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
	<!-- 비회원/회원 메뉴 -->
	<%
		if(session.getAttribute("loginMember") == null) {
	%>
			<!-- start : beforeLoginMenu include -->
			<div>
				<jsp:include page="/partial/beforeLoginMenu.jsp"></jsp:include>
			</div>
			<!-- end : beforeLoginMenu include -->
	<%
		} else if(session.getAttribute("loginMember") != null) {
	%>
			<!-- start : mainMenu include -->
			<div>
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
			</div>
			<!-- end : mainMenu include -->
	<%	
		}
	%>
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>로그인</h1>
		</div>
		
		<div class="container pt-3"></div>
		<div class="container pt-3"></div>
		
		<form id="loginForm" class="text-center" method="post" action="<%=request.getContextPath() %>/loginAction.jsp">
	  		<div class="form-group">
				<label>memberId : </label>
				<div><input type="text" name="memberId" placeholder="id" id="memberId" value=""></div>
			</div>
			
			<div class="form-group">
				<label>memberPw : </label>
				<div><input type="password" name="memberPw" placeholder="pw" id="memberPw" value=""></div>
			</div>
			<div>
				<button type="button" id="loginBtn" class="btn btn-outline-dark">로그인</button>
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-dark">취소</a>
			</div>
		</form>
	</div>
	
	<!-- 유효성 검사 : id/pw -->
	<script>
		<!-- <button type="button"> -> <button type="submit"> -->
		$('#loginBtn').click(function(){ // 버튼을 click 했을 때
			if($('#memberId').val() == '') { // id가 공백이면
				alert('ID를 입력하세요.');
				return;
			} else if($('#memberPw').val() == '') { // pw가 공백이면
				alert('PW를 입력하세요.');
				return;
			} else {
				$('#loginForm').submit();
			}
		});
	</script>
</div>
</body>
</html>