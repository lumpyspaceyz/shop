<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	
	// dao
	OrderDao orderDao = new OrderDao();
	ArrayList<OrderEbookMember> list = orderDao.selectOrderListByMember(loginMember.getMemberNo());
	
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
	<!-- start : mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : mainMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>회원 페이지 - 나의 주문 관리</h1>
		</div>
		
		<!--  주문 목록 출력 -->
		<table class="table table-striped table-hover text-center">
				<thead>
					<tr class="font-weight-bold">
						<th>orderNo</th>
						<th>ebookTitle</th>
						<th>orderPrice</th>
						<th>createDate</th>
						<th>memberId</th>
						<th>상세주문내역</th>
						<th>ebook후기</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(OrderEbookMember oem : list) {
					%>
							<tr>
								<td><a href="<%=request.getContextPath() %>/selectOrderOne.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>"><%=oem.getOrder().getOrderNo() %></a></td>
								<td><%=oem.getEbook().getEbookTitle() %></td>
								<td><%=oem.getOrder().getOrderPrice() %></td>
								<td><%=oem.getOrder().getCreateDate() %></td>
								<td><%=oem.getMember().getMemberId() %></td>
								<td>
									<a href="<%=request.getContextPath() %>/admin/updateMemberLevelForm.jsp?memberNo=">상세주문내역</a>
								</td>
								<%
									if(orderCommentDao.checkComment(oem.getOrder().getOrderNo(), oem.getEbook().getEbookNo()) == false) {
								%>
										<td>
											<a href="<%=request.getContextPath() %>/insertOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>&ebookNo=<%=oem.getEbook().getEbookNo() %>">후기작성</a>
										</td>
								<%
									} else {
								%>
									<td>
										<a href="<%=request.getContextPath() %>/selectOrderComment.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>&ebookNo=<%=oem.getEbook().getEbookNo() %>">후기조회</a>
									</td>
								<%		
									}
								%>
							</tr>
					<%
						}
					%>
				</tbody>
		</table>
	</div>
</div>
</body>
</html>