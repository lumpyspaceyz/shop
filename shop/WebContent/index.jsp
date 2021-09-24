<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.ArrayList" %>
<%
	Member loginMember = new Member();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
div {
	overflow: hidden;
}
a, a:hover {
	text-decoration: none;
	color: #000;
}
a:hover {
	font-weight: bold;
}
</style>
</head>
<body>
<div class="container">
	<!-- start : submenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>메인 페이지</h1>
		</div>
		
		<%
			if(session.getAttribute("loginMember") == null) {
		%>
				<!-- 로그인 전  -->
				<table class="table table-hover text-center">
					<tr>
						<td>
							<a href="<%=request.getContextPath() %>/loginForm.jsp">로그인</a>
						</td>
					</tr>
					
					<tr>
						<td>
							<a href="<%=request.getContextPath() %>/insertMemberForm.jsp">회원가입</a>
						</td><!-- insertMemberAction.jsp -->
					</tr>
				</table>
		<%		
			} else {
				loginMember = (Member)session.getAttribute("loginMember");
				System.out.println(loginMember.getMemberLevel() + " <-- memberLevel");
		%>
				<!-- 로그인 후 -->
				<table class="table table-hover text-center">
					<tr>
						<td>
							<%=loginMember.getMemberName()%>님 반갑습니다.
						</td>
					</tr>
					
					<tr>
						<td>
							<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
						</td>
					</tr>
					
					<tr>
						<td>
							<a href="<%=request.getContextPath() %>/selectMemberOne.jsp?memberNo=<%=loginMember.getMemberNo() %>">회원정보</a>
						</td>
					</tr>
					
					<tr>
						<td>
							<a href="<%=request.getContextPath() %>/deleteMemberForm.jsp">회원탈퇴</a>
						</td>
					</tr>
					
					<!-- 관리자 페이지로 가는 링크 -->
					<%
						if(loginMember.getMemberLevel() > 0) {
					%>
					<tr>
						<td>
							<a href="<%=request.getContextPath() %>/admin/adminIndex.jsp">관리자 페이지</a>
						</td>
					</tr>
				</table>
					<%
							}
					%>
		<%	
			}
		%>
		
		
		<!-- 상품 목록 -->
		<%
		// paging
		int currentPage = 1;
		if(request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		final int ROW_PER_PAGE = 20; // 한 번 설정하면 변하지 않는다 -> 상수
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
		
		// dao
		CategoryDao categoryDao = new CategoryDao();
		EbookDao ebookDao = new EbookDao();
		
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
		
		<table class="table table-borderless text-center">
			<tr>
				<%
					int tr = 0;
					for(Ebook e : ebookList) {
				%>
							<td>
				<%
								// 회원or관리자일 selectEbookOne.jsp 분기
								if(loginMember.getMemberLevel() > 0) {
									%>
										<a href="<%=request.getContextPath() %>/admin/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
									<%
								} else if(loginMember.getMemberLevel() == 0) {
									%>
										<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
									<%
								}
				%>
									<div><img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>" width="180" height="180"></div>
									<div><%=e.getEbookTitle() %></div>
									<div>₩ <%=e.getEbookPrice() %></div>
								</a>
							</td>
				<%
						tr+=1; // for문이 한 바퀴 돌 때마다 tr은 1씩 증가
						if(tr%5 == 0) {
				%>
							<!-- 줄바꿈 : table이니까 tr닫고 다시 열어주기 -->
							</tr><tr>
				<%			
						}
					}
				%>
			</tr>
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
			<a href="<%=request.getContextPath() %>/index.jsp?currentPage=1" class="btn btn-outline-dark">≪</a>
			<a href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark">＜</a>
			<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
	<%		
			}
	
			for(int i=first; i<first+ROW_PER_PAGE; i++) {
				if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
					break;
				} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
	%>	
					<a class="btn btn-dark" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=i %>&first=<%=first%>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>"><%=i %></a>
	<%
				} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
	%>
					<a href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=i %>&first=<%=first%>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark"><%=i %></a>
	<%
				}
			}
			
			if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
	%>
			<a href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark">＞</a>
			<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
			
			<a href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=lastPage %>&categoryName=<%=categoryName %>&searchEbookTitle=<%=searchEbookTitle %>" class="btn btn-outline-dark">≫</a>
	<%
			}
	%>
	</div>
	<!-- end : 페이징 -->
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
</div>
</body>
</html>
