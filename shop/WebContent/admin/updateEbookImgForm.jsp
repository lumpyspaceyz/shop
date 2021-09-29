<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.File" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("ebookNo") == null) {
		response.sendRedirect(request.getContextPath() + "admin/selectEbookList.jsp?currentPage=1");
		return;
	}

	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// debug
	System.out.println("debug " + ebookNo + " <-- ebookNo");
	
	// dao
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = ebookDao.selectEbookOne(ebookNo); // noimage:기본이미지, other:다른이미지
	
	File beforeImg = new File("C:\\git-shop\\shop\\WebContent\\image\\" + ebook.getEbookImg());
	System.out.println("beforeImg --> " + beforeImg);
	
	// 수정 전 이미지(beforeImg)가 기본 이미지(noimage)가 아닌 다른 이미지(other)이면 삭제
	if(ebookDao.selectEbookImg(ebookNo).equals("other")) {
		beforeImg.delete();
	}
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
	<!-- start : 관리자 adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 adminMenu include -->
	
	<form action="<%=request.getContextPath() %>/admin/updateEbookImgAction.jsp" method="post" enctype="multipart/form-data">
		<!-- multipart/form-data : 액션으로 기계어코드를 넘길때 사용 -->
        <!-- application/x-www-form-urlencoded : 액션으로 문자열 넘길때 사용 -->

		<div class="container p-3 my-3 border">
			<div class="jumbotron">
			  <h1>관리자 페이지 - ebook 이미지 수정</h1>
			</div>
			
			
			<table class="table table-borderless table-hover text-center">
				<thead>
					<tr class="border-bottom font-weight-bold">
						<th>ebookNo</th>
						<th>categoryName</th>
						<th>ebookTitle</th>
						<th>ebookState</th>
						<th>updateDate</th>
						<th>createDate</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><input type="hidden" class="text-center" name="ebookNo" value="<%=ebook.ebookNo %>"><%=ebook.ebookNo %></td>
						<td><%=ebook.getCategoryName() %></td>
						<td><%=ebook.getEbookTitle() %></td>
						<td>
							<%
								if(ebook.getEbookState().equals("판매중")) {
							%>	
									<span>판매중</span>	
							<%
								} else if(ebook.getEbookState().equals("품절")) {
							%>	
									<span>품절</span>		
							<%
								} else if(ebook.getEbookState().equals("절판")) {
							%>	
									<span>절판</span>	
							<%
								} else if(ebook.getEbookState().equals("구편절판")) {
							%>
									<span>구편절판</span>	
							<%
								}
							%>		
						</td>
						<td><%=ebook.getUpdateDate() %></td>
						<td><%=ebook.getCreateDate() %></td>
					</tr>
				</tbody>
			</table>
		
			<table class="table table-borderless table-hover text-center">
				<tr class="border-bottom font-weight-bold">
					<th style="vertical-align: middle;">ebookImg</th>
					<td><input type="file" class="text-center" name="ebookImg" value="<%=ebook.getEbookImg() %>"></td>
				</tr>
			</table>
		</div>
		
		
		<div class="text-center">
			<button type="submit" class="btn btn-outline-dark">수정</button>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selectEbookOne.jsp?ebookNo=<%=ebook.getEbookNo() %>">취소</a>
		</div>
	</form>
</div>
</body>
</html>