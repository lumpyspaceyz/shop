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
	if(request.getParameter("orderNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp?memberNo=" + loginMember.getMemberNo());
		return;
	}
	if(request.getParameter("ebookNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp?memberNo=" + loginMember.getMemberNo());
		return;
	}

	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// debug
	System.out.println("debug " + orderNo + " <-- orderNo");
	System.out.println("debug " + ebookNo + " <-- ebookNo");
	
	// dao
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
	
	OrderDao orderDao = new OrderDao();
	ArrayList<OrderEbookMember> list = orderDao.selectOrderListByMember(loginMember.getMemberNo());
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
	<form method="post" action="<%=request.getContextPath() %>/insertOrderCommentAction.jsp?orderNo=<%=orderNo %>&ebookNo=<%=ebookNo %>">
		<div class="container p-3 my-3 border">
			<div class="jumbotron">
			  <h1>회원 페이지 - 후기작성</h1>
			</div>
			
			<!-- ebook 정보 불러오기 -->
			<div class="container p-3 my-3 border">
				<table class="table table-borderless text-center">
					<thead>
						<tr class="border-bottom font-weight-bold">
							<th>ebookNo</th>
							<th>categoryName</th>
							<th>ebookTitle</th>
							<th>ebookState</th>
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
						</tr>
					</tbody>
				</table>
				
				<table class="table table-borderless text-center">
					<tr class="font-weight-bold">
						<th style="vertical-align: middle; text-align: right;">ebookImg</th>
						<td width="70%"><img src="<%=request.getContextPath() %>/image/<%=ebook.getEbookImg() %>" width="300px"></td>
					</tr>
				</table>
			</div>
			
			<div class="container pt-3"></div>
			<div class="container pt-3"></div>
			
			<!-- 후기작성 -->
			<table class="table table-borderless text-center">
				<thead>
					<tr class="border-bottom font-weight-bold">
						<th width="25%">orderNo</th>
						<th width="25%">ebookNo</th>
						<th>orderScore</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><%=orderNo %></td>
						<td><%=ebookNo %></td>
						<td style="padding: 12px 50px;"><input type="range" min="0" max="10" step="1" name="orderScore" class="form-control-range"></td>
					</tr>
				</tbody>
			</table>
			
			<table class="table table-borderless table-hover text-center">
				<thead>
					<tr class="border-bottom font-weight-bold">
						<th class="text-left" style="padding-left: 45px;">orderCommentContent</th>
					</tr>
				</thead>
				<tbody>
					<tr class="font-weight-bold">
						<td><textarea rows="10" cols="135" name="orderCommentContent" placeholder="후기를 입력하세요.">추천합니다.</textarea></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="text-center">
			<button class="btn btn-outline-dark" type="submit">후기작성</button>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?memberNo=<%=loginMember.getMemberNo() %>">취소</a>
		</div>
	</form>
			
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
</div>
</body>
</html>