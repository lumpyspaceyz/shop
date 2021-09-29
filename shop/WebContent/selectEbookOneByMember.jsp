<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 접속회원 세션 관리
	if(request.getParameter("ebookNo") == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp?currentPage=1");
		return;
	}
	
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// debug
	System.out.println("debug " + ebookNo + " <-- ebookNo");
	
	// paging
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 3; // 한 번 설정하면 변하지 않는다 -> 상수
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
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
	
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	double avgScore = orderCommentDao.selectOrderScoreAvg(ebookNo); // 별점 평균
	
	ArrayList<OrderComment> orderCommentList = orderCommentDao.selectOrderCommentListByEbookNo(beginRow, ROW_PER_PAGE, ebookNo); // 별점 목록
	int totalCount = orderCommentDao.selectOrderCommentTotalCount(ebookNo);
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
		  <h1>회원 페이지 - ebook 상세 보기(주문)</h1>
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
	
	<div class="container pt-3"></div>
	
	<!-- 주문 입력하는 폼 -->
	<div class="text-center">
		<%
			//방어코드 : 접속회원 세션 관리
			Member loginMember = (Member)session.getAttribute("loginMember");
			if(loginMember == null) {
			%>
				<div>
					<p>로그인 후에 주문이 가능합니다.</p>
					<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/loginForm.jsp">login</a>
					<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/index.jsp?currentPage=1">main</a>
				</div>
			<%
			} else {
			%>
				<form method="post" action="<%=request.getContextPath() %>/insertOrderAction.jsp">
					<input type="hidden" name="ebookNo" value="<%=ebookNo %>">
					<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo() %>">
					<input type="hidden" name="orderPrice" value="<%=ebook.getEbookPrice() %>">
					<button type="submit" class="btn btn-outline-dark">주문</button>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/index.jsp?currentPage=1">main</a>
				</form>
			<%
			}
		%>
	</div>
	
	<div class="container pt-3"></div>
	
	<!-- 이 상품의 별점의 평균 -->
	<!-- "select avg(order_score) from order_comment where ebook_no=? order by ebook_no" -->
	<!-- 이 상품의 후기 -->
	<!-- "select * from order_comment where ebook_no=? limit ?,?" -->
	<div class="container p-3 my-3 border">
	
		<p>별점 평균 : <%=avgScore %></p>
		<div class="progress" style="height: 25px; font-size: 18px;">
			<div class="progress-bar" style="width:<%=avgScore*10 %>%"><%=avgScore %></div>
		</div>
		
		<div class="container pt-3"></div>
	
		<label>Review list : </label>
		<div class="text-center">
			<table class="table">
				<thead>
					<tr class="font-weight-bold">
						<td>번호</td>
						<td>orderScore</td>
						<td>orderCommentContent</td>
						<td>date</td>
					</tr>
				</thead>
				<tbody>
				<%
					int no = 1 + beginRow;
					for(OrderComment orderComment : orderCommentList) {
				%>
						<tr>
							<td><%=no%></td>
							<td><%=orderComment.getOrderScore() %></td>
							<td><%=orderComment.getOrderCommentContent() %></td>
							<td><%=orderComment.getUpdateDate() %></td>
							
							<!-- 댓글 삭제 후 다시 boardOne으로 되돌아오기 위해서 boardNo도 함께 넘겨준다 -->
						</tr>
				<%		
						no++;
					}
				%>
				</tbody>
			</table>
		</div>
		
		<!-- start : 후기 페이징 -->
		<div class="text-center">
			<%
				// 마지막 페이지 정보
				int lastPage = totalCount / ROW_PER_PAGE;
				if(totalCount % ROW_PER_PAGE != 0) {
					lastPage++;	// lastPage+=1
				}
				
				// 디버깅
				System.out.println(totalCount + "<-- 전체 총 후기 수");
				System.out.println(lastPage + "<-- 마지막 페이지");
				
				if(currentPage > ROW_PER_PAGE) {	// 현재 페이지 번호(currentPage)가 페이징 수(rowPerPage)보다 크면 rowPerPage씩 넘어갈 수 있는 이전 버튼 활성화
			%>
				<a class="btn btn-outline-dark btn-sm" href="<%=request.getContextPath() %>/selectEbookOneByMember.jsp?currentPage=1">≪</a>
				<a class="btn btn-outline-dark btn-sm" href="<%=request.getContextPath() %>/selectEbookOneByMember.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>&ebookNo=<%=ebookNo %>">＜</a>
				<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
			<%		
				}
		
				for(int i=first; i<first+ROW_PER_PAGE; i++) {
					if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
						break;
					} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
			%>	
						<a class="btn btn-dark btn-sm" href="<%=request.getContextPath() %>/selectEbookOneByMember.jsp?currentPage=<%=i %>&first=<%=first%>&ebookNo=<%=ebookNo %>"><%=i %></a>
			<%
					} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
			%>
						<a class="btn btn-outline-dark btn-sm" href="<%=request.getContextPath() %>/selectEbookOneByMember.jsp?currentPage=<%=i %>&first=<%=first%>&ebookNo=<%=ebookNo %>"><%=i %></a>
			<%
					}
				}
				
				if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
		%>
				<a class="btn btn-outline-dark btn-sm" href="<%=request.getContextPath() %>/selectEbookOneByMember.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>&ebookNo=<%=ebookNo %>">＞</a>
				<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
				
				<a class="btn btn-outline-dark btn-sm" href="<%=request.getContextPath() %>/selectEbookOneByMember.jsp?currentPage=<%=lastPage %>&ebookNo=<%=ebookNo %>">≫</a>
		<%
				}
		%>
		</div>
		<!-- end : 후기 페이징 -->
	</div>
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
</div>
</body>
</html>