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
	ArrayList<OrderEbookMember> list = orderDao.selectOrderListByMember(loginMember.getMemberNo(), beginRow, ROW_PER_PAGE);
	int totalCount = 0;
	totalCount = orderDao.selectTotalCount(loginMember.getMemberNo());
	
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
								<td><%=oem.getOrder().getOrderNo() %></td>
								<td><%=oem.getEbook().getEbookTitle() %></td>
								<td><%=oem.getOrder().getOrderPrice() %></td>
								<td><%=oem.getOrder().getCreateDate() %></td>
								<td><%=oem.getMember().getMemberId() %></td>
								<td>
									<a href="<%=request.getContextPath() %>/selectOrderOne.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>">확인하기</a>
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
	
	<!-- start : 페이징 -->
	<div class="text-center">
<%
		// 마지막 페이지 정보
		int lastPage = totalCount / ROW_PER_PAGE;
		if(totalCount % ROW_PER_PAGE != 0) {
			lastPage++;	// lastPage+=1
		}
		
		// 디버깅
		System.out.println(totalCount + "<-- 전체 총 게시글 수");
		System.out.println(lastPage + "<-- 마지막 페이지");
		
		if(currentPage > ROW_PER_PAGE) {	// 현재 페이지 번호(currentPage)가 페이징 수(rowPerPage)보다 크면 rowPerPage씩 넘어갈 수 있는 이전 버튼 활성화
%>
		<a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=1" class="btn btn-outline-dark">≪</a>
		<a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>" class="btn btn-outline-dark">＜</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
<%		
		}

		for(int i=first; i<first+ROW_PER_PAGE; i++) {
			if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
				break;
			} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
%>	
				<a class="btn btn-dark" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=i %>&first=<%=first%>"><%=i %></a>
<%
			} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
%>
				<a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=i %>&first=<%=first%>" class="btn btn-outline-dark"><%=i %></a>
<%
			}
		}
		
		if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
%>
		<a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>" class="btn btn-outline-dark">＞</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
		
		<a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=lastPage %>" class="btn btn-outline-dark">≫</a>
<%
		}
%>
	</div>
	<!-- end : 페이징 -->
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
</div>
</body>
</html>