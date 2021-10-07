<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	// 방어코드
	if(request.getParameter("orderNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp?currentPage=1");
		return;
	}

	// dao	
	OrderDao orderDao = new OrderDao();
	Order order = new Order();
	order = orderDao.selectOrderOneByMember(loginMember.getMemberNo(), orderNo);
	
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = null;
	ebook = ebookDao.selectEbookOne(order.getEbookNo());

	OrderCommentDao orderCommentDao = new OrderCommentDao();
	
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
	<!-- start : submenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="jumbotron">
	  <h1>주문 정보 상세조회</h1>
	</div>
	
	<!-- ebook 정보 -->
	<div class="container p-3 my-3 border">
		<p>ebook 정보</p>
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
					<td><a href="<%=request.getContextPath() %>/selectEbookOneByMember.jsp?ebookNo=<%=ebook.ebookNo %>"><%=ebook.getEbookTitle() %></a></td>
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
		
	<!-- order 정보 -->
	<div class="container p-3 my-3 border">
		<p>order 정보</p>
		<table class="table table-borderless table-hover text-center">
			<tr class="border-bottom">
				<th>orderNo</th>
				<td><%=order.getOrderNo() %></td>
			</tr>
			<tr class="border-bottom">
				<th>orderPrice</th>
				<td>￦ <%=order.getOrderPrice() %></td>
			</tr>
			<tr>
				<th>createDate</th>
				<td><%=order.getUpdateDate() %></td>
			</tr>
		</table>
	</div>
	
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
	<div class="text-center">
  		<a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=1" class="btn btn-outline-dark">주문목록</a>
  		<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-dark">main</a>
	</div>
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
</div>
</body>
</html>