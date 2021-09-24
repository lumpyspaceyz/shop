<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.ArrayList" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// paging
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10; // 한 번 설정하면 변하지 않는다 -> 상수
	int beginRow = (currentPage-1) * ROW_PER_PAGE;
	int nowPage = (currentPage / ROW_PER_PAGE) + 1; // 현재 시작 페이징(=first)을 계산하기 위한 변수
	int first = (nowPage * ROW_PER_PAGE) - (ROW_PER_PAGE-1); // 현재 시작 페이징 번호
	if(request.getParameter("first") != null) {
		first = Integer.parseInt(request.getParameter("first"));
	}
	// paging debug
	System.out.println("paging debug " + currentPage + " <-- currentPage");
	System.out.println("paging debug " + nowPage + " <-- nowPage");
	System.out.println("paging debug " + beginRow + " <-- beginRow");
	System.out.println("paging debug " + first + " <-- first");
	
	// dao
	OrderDao orderDao = new OrderDao();
	ArrayList<OrderEbookMember> list = orderDao.selectOrderList(beginRow, ROW_PER_PAGE);
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
	<!-- start : adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : adminMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - 주문 관리</h1>
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
						<th>회원등급수정</th>
						<th>비밀번호수정</th>
						<th>강제탈퇴</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(OrderEbookMember oem : list) {
					%>
							<tr>
								<td><a href="<%=request.getContextPath() %>/admin/selectOrderOne.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>"><%=oem.getOrder().getOrderNo() %></a></td>
								<td><%=oem.getEbook().getEbookTitle() %></td>
								<td><%=oem.getOrder().getOrderPrice() %></td>
								<td><%=oem.getOrder().getCreateDate() %></td>
								<td><%=oem.getMember().getMemberId() %></td>
								<td>
									<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원의 비밀번호를 수정 -->
									<a href="<%=request.getContextPath() %>/admin/updateMemberLevelForm.jsp?memberNo=">등급수정</a>
								</td>
								<td>
									<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원의 비밀번호를 수정 -->
									<a href="<%=request.getContextPath() %>/admin/updateMemberPwForm.jsp?memberNo=">비밀번호수정</a>
								</td>
								<td>
									<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원을 강제 탈퇴 -->
									<a href="<%=request.getContextPath() %>/admin/deleteMemberForm.jsp?memberNo=">강제탈퇴</a>
								</td>
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