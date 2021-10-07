<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 0) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	int memberNo = loginMember.getMemberNo();
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
		  <h1>회원 페이지 - 회원탈퇴</h1>
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
					<td><%=member.getMemberId() %></a></td>
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
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/deleteMemberAction.jsp?memberNo=<%=member.getMemberNo() %>">삭제</a>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/selectMemberOne.jsp?memberNo=<%=member.getMemberNo() %>">취소</a>
	</div>
	
	<div class="container pt-3"></div>
</div>
</body>
</html>