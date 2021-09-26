<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	int memberLevel = Integer.parseInt(request.getParameter("memberLevel"));
	
	// debug
	System.out.println("등급수정" + memberNo);
	System.out.println("등급수정" + memberLevel);

	// 방어코드
	if(request.getParameter("memberNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectMemberList.jsp?currentPage=1");
		return;
	}
	if(request.getParameter("memberLevel") == null) {
		response.sendRedirect(request.getContextPath() + "/selectMemberList.jsp?currentPage=1");
		return;
	}
	
	
	Member member = null;
	member = new Member();
	member.setMemberNo(memberNo);
	member.setMemberLevel(memberLevel);

	// dao
	MemberDao memberDao = new MemberDao();
	
	memberDao.updateMemberLevelByAdmin(member);
	System.out.println("회원등급 수정 성공");
	response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
%>
