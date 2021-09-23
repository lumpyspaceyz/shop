<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
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
	  <h1>메인 페이지</h1>
	</div>
	
	<%
		if(session.getAttribute("loginMember") == null) {
	%>
			<!-- 로그인 전  -->
			<table class="table table-hover text-center">
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/loginForm.jsp">로그인</a>
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/insertMemberForm.jsp">회원가입</a>
					</td><!-- insertMemberAction.jsp -->
				</tr>
			</table>
	<%		
		} else {
			Member loginMember = (Member)session.getAttribute("loginMember");
			System.out.println(loginMember.getMemberLevel() + " <-- memberLevel");
	%>
			<!-- 로그인 후 -->
			<table class="table table-hover text-center">
				<tr>
					<td>
						<%=loginMember.getMemberName()%>님 반갑습니다.
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/selectMemberOne.jsp?memberNo=<%=loginMember.getMemberNo() %>">회원정보</a>
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/deleteMemberForm.jsp">회원탈퇴</a>
					</td>
				</tr>
				
				<!-- 관리자 페이지로 가는 링크 -->
				<%
					if(loginMember.getMemberLevel() > 0) {
				%>
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/admin/adminIndex.jsp">관리자 페이지</a>
					</td>
				</tr>
				<%
						}
				%>
	<%	
		}
	%>
</div>
</body>
</html>
