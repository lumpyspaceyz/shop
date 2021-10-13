<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// 유효성 검사
	if(request.getParameter("orderNo") == null || request.getParameter("orderNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/admin/selectOrderList.jsp?currentPage=1");
		return;
	}
	// 유효성 검사
	if(request.getParameter("ebookNo") == null || request.getParameter("ebookNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/admin/selectOrderList.jsp?currentPage=1");
		return;
	}
	
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	
	// debug
	System.out.println("debug " + orderNo + " <-- orderNo");
	System.out.println("debug " + ebookNo + " <-- ebookNo");

	// dao	
	OrderDao orderDao = new OrderDao();
	Order order = new Order();
	order = orderDao.selectOrderOneByAdmin(orderNo);
	
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = new Ebook();
	ebook = ebookDao.selectEbookOne(order.getEbookNo());

	OrderCommentDao orderCommentDao = new OrderCommentDao();
	OrderComment orderComment = new OrderComment();
	orderComment = orderCommentDao.selectOrderComment(orderNo, ebookNo);
	
	System.out.println("memberNo -->" + order.getMemberNo());
	
	MemberDao memberDao = new MemberDao();
	Member member = new Member();
	member = memberDao.selectMemberOne(order.getMemberNo());
	
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
	<!-- start : 관리자 adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 adminMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>주문 정보 상세조회</h1>
		</div>
		
		<!-- member 정보 -->
		<div class="container p-3 my-3 border">
			<p>orderMember 정보</p>
			<table class="table table-borderless table-hover text-center">
				<tr class="border-bottom">
					<th width="37%">memberNo</th>
					<td><%=order.getMemberNo() %></td>
				</tr>
				<tr class="border-bottom">
					<th>memberId</th>
					<td><%=member.getMemberId() %></td>
				</tr>
				<tr>
					<th>memberLevel</th>
					<td><%=member.getMemberLevel() %></td>
				</tr>
			</table>
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
						<td><a href="<%=request.getContextPath() %>/admin/selectEbookOne.jsp?ebookNo=<%=ebook.ebookNo %>"><%=ebook.getEbookTitle() %></a></td>
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
		
		<!-- orderComment 정보 -->
		<%
			if(orderComment != null) {
				
		%>
			<div class="container p-3 my-3 border">
				<p>orderComment 정보</p>
				<table class="table table-borderless table-hover text-center">
					<tr class="border-bottom">
						<th width="37%">orderScore</th>
						<td style="padding-left: 10%;">
							<div class="progress" style="width: 80%; height: 30px; font-size: 18px;">
								<div class="progress-bar" style="width:<%=orderComment.getOrderScore()*10 %>%"><%=orderComment.getOrderScore() %></div>
							</div>
						</td>
					</tr>
					<tr class="font-weight-bold">
						<th width="37%">orderComment</th>
						<td></td>
					</tr>
					<tr class="font-weight-bold">
						<td colspan="2"><textarea rows="10" cols="135" name="orderCommentContent" readonly="readonly"><%=orderComment.getOrderCommentContent() %></textarea></td>
					</tr>
				</table>
			</div>
		<%
			} else {
		%>
			<div class="container p-3 my-3 border">
				<p>orderComment 정보</p>
				<table class="table table-borderless table-hover text-center">
					<tr class="border-bottom text-left">
						<th colspan="4" style="padding-left: 148px; padding-top: 30px;">qnaContent</th>
					</tr>
					<tr>
						<td colspan="4">
							<div class="container p-3 my-3 border" style="height: 200px; line-height: 150px;">
								아직 상품평이 작성되지 않았습니다.
							</div>
						</td>
					</tr>
				</table>
			</div>
		<%
			}
		%>
		
	</div>
	
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
	<div class="text-center">
  		<a href="<%=request.getContextPath() %>/admin/selectOrderList.jsp?currentPage=1" class="btn btn-outline-dark">목록</a>
	</div>
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
</div>
</body>
</html>