<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String memberPw = request.getParameter("memberPw");
	
	// debug
	System.out.println("비밀번호수정" + memberNo);
	System.out.println("비밀번호수정" + memberPw);

	// 방어코드
	if(request.getParameter("memberNo") == null) {
		response.sendRedirect("./selectMemberList.jsp?currentPage=1");
		return;
	}
	if(request.getParameter("memberPw") == null) {
		response.sendRedirect("./selectMemberList.jsp?currentPage=1");
		return;
	}
	
	
	Member member = null;
	member = new Member();
	member.setMemberNo(memberNo);
	member.setMemberPw(memberPw);

	// dao
	MemberDao memberDao = new MemberDao();
	
	memberDao.updateMemberPwByAdmin(member);
	System.out.println("비밀번호 수정 성공");
	response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
%>
