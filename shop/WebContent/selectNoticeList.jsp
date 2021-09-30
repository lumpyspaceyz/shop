<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	// 방어코드 : 접속회원 세션 관리 (회원/비회원)
	Member loginMember = (Member)session.getAttribute("loginMember");
	
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
	
	// dao
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> noticeList = null;
	noticeList = noticeDao.selectNoticeList();
	int totalCount = 0;
	totalCount = noticeDao.selectTotalCount();
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
	<!-- start : 메인 메뉴 include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : 메인 메뉴 include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>회원/비회원 페이지 - 공지게시판</h1>
		</div>
		
		<table class="table table-striped table-hover text-center">
				<thead>
					<tr class="font-weight-bold">
						<th>noticeNo</th>
						<th>noticeTitle</th>
						<th>noticeContent</th>
						<th>memberNo</th>
						<th>createDate</th>
						<th>updateDate</th>
					</tr>
				</thead>
				<tbody>
				<%
				for(Notice notice : noticeList) {
				%>
					<tr>
						<td><%=notice.getNoticeNo() %></td>
						<td><a href="<%=request.getContextPath() %>/selectNoticeOne.jsp?noticeNo=<%=notice.getNoticeNo() %>"><%=notice.getNoticeTitle() %></a></td>
						<td><%=notice.getNoticeContent() %></td>
						<td><%=notice.getMemberNo() %>
							<%
								if(notice.getMemberNo() == 1) {
							%>	
									<br><span>관리자</span>	
							<%
								}
							%>
						</td>
						<td><%=notice.getCreateDate() %></td>
						<td><%=notice.getUpdateDate() %></td>
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
		<a href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=1" class="btn btn-outline-dark">≪</a>
		<a href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>" class="btn btn-outline-dark">＜</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
<%		
		}

		for(int i=first; i<first+ROW_PER_PAGE; i++) {
			if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
				break;
			} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
%>	
				<a class="btn btn-dark" href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=i %>&first=<%=first%>"><%=i %></a>
<%
			} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
%>
				<a href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=i %>&first=<%=first%>" class="btn btn-outline-dark"><%=i %></a>
<%
			}
		}
		
		if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
%>
		<a href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>" class="btn btn-outline-dark">＞</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
		
		<a href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=lastPage %>" class="btn btn-outline-dark">≫</a>
<%
		}
%>
	</div>
	<!-- end : 페이징 -->
	
	<div class="container pt-3"></div>

	
	<div class="container pt-3"></div>
</div>
</body>
</html>