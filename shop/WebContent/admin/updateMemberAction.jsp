<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<body>
	<h1>회원정보 수정</h1>
<%
	request.setCharacterEncoding("utf-8");
	MemberDao memberDao = new MemberDao();
	
	if(session.getAttribute("loginMember") == null) {
		response.sendRedirect("./index.jsp");
		return;
	}
	
	Member loginMember = (Member)session.getAttribute("loginMember");
	Member member = memberDao.selectMemberOne(loginMember.getMemberNo());
	// debug
	System.out.println(member.getMemberId() + "<-- loginMemberId");
	System.out.println(member.getMemberGender() + "<-- loginMemberGender");
%>
	<form method="post" action="./updateMemberAction.jsp">
		<div>아이디 : </div>
		<div><input type="text" name="memberId" value="<%=member.getMemberId() %>" readonly="readonly"></div>
		<div>비밀번호 : </div>
		<div><input type="text" name="memberNewPw"  value="<%=member.getMemberPw() %>"></div>
		<div>이름 : </div>
		<div><input type="text" name="memberNewName" value="<%=member.getMemberName() %>"></div>
		<div>나이 : </div>
		<div><input type="text" name="memberNewAge" value="<%=member.getMemberAge() %>"></div>
		
<%
		String memberGenderFemale = null;
		String memberGenderMale = null;
		if(member.getMemberGender().equals("여")) {
			memberGenderFemale = "checked";
		} else if(member.getMemberGender().equals("남")) {
			memberGenderMale = "checked";
		}
%>
		
		<div>성별 : </div>
		<div>
			<input type="radio" name="memberNewGender" value="남" <%=memberGenderMale %>> 남
			<input type="radio" name="memberNewGender" value="여" <%=memberGenderFemale %>> 여
		</div>
		<br>
		<div>
			<button type="submit">회원정보 수정</button>
		</div>
	</form>
</body>
</body>
</html>