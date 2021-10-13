<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	// 방어코드 : 관리자 세션 관리
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
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	ArrayList<OrderComment> orderCommentList = null;
	orderCommentList = orderCommentDao.selectOrderCommentListByAdmin(beginRow, ROW_PER_PAGE);
	int totalCount = 0;
	totalCount = orderCommentDao.selectOrderCommentTotalCountByAdmin();
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
	<!-- start : 관리자 메뉴 include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 메뉴 include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - 상품평 관리</h1>
		</div>
		
		<table class="table table-striped table-hover text-center">
				<thead>
					<tr class="font-weight-bold">
						<th>orderNo</th>
						<th>ebookNo</th>
						<th>orderScore</th>
						<th>orderCommentContent</th>
						<th>updateDate</th>
						<th>수정/삭제</th>
					</tr>
				</thead>
				<tbody>
				<%
				for(OrderComment orderComment : orderCommentList) {
				%>
					<tr>
						<td><%=orderComment.getOrderNo() %></td>
						<td><%=orderComment.getEbookNo() %></td>
						<td><%=orderComment.getOrderScore() %></td>
						<td><%=orderComment.getOrderCommentContent() %></td>
						<td><%=orderComment.getUpdateDate() %></td>
						<td>
							<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 카테고리 정보 수정 -->
							<a href="<%=request.getContextPath() %>/admin/selectOrderCommentOne.jsp?orderNo=<%=orderComment.getOrderNo() %>&ebookNo=<%=orderComment.getEbookNo() %>">상세보기</a>
						</td>
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
		<a href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=1" class="btn btn-outline-dark">≪</a>
		<a href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>" class="btn btn-outline-dark">＜</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
<%		
		}

		for(int i=first; i<first+ROW_PER_PAGE; i++) {
			if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
				break;
			} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
%>	
				<a class="btn btn-dark" href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=i %>&first=<%=first%>"><%=i %></a>
<%
			} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
%>
				<a href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=i %>&first=<%=first%>" class="btn btn-outline-dark"><%=i %></a>
<%
			}
		}
		
		if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
%>
		<a href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>" class="btn btn-outline-dark">＞</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
		
		<a href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=lastPage %>" class="btn btn-outline-dark">≫</a>
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