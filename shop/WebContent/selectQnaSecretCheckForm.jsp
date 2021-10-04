<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	//encoding
	request.setCharacterEncoding("utf-8");
	
	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) { // 로그인한 회원 + 관리자 : Qna 조회 가능
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	//debug
	System.out.println("loginMemberNo --> " + loginMember.getMemberNo());

	// 방어코드
	if(request.getParameter("qnaNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}

	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	
	// dao
	QnaDao qnaDao = new QnaDao();
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	System.out.println("qnaMemberNo --> " + qna.getMemberNo());
	System.out.println("qnaSecret --> " + qna.getQnaSecret());
	
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
	<!-- start : mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : mainMenu include -->
	
	<form action="<%=request.getContextPath() %>/selectQnaSecretCheckAction.jsp">
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>회원 페이지 - qna 상세보기</h1>
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
					<td>
						<%=qna.getQnaNo() %>
						<input type="hidden" name="qnaNo" value="<%=qna.getQnaNo() %>">
					</td>
					<td></td>
					<td width="35%"></td>
					<td><%=qna.getMemberNo() %></td>
				</tr>
			</thead>
			<tbody>
				<tr class="font-weight-bold text-left">
					<th colspan="4" style="padding-left: 60px; padding-top: 30px;">qnaContent</th>
				</tr>
				<tr class="border-bottom">
					<td colspan="4">
						<div class="container p-3 my-3 border" style="height: 250px; line-height: 200px;">
							비밀글은 작성자만 볼 수 있습니다.
						</div>
					</td>
				</tr>
			</tbody>
			<%
				if(loginMember.getMemberNo() == qna.getMemberNo()) {
			%>
			<tfoot>
				<tr>
					<th colspan="2" style="padding-top: 30px;" width="45%" class="text-right">qnaSecret</th>
					<td colspan="2" style="padding-top: 30px;" class="text-left">
						<input type="password" name="qnaSecret" class="text-center" placeholder="enter your password">
					</td>
				</tr>
			</tfoot>
			<%
				}
			%>
		</table>
	</div>
	
	<div class="text-center">
		<%
			if(loginMember.getMemberNo() == qna.getMemberNo()) {
		%>
				<button type="submit" class="btn btn-outline-dark">입력</button>
		<%
			}
		%>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=1">목록</a>
	</div>
	</form>
	
	<div class="container pt-3"></div>	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
</div>
</body>
</html>