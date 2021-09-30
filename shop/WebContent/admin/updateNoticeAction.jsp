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
	
	// noticeNo 유효성 검사
	if(request.getParameter("noticeNo") == null || request.getParameter("noticeNo").equals("")) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath() + "/admin/updateNoticeForm.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	
	Notice notice = new Notice();
	notice.setNoticeNo(noticeNo);
	notice.setNoticeTitle(noticeTitle);
	notice.setNoticeContent(noticeContent);
	
	// dao
	NoticeDao noticeDao = new NoticeDao();
	noticeDao.updateNotice(notice);

	System.out.println("공지 수정 성공");
	response.sendRedirect(request.getContextPath() + "/admin/selectNoticeOne.jsp?noticeNo=" + noticeNo);
%>