<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 0) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int orderScore = Integer.parseInt(request.getParameter("orderScore"));
	String orderCommentContent = request.getParameter("orderCommentContent");
	
	OrderComment orderComment = new OrderComment();
	orderComment.setOrderNo(orderNo);
	orderComment.setEbookNo(ebookNo);
	orderComment.setOrderScore(orderScore);
	orderComment.setOrderCommentContent(orderCommentContent);
	
	// dao
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	orderCommentDao.insertOrderComment(orderComment);

	System.out.println("후기 작성 성공");
	response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp?memberNo=" + loginMember.getMemberNo());
%>