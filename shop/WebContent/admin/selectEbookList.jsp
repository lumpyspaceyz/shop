<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.ArrayList" %>
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// paging
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10; // 한 번 설정하면 변하지 않는다 -> 상수
	int beginRow = (currentPage-1) * ROW_PER_PAGE;
	int nowPage = (currentPage / ROW_PER_PAGE) + 1; // 현재 시작 페이징(=first)을 계산하기 위한 변수
	int first = (nowPage * ROW_PER_PAGE) - (ROW_PER_PAGE-1); // 현재 시작 페이징 번호
	if(request.getParameter("first") != null) {
		first = Integer.parseInt(request.getParameter("first"));
	}
	// paging debug
	System.out.println("paging debug " + currentPage + " <-- currentPage");
	System.out.println("paging debug " + nowPage + " <-- nowPage");
	System.out.println("paging debug " + beginRow + " <-- beginRow");
	System.out.println("paging debug " + first + " <-- first");
	
	// category별 조회
	String categoryName = "";
	if(request.getParameter("categoryName") != null) {
		categoryName = request.getParameter("categoryName");
	}
	// category debug
	System.out.println("categoryName debug " + categoryName + " <-- categoryName");
	
	// search
	String searchEbookTitle = "";
	if(request.getParameter("searchEbookTitle") != null) {
		searchEbookTitle = request.getParameter("searchEbookTitle");
	}
	// search debug
	System.out.println("search debug " + searchEbookTitle + " <-- searchEbookTitle");
	
	// dao
	CategoryDao categoryDao = new CategoryDao();
	EbookDao ebookDao = new EbookDao();
	
	// 카테고리 불러오기
	ArrayList<Category> categoryList = categoryDao.selectCategoryList();
	
	ArrayList<Ebook> ebookList = null;
	int totalCount = 0;
	if(categoryName.equals("") == true && searchEbookTitle.equals("") == true) {
		ebookList = ebookDao.selectEbookListAllByPage(beginRow, ROW_PER_PAGE);
		totalCount = ebookDao.selectTotalCount();
	} else if(categoryName.equals("") != true && searchEbookTitle.equals("") == true) {
		ebookList = ebookDao.selectEbookListAllByCategory(beginRow, ROW_PER_PAGE, categoryName);
		totalCount = ebookDao.selectTotalCountByCategoryName(categoryName);
	} else if(categoryName.equals("") == true && searchEbookTitle.equals("") != true) {
		ebookList = ebookDao.selectEbookListAllBySearchEbookTitle(beginRow, ROW_PER_PAGE, categoryName);
		totalCount = ebookDao.selectTotalCountBySearchMemberId(categoryName);
	} else if(categoryName.equals("") != true && searchEbookTitle.equals("") != true) {
		ebookList = ebookDao.selectEbookListAllByCategory(beginRow, ROW_PER_PAGE, categoryName);
		totalCount = ebookDao.selectTotalCountByCategoryName(categoryName);
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
	<!-- start : adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : adminMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - 전자책 관리</h1>
		</div>
		
		<form  action="<%=request.getContextPath() %>/admin/selectEbookList.jsp" method="post" class="form-group">
			<table style="margin: 0 auto;">
				<tr>
					<td width="300px" style="padding-right: 5px;">
						<select class="form-control" name="categoryName">
							<%
								for(Category category : categoryList) {
							%>
								<option value="<%=category.getCategoryName() %>"><%=category.getCategoryName() %></option>
							<%
								}
							%>
						</select>
					</td>
					<td>
						<button class="btn btn-outline-dark" type="submit">카테고리별 조회</button>
					</td>
				</tr>
			</table>
		</form>
		
		<!--  전자책 목록 출력 : 카테고리별 출력 -->
		<table class="table table-striped table-hover text-center">
				<thead>
					<tr class="font-weight-bold">
						<th>ebookNo</th>
						<th>categoryName</th>
						<th>ebookTitle</th>
						<th>ebookState</th>
						<th>회원등급수정</th>
						<th>비밀번호수정</th>
						<th>강제탈퇴</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(Ebook ebook : ebookList) {
					%>
							<tr>
								<td><%=ebook.getEbookNo() %></td>
								<td><%=ebook.getCategoryName() %></td>
								<td><a href="<%=request.getContextPath() %>/admin/selectEbookOne.jsp?ebookNo=<%=ebook.getEbookNo() %>"><%=ebook.getEbookTitle() %></a></td>
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
								<td>
									<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원의 비밀번호를 수정 -->
									<a href="<%=request.getContextPath() %>/admin/updateMemberLevelForm.jsp?memberNo=">등급수정</a>
								</td>
								<td>
									<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원의 비밀번호를 수정 -->
									<a href="<%=request.getContextPath() %>/admin/updateMemberPwForm.jsp?memberNo=">비밀번호수정</a>
								</td>
								<td>
									<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원을 강제 탈퇴 -->
									<a href="<%=request.getContextPath() %>/admin/deleteMemberForm.jsp?memberNo=">강제탈퇴</a>
								</td>
							</tr>
					<%
						}
					%>
				</tbody>
		</table>
	</div>
		
		<!-- start : 페이징 -->
	<div class="text-center">
<%
			// 마지막 페이지 정보
			int lastPage = totalCount / ROW_PER_PAGE;
			if(totalCount % ROW_PER_PAGE != 0) {
				lastPage++;	// lastPage+=1
			}
			
			// 디버깅
			System.out.println(totalCount + "<-- 전체 총 게시글 수");
			System.out.println(lastPage + "<-- 마지막 페이지");
			
			if(currentPage > ROW_PER_PAGE) {	// 현재 페이지 번호(currentPage)가 페이징 수(rowPerPage)보다 크면 rowPerPage씩 넘어갈 수 있는 이전 버튼 활성화
	%>
			<a href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=1" class="btn btn-outline-dark">≪</a>
			<a href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark">＜</a>
			<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
	<%		
			}
	
			for(int i=first; i<first+ROW_PER_PAGE; i++) {
				if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
					break;
				} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
	%>	
					<a class="btn btn-dark" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=i %>&first=<%=first%>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>"><%=i %></a>
	<%
				} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
	%>
					<a href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=i %>&first=<%=first%>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark"><%=i %></a>
	<%
				}
			}
			
			if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
	%>
			<a href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark">＞</a>
			<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
			
			<a href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=lastPage %>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark">≫</a>
	<%
			}
	%>
	</div>
	<!-- end : 페이징 -->
	
	<div class="container pt-3"></div>
	
	<!-- ebookTitle로 검색 -->
	<!-- ISSUE : 검색했을 때 searchEbookTitle도 함께 넘겨야한다. -->
	<div class="text-center">
		<form action="<%=request.getContextPath() %>/admin/selectEbookList.jsp" method="get">
			<input type="text" name="searchEbookTitle" placeholder="ebookTitle">
			<button type="submit"class="btn btn-outline-dark">search</button>
		</form>
	</div>
	
</div>
</body>
</html>