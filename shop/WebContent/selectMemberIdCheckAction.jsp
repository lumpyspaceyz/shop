<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	// memberIdCheck 입력값 유효성 검사 - null / ""
	if(request.getParameter("memberIdCheck") == null || request.getParameter("memberIdCheck").equals("")) {
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	String memberIdCheck = request.getParameter("memberIdCheck");
	// debug
	System.out.println("debug " + memberIdCheck + " <-- memberIdCheck");
	
	// dao
	MemberDao memberDao = new MemberDao();
	
	String result = "";
	result = memberDao.selectMemberId(memberIdCheck);
	// debug
	System.out.println("debug " + result + " <-- result");
	
	if(result == null) {	
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?memberIdCheck="+memberIdCheck);
	} else {
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?idCheckResult=No");
	}
%>