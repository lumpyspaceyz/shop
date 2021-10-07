<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	
	// debug
	System.out.println("강제탈퇴" + memberNo);

	// 방어코드
	if(request.getParameter("memberNo") == null) {
		response.sendRedirect(request.getContextPath() + "/admin/selectMemberOne.jsp?currentPage=1");
		return;
	}
	
	// dao
	MemberDao memberDao = new MemberDao();
	
	memberDao.deleteMember(memberNo);
	System.out.println("회원 강제탈퇴 성공");
	response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
%>
