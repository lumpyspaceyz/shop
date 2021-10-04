<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) { // 로그인한 회원 + 관리자 : Qna 입력 가능
		response.sendRedirect(request.getContextPath() + "/insertQnaForm.jsp");
		return;
	}

	// qna 입력값 유효성 검사 - null
	if(request.getParameter("qnaCategory") == null || request.getParameter("qnaTitle") == null || request.getParameter("qnaContent") == null || request.getParameter("qnaSecret") == null || request.getParameter("memberNo") == null) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath() + "/insertQnaForm.jsp");
		return;
	}
	
	// qna 입력값 유효성 검사 - ""
	if(request.getParameter("qnaCategory").equals("") || request.getParameter("qnaTitle").equals("") || request.getParameter("qnaContent").equals("") || request.getParameter("qnaSecret").equals("") || request.getParameter("memberNo").equals("")) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath()+"/insertQnaForm.jsp");
		return;
	}
	
	String qnaCategory = request.getParameter("qnaCategory");
	String qnaTitle = request.getParameter("qnaTitle");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String qnaContent = request.getParameter("qnaContent");
	String qnaSecret = request.getParameter("qnaSecret");
	
	// debug request 매개값
	System.out.println("debug qnaCategory " + qnaCategory);
	System.out.println("debug qnaTitle " + qnaTitle);
	System.out.println("debug memberNo " + memberNo);
	System.out.println("debug qnaContent " + qnaContent);
	System.out.println("debug qnaSecret " + qnaSecret);

	// dao
	QnaDao qnaDao = new QnaDao();
	
	Qna qna = null;
	qna = new Qna();
	qna.setQnaCategory(qnaCategory);
	qna.setQnaTitle(qnaTitle);
	qna.setMemberNo(memberNo);
	qna.setQnaContent(qnaContent);
	qna.setQnaSecret(qnaSecret);
	
	qnaDao.insertQna(qna);
		
	response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp?currentPage=1");
%>