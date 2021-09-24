<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
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
	  <h1>메인 페이지</h1>
	</div>
	
	<%
		if(session.getAttribute("loginMember") == null) {
	%>
			<!-- 로그인 전  -->
			<table class="table table-hover text-center">
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/loginForm.jsp">로그인</a>
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/insertMemberForm.jsp">회원가입</a>
					</td><!-- insertMemberAction.jsp -->
				</tr>
			</table>
	<%		
		} else {
			Member loginMember = (Member)session.getAttribute("loginMember");
			System.out.println(loginMember.getMemberLevel() + " <-- memberLevel");
	%>
			<!-- 로그인 후 -->
			<table class="table table-hover text-center">
				<tr>
					<td>
						<%=loginMember.getMemberName()%>님 반갑습니다.
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/selectMemberOne.jsp?memberNo=<%=loginMember.getMemberNo() %>">회원정보</a>
					</td>
				</tr>
				
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/deleteMemberForm.jsp">회원탈퇴</a>
					</td>
				</tr>
				
				<!-- 관리자 페이지로 가는 링크 -->
				<%
					if(loginMember.getMemberLevel() > 0) {
				%>
				<tr>
					<td>
						<a href="<%=request.getContextPath() %>/admin/adminIndex.jsp">관리자 페이지</a>
					</td>
				</tr>
			</table>
				<%
						}
				%>
	<%	
		}
	%>
	
	<!-- 상품 목록 -->
	<%
	// paging
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 20; // 한 번 설정하면 변하지 않는다 -> 상수
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
	ArrayList<Ebook> ebookList = ebookDao.selectEbookListAllByPage(beginRow, ROW_PER_PAGE);
	%>
	<table class="table table-borderless text-center">
		<tr>
			<%
				int i = 0;
				for(Ebook e : ebookList) {
			%>
						<td>
							<div><img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>" width="200" height="200"></div>
							<div><%=e.getEbookTitle() %></div>
							<div>₩ <%=e.getEbookPrice() %></div>
						</td>
			<%
					i+=1; // for문이 한 바퀴 돌 때마다 i는 1씩 증가
					if(i%5 == 0) {
			%>
						<!-- 줄바꿈 : table이니까 tr닫고 다시 열어주기 -->
						</tr><tr>
			<%			
					}
				}
			%>
		</tr>
	</table>
</div>
</body>
</html>
