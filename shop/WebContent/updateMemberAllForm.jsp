<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) {
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
<body>
<div class="container">
	<!-- start : 회원 mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : 회원 mainMenu include -->
	
	<form method="post" action="<%=request.getContextPath() %>/updateMemberAllAction.jsp">
		<div class="container p-3 my-3 border">
			<div class="jumbotron">
			  <h1>회원 페이지 - 회원정보 수정</h1>
			</div>
		
			<table class="table table-borderless table-hover">
					<tr class="border-bottom font-weight-bold">
						<th class="text-right" width="45%">memberNo</th>
						<td><input type="text" class="text-center" name="memberNo" value="<%=member.getMemberNo() %>" readonly="readonly"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberId</th>
						<td><input type="text" class="text-center" name="memberId" value="<%=member.getMemberId() %>"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberLevel</th>
						<td style="padding-right: 36%;">
							<%
								if(member.getMemberLevel() == 0) {
							%>
								<input type="text" class="text-center" name="memberLevel" value="<%=member.getMemberLevel() %>" readonly="readonly">
							<%
								} else if(member.getMemberLevel() == 1) {
							%>
								<input type="text" class="text-center" name="memberLevel" value="<%=member.getMemberLevel() %>" readonly="readonly">
							<%
								}
							%>
							
						</td>							
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberName</th>
						<td><input type="text" class="text-center" name="memberName" value="<%=member.getMemberName() %>"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberAge</th>
						<td><input type="text" class="text-center" name="memberAge" value="<%=member.getMemberAge() %>"></td>					
					</tr>
					<%
							String memberGenderFemale = null;
							String memberGenderMale = null;
							if(member.getMemberGender().equals("여")) {
								memberGenderFemale = "checked";
							} else if(member.getMemberGender().equals("남")) {
								memberGenderMale = "checked";
							}
					%>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberGender</th>
						<td>
							<input type="radio" name="memberGender" value="남" <%=memberGenderMale %>> 남
							<input type="radio" name="memberGender" value="여" <%=memberGenderFemale %>> 여
						</td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">updateDate</th>
						<td><input type="text" class="text-center" name="updateDate" value="<%=member.getUpdateDate() %>" readonly="readonly"></td>				
					</tr>
					<tr class="border-bottom font-weight-bold">				
						<th class="text-right">createDate</th>
						<td><input type="text" class="text-center" name="createDate" value="<%=member.getCreateDate() %>" readonly="readonly"></td>
					</tr>
			</table>
		</div>
		<div class="text-center">
			<button class="btn btn-outline-dark" type="submit">수정</button>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selectMemberOne.jsp?memberNo=<%=member.getMemberNo() %>">취소</a>
		</div>
	</form>
			
			
</div>
</body>
</body>
</html>