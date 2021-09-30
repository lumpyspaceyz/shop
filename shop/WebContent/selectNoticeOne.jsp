<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	// encoding
	request.setCharacterEncoding("utf-8");
	
	//방어코드 : 접속회원 세션 관리 (회원/비회원)
	Member loginMember = (Member)session.getAttribute("loginMember");

	// 방어코드
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectNoticeList.jsp?currentPage=1");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
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
<div class="container">
	<!-- start : mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : mainMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>회원/비회원 페이지 - 공지 상세보기</h1>
		</div>
	
		<table class="table table-borderless table-hover text-center">
			<thead>
				<tr class="border-bottom font-weight-bold">
					<th>noticeNo</th>
					<th>noticeTitle</th>
					<th>noticeContent</th>
					<th>memberNo</th>
					<th>createDate</th>
					<th>updateDate</th>
				</tr>
			</thead>
			<tbody>					
				<tr>
					<td><%=notice.getNoticeNo() %></td>
					<td><%=notice.getNoticeTitle() %></td>
					<td><%=notice.getNoticeContent() %></td>
					<td><%=notice.getMemberNo() %>
						<%
							if(notice.getMemberNo() == 1) {
						%>	
								<br><span>관리자</span>	
						<%
							}
						%>
					</td>
					<td><%=notice.getCreateDate() %></td>
					<td><%=notice.getUpdateDate() %></td>
				</tr>					
			</tbody>
		</table>
	</div>
	
	<div class="text-center">
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=1">목록</a>
	</div>
	
	<div class="container pt-3"></div>
</div>
</body>
</html>