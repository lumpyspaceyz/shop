<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("ebookNo") == null) {
		response.sendRedirect(request.getContextPath() + "/admin/selectEbookList.jsp?currentPage=1");
		return;
	}

	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// debug
	System.out.println("debug " + ebookNo + " <-- ebookNo");
	
	// dao
	EbookDao ebookDao = new EbookDao();
	CategoryDao categoryDao = new CategoryDao();
	
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
	
	// 카테고리 불러오기
	ArrayList<Category> categoryList = categoryDao.selectCategoryList();
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
	
	<form method="post" action="<%=request.getContextPath() %>/admin/updateEbookAllAction.jsp">
		<div class="container p-3 my-3 border">
			<div class="jumbotron">
			  <h1>관리자 페이지 - ebook 정보 수정</h1>
			</div>
		
			<table class="table table-borderless table-hover">
				<tr class="border-bottom font-weight-bold">
					<th class="text-right" width="45%">ebookNo</th>
					<td><input type="text" class="text-center" name="ebookNo" value="<%=ebook.getEbookNo() %>" readonly="readonly"></td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookISBN</th>
					<td><input type="text" class="text-center" name="ebookISBN" value="<%=ebook.getEbookISBN() %>" readonly="readonly"></td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">categoryName</th>
					<td style="padding-right: 36%;">
						<select class="form-control text-center" name="categoryName">
							<%
								for(Category category : categoryList) {
							%>
								<option value="<%=category.getCategoryName() %>"><%=category.getCategoryName() %></option>
							<%
								}
							%>
						</select>
					</td>				
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookTitle</th>
					<td><input type="text" class="text-center" name="ebookTitle" value="<%=ebook.getEbookTitle() %>"></td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookAuthor</th>
					<td><input type="text" class="text-center" name="ebookAuthor" value="<%=ebook.getEbookAuthor() %>"></td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookCompany</th>
					<td><input type="text" class="text-center" name="ebookCompany" value="<%=ebook.getEbookCompany() %>"></td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookPageCount</th>
					<td><input type="text" class="text-center" name="ebookPageCount" value="<%=ebook.getEbookPageCount() %>" readonly="readonly"></td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookPrice</th>
					<td><input type="text" class="text-center" name="ebookPrice" value="<%=ebook.getEbookPrice() %>"></td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookImg</th>
					<td><img src="<%=request.getContextPath() %>/image/<%=ebook.getEbookImg() %>" width="300px"></td>				
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookSummary</th>
					<td><textarea rows="5" cols="50" name="ebookSummary"><%=ebook.getEbookSummary() %></textarea></td>					
				</tr>
				<%
						String[] ebookState = new String[4];
						if(ebook.getEbookState().equals("판매중")) {
							ebookState[0] = "checked";
						} else if(ebook.getEbookState().equals("품절")) {
							ebookState[1] = "checked";
						} else if(ebook.getEbookState().equals("절판")) {
							ebookState[2] = "checked";
						} else if(ebook.getEbookState().equals("구편절판")){
							ebookState[3] = "checked";
						}
				%>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">ebookState</th>
					<td>
						<input type="radio" name="ebookState" value="판매중" <%=ebookState[0] %>> 판매중
						<input type="radio" name="ebookState" value="품절" <%=ebookState[1] %>> 품절
						<div class="container pt-3"></div>
						<input type="radio" name="ebookState" value="절판" <%=ebookState[2] %>> 절판
						<input type="radio" name="ebookState" value="구편절판" <%=ebookState[3] %>> 구편절판
					</td>					
				</tr>
				<tr class="border-bottom font-weight-bold">					
					<th class="text-right">updateDate</th>
					<td><input type="text" class="text-center" name="updateDate" value="<%=ebook.getUpdateDate() %>" readonly="readonly"></td>				
				</tr>
				<tr class="border-bottom font-weight-bold">				
					<th class="text-right">createDate</th>
					<td><input type="text" class="text-center" name="createDate" value="<%=ebook.getCreateDate() %>" readonly="readonly"></td>
				</tr>
			</table>
		</div>
		<div class="text-center">
			<button class="btn btn-outline-dark" type="submit">수정</button>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selectEbookOne.jsp?ebookNo=<%=ebook.getEbookNo() %>">취소</a>
		</div>
	</form>
			
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
			
</div>
</body>
</body>
</html>