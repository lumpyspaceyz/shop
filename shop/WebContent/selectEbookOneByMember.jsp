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
	if(loginMember == null || loginMember.getMemberLevel() < 0) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("ebookNo") == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp?currentPage=1");
		return;
	}

	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// debug
	System.out.println("debug " + ebookNo + " <-- ebookNo");
	
	// dao
	EbookDao ebookDao = new EbookDao();
	
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
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
	<!-- start : 회원 mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : 회원 mainMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>회원 페이지 - ebook 상세 보기</h1>
		</div>
	
		<table class="table table-borderless table-hover text-center">
			<thead>
				<tr class="border-bottom font-weight-bold">
					<th>ebookNo</th>
					<th>categoryName</th>
					<th>ebookTitle</th>
					<th>ebookState</th>
					<th>updateDate</th>
					<th>createDate</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><%=ebook.ebookNo %></td>
					<td><%=ebook.getCategoryName() %></td>
					<td><%=ebook.getEbookTitle() %></td>
					<td>
						<%
							if(ebook.getEbookState().equals("판매중")) {
						%>	
								<span>판매중</span>	
						<%
							} else if(ebook.getEbookState().equals("품절")) {
						%>	
								<span>품절</span>		
						<%
							} else if(ebook.getEbookState().equals("절판")) {
						%>	
								<span>절판</span>	
						<%
							} else if(ebook.getEbookState().equals("구편절판")) {
						%>
								<span>구편절판</span>	
						<%
							}
						%>		
					</td>
					<td><%=ebook.getUpdateDate() %></td>
					<td><%=ebook.getCreateDate() %></td>
				</tr>
			</tbody>
		</table>
		
		<table class="table table-borderless table-hover text-center">
			<tr class="font-weight-bold">
				<th style="vertical-align: middle;">ebookImg</th>
				<td><img src="<%=request.getContextPath() %>/image/<%=ebook.getEbookImg() %>" width="300px"></td>
			</tr>
		</table>
	</div>
	
	<div class="text-center">
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/index.jsp?currentPage=1">목록</a>
	</div>
	
	<div class="container pt-3"></div>
</div>
</body>
</html>