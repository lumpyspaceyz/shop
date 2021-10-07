<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
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
	
	// debug
	System.out.println("회원탈퇴" + memberNo);

	// 방어코드
	if(request.getParameter("memberNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectMemberOne.jsp?currentPage=1");
		return;
	}
	
	// dao
	MemberDao memberDao = new MemberDao();
	
	memberDao.deleteMember(memberNo);
	System.out.println("회원탈퇴 성공");
	session.invalidate(); // 사용자의 세션을 새로운 세션으로 갱신
	response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
