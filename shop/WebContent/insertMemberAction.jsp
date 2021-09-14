<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// 로그인 상태에서는 페이지 접근불가
	if(session.getAttribute("loginMember") != null) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}

	// 회원가입 입력값 유효성 검사
	if(request.getParameter("memberId") == null || request.getParameter("memberPw") == null || request.getParameter("memberName") == null || request.getParameter("memberAge") == null || request.getParameter("memberGender") == null) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	
	// 회원가입 입력값 유효성 검사
	if(request.getParameter("memberId").equals("") || request.getParameter("memberPw").equals("") || request.getParameter("memberName").equals("") || request.getParameter("memberAge").equals("") || request.getParameter("memberGender").equals("")) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	
	MemberDao memberDao = new MemberDao();
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberName = request.getParameter("memberName");
	int memberAge = Integer.parseInt(request.getParameter("memberAge"));
	String memberGender = request.getParameter("memberGender");
	// debug request 매개값
	System.out.println("debug memberId" + memberId);
	System.out.println("debug memberPw" + memberPw);
	System.out.println("debug memberName" + memberName);
	System.out.println("debug memberAge" + memberAge);
	System.out.println("debug memberGender" + memberGender);

	Member member = null;
	member = new Member();
	member.setMemberId(memberId);
	member.setMemberPw(memberPw);
	member.setMemberName(memberName);
	member.setMemberAge(memberAge);
	member.setMemberGender(memberGender);
		
	if(memberDao.insertMember(member)) { // 입력성공
	   System.out.println("회원가입 성공"); // 디버깅
	   response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
	} else { // 입력실패
	   System.out.println("회원가입 실패"); // 디버깅
	   response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
	}
%>