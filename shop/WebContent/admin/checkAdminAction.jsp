<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	String prevPage = request.getParameter("prevPage");
	System.out.println(prevPage+"prevPage");
	
	// checkAdminForm.jsp에서 받아온 관리자 id/pw 값
	String adminId = request.getParameter("adminId");
	String adminPw = request.getParameter("adminPw");
	// session으로 받아온 로그인한 회원(관리자) id/pw 값
	String memberId = loginMember.getMemberId();
	String memberPw = loginMember.getMemberPw();
	
	// checkAdminForm.jsp에서 받아온 값으로 관리자 권한 체크
	Member checkAdmin = null;
	checkAdmin = new Member();
	checkAdmin.setMemberId(adminId);
	checkAdmin.setMemberPw(adminPw);
	// debug
	System.out.println("admin debug " + loginMember.getMemberId() + " <-- adminId");
	System.out.println("admin debug " + loginMember.getMemberPw() + " <-- adminPw");
	System.out.println("admin debug " + adminId + " <-- adminId");
	System.out.println("admin debug " + adminPw + " <-- adminPw");
	
	// dao
	MemberDao memberDao = new MemberDao();
	//memberDao.checkAdmin(checkAdmin);
	
	if(memberDao.checkAdmin(checkAdmin) == true) {
		System.out.println("되나?");
		response.sendRedirect(request.getContextPath()+ "/admin/deleteMemberForm.jsp");
		return;
	} else {
		System.out.println("안 되나?");
		response.sendRedirect(request.getContextPath()+ "/admin/"+prevPage+"Form.jsp");	
	}
%>
