<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
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
</head>
<body>
<body>
<div class="container">
	<!-- start : 관리자 adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 adminMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - 회원정보 수정</h1>
		</div>
	
		<form method="post" action="./updateMemberAction.jsp">
			<table class="table table-borderless table-hover">
					<tr class="border-bottom font-weight-bold">
						<th class="text-right">memberNo</th>
						<td><input type="text" class="text-center" name="memberNo" value="<%=member.getMemberNo() %>" readonly="readonly"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberId</th>
						<td><input type="text" class="text-center" name="memberId" value="<%=member.getMemberId() %>"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">memberLevel</th>
						<td>
							<%
								String memberLevel = "";
								if(member.getMemberLevel() == 0) {
									memberLevel = " (일반회원)";
								} else if(member.getMemberLevel() == 1) {
									memberLevel = " (관리자)";
								}
							%>
							<input type="text" class="text-center" name="memberLevel" placeholder="<%=memberLevel %>" value="<%=member.getMemberLevel() %>">
							
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
							<input type="radio" name="memberNewGender" value="남" <%=memberGenderMale %>> 남
							<input type="radio" name="memberNewGender" value="여" <%=memberGenderFemale %>> 여
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
		</form>
	</div>
			
			<div class="text-center">
				<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/updateMemberAction.jsp?memberNo=<%=member.getMemberNo() %>">수정</a>
				<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selctMemberOne.jsp??memberNo=<%=member.getMemberNo() %>">취소</a>
			</div>
</div>
</body>
</body>
</html>