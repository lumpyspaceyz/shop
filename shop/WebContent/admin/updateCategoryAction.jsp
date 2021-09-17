<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	String categoryName = request.getParameter("categoryName");
	String categoryState = request.getParameter("categoryState");
	
	// debug
	System.out.println("카테고리 수정 " + categoryName);
	System.out.println("카테고리 수정 " + categoryState);

	// 방어코드
	if(request.getParameter("categoryName") == null || request.getParameter("categoryName") == "") {
		response.sendRedirect(request.getContextPath() + "/admin/selectCategoryList.jsp");
		return;
	}
	if(request.getParameter("categoryState") == null || request.getParameter("categoryState") == "") {
		response.sendRedirect(request.getContextPath() + "/admin/selectCategoryList.jsp");
		return;
	}
	
	
	Category category = null;
	category = new Category();
	category.setCategoryName(categoryName);
	category.setCategoryState(categoryState);

	// dao
	CategoryDao categoryDao = new CategoryDao();
	
	categoryDao.updateCategory(category);
	System.out.println("카테고리 수정 성공");
	response.sendRedirect(request.getContextPath() + "/admin/selectCategoryList.jsp");
%>
