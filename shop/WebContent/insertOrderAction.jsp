<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	// param
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	int orderPrice = Integer.parseInt(request.getParameter("orderPrice"));

	// debug
	System.out.println("debug " + ebookNo + " <-- ebookNo");
	System.out.println("debug " + memberNo + " <-- memberNo");
	System.out.println("debug " + orderPrice + " <-- orderPrice");
	
	// dao
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = null;
	ebook = ebookDao.selectEbookOne(ebookNo);
	
	OrderDao orderDao = new OrderDao();
	orderDao.insertOrder(ebookNo, memberNo, orderPrice);
	
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
	  <h1>주문 성공!</h1>
	</div>
	
	<div class="container p-3 my-3 border">
	
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
	
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
	<div class="text-center">
  		<a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp" class="btn btn-outline-dark">주문확인</a>
  		<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-dark">main</a>
	</div>
	
</div>
</body>
</html>