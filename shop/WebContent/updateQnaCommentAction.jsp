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
	
	// 방어코드
	if(request.getParameter("qnaNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}

	int qnaCommentNo = Integer.parseInt(request.getParameter("qnaCommentNo"));
	String qnaCommentContent = request.getParameter("qnaCommentContent");
	
	QnaComment qnaComment = new QnaComment();
	qnaComment.setQnaCommentNo(qnaCommentNo);
	qnaComment.setQnaCommentContent(qnaCommentContent);
	
	// dao
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.updateQnaComment(qnaComment);

	System.out.println("qnaComment 수정 성공");
	response.sendRedirect(request.getContextPath() + "/selectQnaOne.jsp?qnaNo=" + qnaNo);
%>