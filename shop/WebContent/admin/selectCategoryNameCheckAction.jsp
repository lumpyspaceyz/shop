<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	// memberIdCheck 입력값 유효성 검사 - null / ""
	if(request.getParameter("categoryCheck") == null || request.getParameter("categoryCheck").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp");
		return;
	}
	String categoryCheck = request.getParameter("categoryCheck");
	// debug
	System.out.println("debug " + categoryCheck + " <-- categoryCheck");
	
	// dao
	CategoryDao categoryDao = new CategoryDao();
	
	String result = "";
	result = categoryDao.selectCategoryName(categoryCheck);
	// debug
	System.out.println("debug " + result + " <-- result");
	
	if(result == null) {	
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?categoryCheck="+categoryCheck);
	} else {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?categoryNameCheckResult=No");
	}
%>