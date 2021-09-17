<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	// 방어코드
	if(request.getParameter("memberNo") == null) {
		response.sendRedirect("./selectMemberList.jsp?currentPage=1");
		return;
	}

	// encoding
	request.setCharacterEncoding("utf-8");

	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	// debug
	System.out.println("debug " + memberNo + " <-- memberNo");
	
	// dao
	MemberDao memberDao = new MemberDao();
	
	Member member = memberDao.selectMemberOne(memberNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
a, a:hover {
	color: #000;
}
nav li {
	font-size: 1.3em;
	padding-left: 20px;
}
</style>
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
		  <h1>관리자 페이지 - 회원목록</h1>
		</div>
	
		<table class="table table-borderless table-hover text-center">
			<thead>
				<tr class="border-bottom font-weight-bold">
					<th>memberNo</th>
					<th>memberId</th>
					<th>memberLevel</th>
					<th>memberName</th>
					<th>memberAge</th>
					<th>memberGender</th>
					<th>updateDate</th>
					<th>createDate</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><%=member.getMemberNo() %></td>
					<td><a href="<%=request.getContextPath() %>/admin/selectMemberOne.jsp?memberNo=<%=member.getMemberNo() %>"><%=member.getMemberId() %></a></td>
					<td><%=member.getMemberLevel() %>
						<%
							if(member.getMemberLevel() == 0) {
						%>	
								<br><span>일반회원</span>	
						<%
							} else if(member.getMemberLevel() == 1) {
						%>	
								<br><span>관리자</span>	
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
			</tbody>
		</table>
	</div>
	
	<div class="text-center">
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/updateMemberForm.jsp?memberNo=<%=member.getMemberNo() %>">수정</a>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/deleteMemberForm.jsp?memberNo=<%=member.getMemberNo() %>">삭제</a>
		<a class="btn btn-outline-dark" href="./index.jsp">index</a>
	</div>
	
	<div class="container pt-3"></div>
</div>
</body>
</html>