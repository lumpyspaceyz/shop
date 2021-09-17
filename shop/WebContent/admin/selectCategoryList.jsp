<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	// 방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// encoding
	request.setCharacterEncoding("utf-8");
	
	// dao
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = null;
	categoryList = categoryDao.selectCategoryList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
	<!-- start : 관리자 메뉴 include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - 전자책 카테고리 관리</h1>
		</div>
		
		<table class="table table-striped table-hover text-center">
				<thead>
					<tr class="font-weight-bold">
						<th>catrgoryName</th>
						<th>updateDate</th>
						<th>createDate</th>
						<th>categoryState</th>
						<th>categoryUpdate</th>
					</tr>
				</thead>
				<tbody>
				<%
				for(Category category : categoryList) {
				%>
					<tr>
						<td><%=category.getCategoryName() %></td>
						<td><%=category.getUpdateDate() %></td>
						<td><%=category.getCreateDate() %></td>
						<td><%=category.getCategoryState() %>
							<%
								if(category.getCategoryState().equals("Y")) {
							%>	
									<br><span>공개</span>	
							<%
								} else if(category.getCategoryState().equals("N")) {
							%>	
									<br><span>비공개</span>	
							<%
								}
							%>
						</td>
						<td>
							<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 카테고리 정보 수정 -->
							<a href="<%=request.getContextPath() %>/admin/updateCategoryForm.jsp?categoryName=<%=category.getCategoryName() %>">수정</a>
						</td>
					</tr>
				<%
				}
				%>
				</tbody>
		</table>
	</div>
	
	<div class="container pt-3"></div>
	
	<div class="text-center">
		<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 카테고리 정보 추가 -->
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/insertCategoryForm.jsp">카테고리추가</a>
	</div>
	
	<div class="container pt-3"></div>
</div>
</body>
</html>