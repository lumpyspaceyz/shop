<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// 방어코드
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	if(request.getParameter("qnaNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	
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
<body>
<div class="container">
	<!-- start : 회원 mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : 회원 mainMenu include -->
	
	<form method="post" action="<%=request.getContextPath() %>/updateQnaAction.jsp?qnaNo=<%=qna.getQnaNo() %>">
		<div class="container p-3 my-3 border">
			<div class="jumbotron">
			  <h1>회원 페이지 - qna 수정</h1>
			</div>
		
			<!-- qna 수정 -->
			<table class="table table-borderless text-center">
				<thead>
					<tr class="font-weight-bold">
						<th>qnaCategory</th>
						<th>qnaTitle</th>
						<th>memberNo</th>
					</tr>
					<tr class="border-bottom">
						<td width="33%" style="padding: 10px 60px 12px 60px;">
						<%
							if(qna.getQnaCategory().equals("전자책관련")) {
						%>
							<select class="form-control text-center" name="qnaCategory" style="height: 35px;">
								<option value="전자책관련" selected>전자책관련</option>
								<option value="회원정보관련">회원정보관련</option>
								<option value="기타">기타 </option>
							</select>
						<%
							} else if(qna.getQnaCategory().equals("회원정보관련")) {
						%>
							<select class="form-control text-center" name="qnaCategory" style="height: 35px;">
								<option value="전자책관련">전자책관련</option>
								<option value="회원정보관련" selected>회원정보관련</option>
								<option value="기타">기타 </option>
							</select>
						<%
							} else if(qna.getQnaCategory().equals("기타")) {
						%>
							<select class="form-control text-center" name="qnaCategory" style="height: 35px;">
								<option value="전자책관련">전자책관련</option>
								<option value="회원정보관련">회원정보관련</option>
								<option value="기타" selected>기타 </option>
							</select>
						<%
							}
						%>
						</td>
						<td width="33%"><input type="text" class="text-center" name="qnaTitle" value="<%=qna.getQnaTitle() %>"></td>
						<td width="33%"><input type="text" class="text-center" name="memberNo" value="<%=loginMember.getMemberNo() %>" readonly="readonly"></td>
					</tr>
				</thead>
				<tbody>
					<tr class="font-weight-bold text-left">
						<th colspan="3" style="padding-left: 60px; padding-top: 30px;">qnaContent</th>
					</tr>
					<tr class="border-bottom">
						<td colspan="3"><textarea rows="10" cols="135" placeholder="내용을 입력하세요." name="qnaContent"><%=qna.getQnaContent() %></textarea></td>
					</tr>
				</tbody>
				</table>
				<table class="table table-borderless text-center">
					<tr>
						<th width="45%" class="text-right">qnaSecret</th>
						<td width="45%" class="text-left">
							<%
								if(qna.getQnaSecret().equals("Y")) {
							%>
								<input type="radio" class="text-center" name="qnaSecret" value="Y" checked> Y
								<input type="radio" style="margin-left: 10px;" class="text-center" name="qnaSecret" value="N"> N
							<%
								} else {
							%>
								<input type="radio" class="text-center" name="qnaSecret" value="Y"> Y
								<input type="radio" style="margin-left: 10px;" class="text-center" name="qnaSecret" value="N" checked> N
							<%
								}
							%>
						</td>
					</tr>
			</table>
		</div>
		<div class="text-center">
			<button class="btn btn-outline-dark" type="submit">수정</button>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=qna.getQnaNo() %>">취소</a>
		</div>
	</form>
			
			
</div>
</body>
</html>