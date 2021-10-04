<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// 방어코드
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/admin/selectNoticeList.jsp?currentPage=1");
		return;
	}
	// debug
	System.out.println("debug " + noticeNo + " <-- noticeNo");
	
	// dao
	NoticeDao noticeDao = new NoticeDao();
	
	Notice notice = noticeDao.selectNoticeOne(noticeNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<body>
<div class="container">
	<!-- start : 관리자 adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 adminMenu include -->
	
	<form method="post" action="<%=request.getContextPath() %>/admin/updateNoticeAction.jsp">
		<div class="container p-3 my-3 border">
			<div class="jumbotron">
			  <h1>관리자 페이지 - 공지 수정</h1>
			</div>
		
			<table class="table table-borderless table-hover">
					<tr class="border-bottom font-weight-bold">
						<th class="text-right" width="45%">noticeNo</th>
						<td><input type="text" class="text-center" name="noticeNo" value="<%=notice.getNoticeNo() %>" readonly="readonly"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">noticeTitle</th>
						<td><input type="text" class="text-center" name="noticeTitle" value="<%=notice.getNoticeTitle() %>"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">noticeContent</th>
						<td><textarea rows="10" cols="110" name="noticeContent" placeholder="공지를 입력하세요."><%=notice.getNoticeContent() %></textarea></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberNo</th>
						<td><input type="text" class="text-center" name="memberNo" value="<%=notice.getMemberNo() %>" readonly="readonly"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">updateDate</th>
						<td><input type="text" class="text-center" name="updateDate" value="<%=notice.getUpdateDate() %>" readonly="readonly"></td>				
					</tr>
					<tr class="border-bottom font-weight-bold">				
						<th class="text-right">createDate</th>
						<td><input type="text" class="text-center" name="createDate" value="<%=notice.getCreateDate() %>" readonly="readonly"></td>
					</tr>
			</table>
		</div>
		<div class="text-center">
			<button class="btn btn-outline-dark" type="submit">수정</button>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selectNoticeOne.jsp?noticeNo=<%=notice.getNoticeNo() %>">취소</a>
		</div>
	</form>
			
			
</div>
</body>
</body>
</html>