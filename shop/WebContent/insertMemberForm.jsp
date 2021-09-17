<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

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
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="jumbotron">
	  <h1>회원가입</h1>
	</div>
	
	<%
		String memberIdCheck = "";
		if(request.getParameter("memberIdCheck") != null) {
			memberIdCheck = request.getParameter("memberIdCheck");
		}
	%>
	
	<!-- 초기화 값은 null, selectMemberIdCheckAction의 else를 타고 와야 값 출력 -->
	<div><%=request.getParameter("idCheckResult") %></div>
	
	<!-- 멤버아이디가 사용 가능한지 확인 폼 : 아이디 중복 체크 -->
	<form class="text-center" action="<%=request.getContextPath() %>/selectMemberIdCheckAction.jsp" method="post">
 		<div class="form-group">
			<label>memberId : </label>
			<div><input type="text" name="memberIdCheck"></div>
			<br>
			<div><button type="submit" class="btn btn-outline-dark btn-sm">아이디 중복체크</button></div>
		</div>
	</form>
	
	<!-- 회원가입 폼 -->
	<form class="text-center" method="post" action="<%=request.getContextPath() %>/insertMemberAction.jsp">
		<!-- memberId -->
		<div class="form-group">
			<label>memberId : </label>
			<div><input type="text" name="memberId" readonly="readonly" value="<%=memberIdCheck %>"></div>
		</div>
		<!-- memberPw -->
		<div class="form-group">
			<label>memberPw : </label>
			<div><input type="password" name="memberPw"></div>
		</div>
		<!-- memberName -->
		<div class="form-group">
			<label>memberName : </label>
			<div><input type="text" name="memberName"></div>
		</div>
		<!-- memberAge -->
		<div class="form-group">
			<label>memberAge : </label>
			<div><input type="text" name="memberAge"></div>
		</div>
		<!-- memberGender -->
		<div class="form-group">
			<label>memberGender : </label>
			<div>
				<input type="radio" name="memberGender" value="남"> 남
				<input type="radio" name="memberGender" value="여"> 여
			</div>
		</div>
		<br>
		<div>
			<input type="submit" value="회원가입" class="btn btn-outline-dark">
			<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-dark">취소</a>
		</div>
	</form>
</div>
</body>
</html>