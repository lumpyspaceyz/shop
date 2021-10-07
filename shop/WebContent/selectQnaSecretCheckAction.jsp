<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");
	
	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) { // 로그인한 회원 + 관리자 : Qna 조회 가능
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	// qnaSecret 입력값 유효성 검사 - null / ""
	if(request.getParameter("qnaSecret") == null || request.getParameter("qnaSecret").equals("")) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}
	
	String qnaSecret = request.getParameter("qnaSecret");
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// debug
	System.out.println("debug " + qnaSecret + " <-- qnaSecret");
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	
	// dao
	QnaDao qnaDao = new QnaDao();
	
	boolean result = qnaDao.qnaSecretCheck(qnaNo, qnaSecret, loginMember.getMemberNo());
	System.out.println("result --> " + result);
	
	if(result == true || loginMember.getMemberLevel() > 0) { // 로그인한 회원: qnaSecret 확인 후 조회 가능, 관리자: 조회 가능
		response.sendRedirect(request.getContextPath() + "/selectQnaOne.jsp?qnaNo=" + qnaNo);
	} else {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
	}
%>