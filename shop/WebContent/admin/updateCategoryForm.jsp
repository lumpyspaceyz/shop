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

	String categoryName = request.getParameter("categoryName");
	// 방어코드
	if(request.getParameter("categoryName") == null) {
		response.sendRedirect("./selectCategoryList.jsp");
		return;
	}
	// debug
	System.out.println("debug " + categoryName + " <-- categoryName");
	
	// dao
	CategoryDao categoryDao = new CategoryDao();
	
	Category category = categoryDao.selectCategoryOne(categoryName);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<body>
<div class="container">
	<!-- start : 관리자 adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 adminMenu include -->
	
	<form method="post" action="<%=request.getContextPath() %>/admin/updateCategoryAction.jsp">
		<div class="container p-3 my-3 border">
			<div class="jumbotron">
			  <h1>관리자 페이지 - 카테고리 정보 수정</h1>
			</div>
	
			<table class="table table-borderless table-hover">
					<tr class="border-bottom font-weight-bold">
						<th class="text-right">categoryName</th>
						<td><input type="text" class="text-center" name="categoryName" value="<%=category.getCategoryName() %>" readonly="readonly"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">updateDate</th>
						<td><input type="text" class="text-center" name="updateDate" value="<%=category.getUpdateDate() %>" readonly="readonly"></td>					
					</tr>
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">createDate</th>
						<td><input type="text" class="text-center" name="createDate" value="<%=category.getCreateDate() %>" readonly="readonly"></td>					
					</tr>
					
					<tr class="border-bottom font-weight-bold">					
						<th class="text-right">categoryState</th>
						<td>
							<%
								if(category.getCategoryState().equals("Y")) {
							%>
								<select name="categoryState">
									<option value="Y" selected>공개</option>
									<option value="N">비공개</option>
								</select>
							<%
								} else if(category.getCategoryState().equals("N")) {
							%>
								<select name="categoryState">
									<option value="Y">공개</option>
									<option value="N" selected>비공개</option>
								</select>
							<%
								}
							%>
						</td>					
					</tr>
			</table>
		</div>
				
		<div class="text-center">
			<button type="submit" class="btn btn-outline-dark">수정</button>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selectCategoryList.jsp">취소</a>
		</div>
	</form>
</div>
</body>
</body>
</html>