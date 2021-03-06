<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	
	// qnaNo 유효성 검사
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}
	
	int qnaCommentNo = Integer.parseInt(request.getParameter("qnaCommentNo"));
	// debug
	System.out.println("debug " + qnaCommentNo + " <-- qnaCommentNo");
	
	// qnaCommentNo 유효성 검사
	if(request.getParameter("qnaCommentNo") == null || request.getParameter("qnaCommentNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}
	
	String qnaCommentContent = request.getParameter("qnaCommentContent");
	// debug
	System.out.println("debug " + qnaCommentContent + " <-- qnaCommentContent");
	
	// qnaCommentContent 유효성 검사
	if(request.getParameter("qnaCommentContent") == null || request.getParameter("qnaCommentContent").equals("")) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}
	
	QnaComment qnaComment = new QnaComment();
	qnaComment.setQnaCommentNo(qnaCommentNo);
	qnaComment.setQnaCommentContent(qnaCommentContent);
	
	// dao
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.updateQnaComment(qnaComment);

	System.out.println("qnaComment 수정 성공");
	response.sendRedirect(request.getContextPath() + "/selectQnaOne.jsp?qnaNo=" + qnaNo);
%>