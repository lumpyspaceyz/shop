<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/admin/insertNoticeForm.jsp");
		return;
	}

	// 공지 추가 입력값 유효성 검사 - null
	if(request.getParameter("noticeTitle") == null || request.getParameter("noticeContent") == null) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath() + "/admin/insertNoticeForm.jsp");
		return;
	}
	
	// 공지 추가 입력값 유효성 검사 - ""
	if(request.getParameter("noticeTitle").equals("") || request.getParameter("noticeContent").equals("")) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath()+"/admin/insertNoticeForm.jsp");
		return;
	}
	
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	
	// debug request 매개값
	System.out.println("debug noticeTitle " + noticeTitle);
	System.out.println("debug noticeContent " + noticeContent);
	System.out.println("debug memberNo " + memberNo);

	// dao
	NoticeDao noticeDao = new NoticeDao();
	
	Notice notice = null;
	notice = new Notice();
	notice.setNoticeTitle(noticeTitle);
	notice.setNoticeContent(noticeContent);
	notice.setMemberNo(memberNo);
	
	noticeDao.insertNotice(notice);
		
	response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp?currentPage=1");
%>