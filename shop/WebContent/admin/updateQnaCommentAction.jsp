<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	
	// qnaNo 유효성 검사
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/admin/selectQnaList.jsp?currentPage=1");
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
	response.sendRedirect(request.getContextPath() + "/admin/selectQnaOne.jsp?qnaNo=" + qnaNo);
%>