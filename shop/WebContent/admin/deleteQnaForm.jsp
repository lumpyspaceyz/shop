<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	//encoding
	request.setCharacterEncoding("utf-8");
	
	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");

	// qnaNo 유효성 검사
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/admin/selectQnaList.jsp?currentPage=1");
		return;
	}
	
	// dao
	QnaDao qnaDao = new QnaDao();
	
	Qna qna = qnaDao.selectQnaOne(qnaNo);
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
	<!-- start : 관리자 메뉴 include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 메뉴 include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - qna게시판 관리</h1>
		</div>
	
		<table class="table table-borderless text-center">
			<thead>
				<tr class="font-weight-bold">
					<th>qnaNo</th>
					<th>qnaCategory</th>
					<th>qnaTitle</th>
					<th>memberNo</th>
				</tr>
				<tr class="border-bottom">
					<td><%=qna.getQnaNo() %></td>
					<td><%=qna.getQnaCategory() %></td>
					<td width="35%"><%=qna.getQnaTitle() %></td>
					<td><%=qna.getMemberNo() %></td>
				</tr>
			</thead>
			<tbody>
				<tr class="font-weight-bold text-left">
					<th colspan="4" style="padding-left: 60px; padding-top: 30px;">qnaContent</th>
				</tr>
				<tr class="border-bottom">
					<td colspan="4"><textarea rows="10" cols="135" readonly="readonly"><%=qna.getQnaContent() %></textarea></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<!-- <th colspan="2" style="padding-top: 30px;" width="45%" class="text-right">qnaSecret</th> -->
					<td colspan="2" style="padding-top: 30px;" class="text-left">
						<input type="hidden" id="qnaSecret" value="<%=qna.getQnaSecret() %>">
						<input type="hidden" id="loginMemberNo" value="<%=loginMember.getMemberNo() %>">
						<input type="hidden" id="qnaMemberNo" value="<%=qna.getMemberNo() %>">
					</td>
				</tr>
			</tfoot>	
		</table>
	</div>
	
	<div class="text-center">
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/deleteQnaAction.jsp?qnaNo=<%=qna.getQnaNo() %>">삭제</a>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=qna.getQnaNo() %>">취소</a>
	</div>
	
	<div class="container pt-3"></div>
</div>
</body>
</html>