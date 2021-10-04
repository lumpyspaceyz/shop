<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.ArrayList" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	// 방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// dao
	NoticeDao noticeDao = new NoticeDao();
	QnaDao qnaDao = new QnaDao();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
div {
	overflow: hidden;
}
a, a:hover {
	text-decoration: none;
	color: #000;
}
a:hover {
	font-weight: bold;
}
</style>
</head>
<body>
<div class="container">
	<!-- start : 관리자 메뉴 include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지</h1>
		</div>
		
		<table class="table table-hover text-center">
			<tr>
				<td>
					<%=loginMember.getMemberName()%>님 반갑습니다.
				</td>
			</tr>
			
			<tr>
				<td>
					<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp">회원관리</a>
				</td>
			</tr>
			
			<tr>
				<td>
					<a href="<%=request.getContextPath() %>/admin/selectCategoryList.jsp">전자책 카테고리 관리</a>
				</td>
			</tr>
			
			<tr>
				<td>
					<a href="<%=request.getContextPath() %>/admin/selectEbookList.jsp">전자책 관리</a>
				</td>
			</tr>
			
			<tr>
				<td>
					<a href="<%=request.getContextPath() %>/admin/selectOrderList.jsp">주문 관리</a>
				</td>
			</tr>
			
			<tr>
				<td>
					<a href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp">공지게시판 관리</a>
				</td>
			</tr>
		</table>
	</div>

	<div class="container pt-3"></div>
	
	<!-- newer notice / newer qna -->
	<div style="">
	<!-- start : notice -->
	<%
		ArrayList<Notice> newerNoticeList = noticeDao.selectNewerNoticeList();
	%>
	<div class="container p-3 my-3 border" style="width: 48%; margin-left: 0px; float: left;">
	<!-- 최근 공지 5개 -->
	<label>NOTICE</label>
		<%
		for(Notice n : newerNoticeList) {
		%>
			<ul class="list-group list-group-flush">
				<%
				// 회원or관리자 selectNoteiceOne.jsp 분기
				if(loginMember.getMemberLevel() > 0) {
					%>
						<li class="list-group-item"><a href="<%=request.getContextPath() %>/admin/selectNoticeOne.jsp?noticeNo=<%=n.getNoticeNo() %>">
					<%
				} else if(loginMember.getMemberLevel() == 0) {
					%>
						<li class="list-group-item"><a href="<%=request.getContextPath() %>/selectNoticeOne.jsp?noticeNo=<%=n.getNoticeNo() %>">
					<%
				}
					%>
								<%=n.getCreateDate() %>
								<%=n.getNoticeTitle() %>
							<%
								if(n.getMemberNo() > 0) {
							%>	
								관리자	
							<%		
								}
							%>
						</a></li>
			</ul>
		<%
		}
		%>
	</div>
	<!-- end : notice -->
	
	<!-- start : qna -->
	<%
		ArrayList<QnaQnaComment> newerQnaList = qnaDao.selectNewerQnaList();
	%>
	<div class="container p-3 my-3 border" style="width: 48%; margin-right: 0px; float: right;">
	<!-- 최근 공지 5개 -->
	<label>QNA</label>
		<%
		for(QnaQnaComment q : newerQnaList) {
		%>
			<ul class="list-group list-group-flush">
				<%
				// 회원or관리자 selectNoteiceOne.jsp 분기
				if(loginMember.getMemberLevel() > 0) {
					%>
						<li class="list-group-item"><a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=q.getQna().getQnaNo() %>">
					<%
				} else if(loginMember.getMemberLevel() == 0) {
					%>
						<li class="list-group-item"><a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=q.getQna().getQnaNo() %>">
					<%
				}
					%>
								<%=q.getQna().getUpdateDate() %>
								<%=q.getQna().getQnaTitle() %>
						</a></li>
			</ul>
		<%
		}
		%>
	</div>
	<!-- end : qna -->
	</div>
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
</div>
</body>
</html>