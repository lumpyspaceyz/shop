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
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	// 카테고리 추가 입력값 유효성 검사 - null
	if(request.getParameter("categoryName") == null || request.getParameter("categoryState") == null) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp");
		return;
	}
	
	// 카테고리 추가 입력값 유효성 검사 - ""
	if(request.getParameter("categoryName").equals("") || request.getParameter("categoryState").equals("")) {
		// 다시 브라우저에게 다른곳을 요청하도록 하는 메서드
		// 보내는 게 아님. 다른곳을 호출하도록 하는 것.
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp");
		return;
	}
	
	String categoryName = request.getParameter("categoryName");
	String categoryState = request.getParameter("categoryState");
	// debug request 매개값
	System.out.println("debug categoryName " + categoryName);
	System.out.println("debug categoryState " + categoryState);

	// dao
	CategoryDao categoryDao = new CategoryDao();
	
	Category category = null;
	category = new Category();
	category.setCategoryName(categoryName);
	category.setCategoryState(categoryState);
	
	categoryDao.insertCategory(category);
		
	response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
%>