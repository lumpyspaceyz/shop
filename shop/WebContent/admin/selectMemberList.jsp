<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!-- 방어코드 -->
<%
	// 방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// encoding
	request.setCharacterEncoding("utf-8");
	
	// paging
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10; // 한 번 설정하면 변하지 않는다 -> 상수
	int beginRow = (1-currentPage) * ROW_PER_PAGE;
	int nowPage = (currentPage / ROW_PER_PAGE) + 1; // 현재 시작 페이징(=first)을 계산하기 위한 변수
	int first = (nowPage * ROW_PER_PAGE) - (ROW_PER_PAGE-1); // 현재 시작 페이징 번호
	if(request.getParameter("first") != null) {
		first = Integer.parseInt(request.getParameter("first"));
	}
	// debug
	System.out.println("paging debug" + currentPage + "<-- currentPage");
	System.out.println("paging debug" + nowPage + "<-- nowPage");
	System.out.println("paging debug" + beginRow + "<-- beginRow");
	System.out.println("paging debug" + first + "<-- first");

	MemberDao memberDao = new MemberDao();
	ArrayList<Member> memberList = memberDao.selectMemberListAllByPage(beginRow, ROW_PER_PAGE);
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
	<!-- end : submenu include -->
	
	<div class="jumbotron">
	  <h1>관리자 페이지 - 회원목록</h1>
	</div>
	
	<table class="table table-striped table-hover text-center">
			<thead>
				<tr class="font-weight-bold">
					<th>memberNo</th>
					<th>memberLevel</th>
					<th>memberName</th>
					<th>memberAge</th>
					<th>memberGender</th>
					<th>updateDate</th>
					<th>createDate</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
			<%
			for(Member member : memberList) {
			%>
				<tr>
					<td><%=member.getMemberNo() %></td>
					<td><%=member.getMemberLevel() %>
						<%
							if(member.getMemberLevel() == 0) {
						%>	
								<span>일반회원</span>	
						<%
							} else if(member.getMemberLevel() == 1) {
						%>	
								<span>관리자</span>	
						<%
							}
						%>
					</td>
					<td><%=member.getMemberName() %></td>
					<td><%=member.getMemberAge() %></td>
					<td><%=member.getMemberGender() %></td>
					<td><%=member.getUpdateDate() %></td>
					<td><%=member.getCreateDate() %></td>
				</tr>
			<%
			}
			%>
			</tbody>
	
</div>
</body>
</html>