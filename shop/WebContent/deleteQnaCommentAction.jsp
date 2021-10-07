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
	int qnaCommentNo = Integer.parseInt(request.getParameter("qnaCommentNo"));
	// debug
	System.out.println(qnaNo + "<-- qnaNo");
	System.out.println(qnaCommentNo + "<-- qnaCommentNo");
	
	QnaComment qnaComment = new QnaComment();
	qnaComment.setQnaNo(qnaNo);
	qnaComment.setQnaCommentNo(qnaCommentNo);

	// dao
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.deleteQnaComment(qnaComment);
	
	System.out.println("qnaComment 삭제 성공");
	response.sendRedirect(request.getContextPath() + "/selectQnaOne.jsp?qnaNo=" + qnaNo);
%>