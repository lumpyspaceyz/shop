<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	// 방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) { // 이전 페이지 selectQnaOne.jsp에서 관리자, qna작성자만 qnaComment 입력 가능하게 처리
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("qnaNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}
	
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	String qnaCommentContent = request.getParameter("qnaCommentContent");
	
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	System.out.println("debug " + qnaCommentContent + " <-- qnaCommentContent");

	// dao
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	
	QnaComment qnaComment = null;
	qnaComment = new QnaComment();
	qnaComment.setQnaNo(qnaNo);
	qnaComment.setQnaCommentContent(qnaCommentContent);
	qnaComment.setMemberNo(loginMember.getMemberNo());
	
	qnaCommentDao.insertQnaComment(qnaComment);
	
	System.out.println("답변 입력성공");
	response.sendRedirect(request.getContextPath() + "/selectQnaOne.jsp?qnaNo=" + qnaNo);
%>
</body>
</html>




