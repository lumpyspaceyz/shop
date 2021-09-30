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

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// 방어코드
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/admin/selectNoticeOne.jsp?currentPage=1");
		return;
	}
	
	// dao
	NoticeDao noticeDao = new NoticeDao();
	
	noticeDao.deleteNotice(noticeNo);
	System.out.println("공지 삭제 성공");
	response.sendRedirect(request.getContextPath() + "/admin/selectNoticeList.jsp");
%>
