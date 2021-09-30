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
	  <h1>관리자 페이지 - 공지 추가</h1>
	</div>
	
	<!-- 공지 추가 폼 -->
	<form class="text-center" method="post" action="<%=request.getContextPath() %>/admin/insertNoticeAction.jsp">
		<div class="form-group">
			<label>noiceTitle : </label>
			<div><input type="text" name="noticeTitle"></div>
		</div>
		<div class="form-group">
			<label>noticeContent : </label>
			<div><textarea rows="10" cols="135" name="noticeContent" placeholder="공지를 입력하세요."></textarea></div>
		</div>
		<div class="form-group">
			<label>memberNo : </label>
			<div><input type="text" name="memberNo" value="<%=loginMember.getMemberNo() %>" readonly="readonly"></div>
		</div>
		<br>
		<div>
			<input type="submit" value="추가" class="btn btn-outline-dark">
			<a href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=1" class="btn btn-outline-dark">취소</a>
		</div>
	</form>
</div>
</body>
</html>