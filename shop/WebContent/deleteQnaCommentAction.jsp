<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*"%>
<%@ page import="java.sql.*"%>
<%
	//encoding
	request.setCharacterEncoding("utf-8");
	
	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) { // 로그인한 회원 + 관리자 : Qna 조회 가능
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
	
	
	QnaComment qnaComment = new QnaComment();
	qnaComment.setQnaNo(qnaNo);
	qnaComment.setQnaCommentNo(qnaCommentNo);

	// dao
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.deleteQnaComment(qnaComment);
	
	System.out.println("qnaComment 삭제 성공");
	response.sendRedirect(request.getContextPath() + "/selectQnaOne.jsp?qnaNo=" + qnaNo);
%>