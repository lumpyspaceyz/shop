<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!-- 방어코드 -->
<%
	// 방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	// encoding
	request.setCharacterEncoding("utf-8");
	
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
	System.out.println("paging debug" + currentPage + "<-- currentPage");
	System.out.println("paging debug" + nowPage + "<-- nowPage");
	System.out.println("paging debug" + beginRow + "<-- beginRow");
	System.out.println("paging debug" + first + "<-- first");

	// dao
	MemberDao memberDao = new MemberDao();
	ArrayList<Member> memberList = memberDao.selectMemberListAllByPage(beginRow, ROW_PER_PAGE);
	
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
	
	<div class="jumbotron">
	  <h1>관리자 페이지 - 회원목록</h1>
	</div>
	
	<table class="table table-striped table-hover text-center">
			<thead>
				<tr class="font-weight-bold">
					<th>memberNo</th>
					<th>memberLevel</th>
					<th>memberName</th>
					<th>memberAge</th>
					<th>memberGender</th>
					<th>updateDate</th>
					<th>createDate</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
			<%
			for(Member member : memberList) {
			%>
				<tr>
					<td><%=member.getMemberNo() %></td>
					<td><%=member.getMemberLevel() %>
						<%
							if(member.getMemberLevel() == 0) {
						%>	
								<span>일반회원</span>	
						<%
							} else if(member.getMemberLevel() == 1) {
						%>	
								<span>관리자</span>	
						<%
							}
						%>
					</td>
					<td><%=member.getMemberName() %></td>
					<td><%=member.getMemberAge() %></td>
					<td><%=member.getMemberGender() %></td>
					<td><%=member.getUpdateDate() %></td>
					<td><%=member.getCreateDate() %></td>
				</tr>
			<%
			}
			%>
			</tbody>
	</table>
	
	<!-- 페이징 -->
	<div class="text-center">
<%
		int totalCount = memberDao.selectTotalCount();
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
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=1" class="btn btn-outline-dark">처음으로</a>
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>" class="btn btn-outline-dark">이전</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
<%		
		}

		for(int i=first; i<first+ROW_PER_PAGE; i++) {
			if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
				break;
			} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
%>	
				<a class="btn btn-dark" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=i %>&first=<%=first%>"><%=i %></a>
<%
			} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
%>
				<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=i %>&first=<%=first%>" class="btn btn-outline-dark"><%=i %></a>
<%
			}
		}
		
		if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
%>
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>" class="btn btn-outline-dark">다음</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
		
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=lastPage %>" class="btn btn-outline-dark">끝으로</a>
		</td>
<%
		}
%>
</div>
</body>
</html>