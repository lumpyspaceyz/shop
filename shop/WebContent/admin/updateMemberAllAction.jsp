<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String memberId = request.getParameter("memberId");
	int memberLevel = Integer.parseInt(request.getParameter("memberLevel"));
	String memberName = request.getParameter("memberName");
	int memberAge = Integer.parseInt(request.getParameter("memberAge"));
	String memberGender = request.getParameter("memberGender");
	
	Member member = new Member();
	member.setMemberNo(memberNo);
	member.setMemberId(memberId);
	member.setMemberLevel(memberLevel);
	member.setMemberName(memberName);
	member.setMemberAge(memberAge);
	member.setMemberGender(memberGender);
	
	// dao
	MemberDao memberDao = new MemberDao();
	memberDao.updateMemberAllByAdmin(member);

	System.out.println("회원정보 전체수정 성공");
	response.sendRedirect(request.getContextPath() + "/admin/selectMemberOne.jsp?memberNo=" + memberNo);
%>