<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	// encoding
	request.setCharacterEncoding("utf-8");

	// 방어코드 : 관리자 세션 관리
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
	
	// search
	String searchMemberId = "";
	if(request.getParameter("searchMemberId") != null) {
		searchMemberId = request.getParameter("searchMemberId");
	}
	// search debug
	System.out.println("search debug " + searchMemberId + " <-- searchMemberId");
	
	// dao
	MemberDao memberDao = new MemberDao();
	
	ArrayList<Member> memberList = null;
	int totalCount = 0;
	if(searchMemberId.equals("") == true) {
		memberList = memberDao.selectMemberListAllByPage(beginRow, ROW_PER_PAGE);
		totalCount = memberDao.selectTotalCount();
	} else {
		memberList = memberDao.selectMemberListAllBySearchMemberId(beginRow, ROW_PER_PAGE, searchMemberId);
		totalCount = memberDao.selectTotalCountBySearchMemberId(searchMemberId);
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
	<!-- start : 관리자 메뉴 include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : submenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - 회원관리</h1>
		</div>
		
		<!-- 멤버목록 출력 -->
		<table class="table table-striped table-hover text-center">
				<thead>
					<tr class="font-weight-bold">
						<th>memberNo</th>
						<th>memberId</th>
						<th>memberLevel</th>
						<th>memberName</th>
						<th>memberAge</th>
						<th>memberGender</th>
						<th>updateDate</th>
						<th>createDate</th>
						<th>회원등급수정</th>
						<th>비밀번호수정</th>
						<th>강제탈퇴</th>
					</tr>
				</thead>
				<tbody>
				<%
				for(Member member : memberList) {
				%>
					<tr>
						<td><%=member.getMemberNo() %></td>
						<td><a href="<%=request.getContextPath() %>/admin/selectMemberOne.jsp?memberNo=<%=member.getMemberNo() %>"><%=member.getMemberId() %></a></td>
						<td><%=member.getMemberLevel() %>
							<%
								if(member.getMemberLevel() == 0) {
							%>	
									<br><span>일반회원</span>	
							<%
								} else if(member.getMemberLevel() == 1) {
							%>	
									<br><span>관리자</span>	
							<%
								}
							%>
						</td>
						<td><%=member.getMemberName() %></td>
						<td><%=member.getMemberAge() %></td>
						<td><%=member.getMemberGender() %></td>
						<td><%=member.getUpdateDate() %></td>
						<td><%=member.getCreateDate() %></td>
						<td>
							<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원의 비밀번호를 수정 -->
							<a href="<%=request.getContextPath() %>/admin/updateMemberLevelForm.jsp?memberNo=<%=member.getMemberNo() %>">등급수정</a>
						</td>
						<td>
							<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원의 비밀번호를 수정 -->
							<a href="<%=request.getContextPath() %>/admin/updateMemberPwForm.jsp?memberNo=<%=member.getMemberNo() %>">비밀번호수정</a>
						</td>
						<td>
							<!-- (현재 로그인된 관리자의 비밀번호를 확인 후) 특정회원을 강제 탈퇴 -->
							<a href="<%=request.getContextPath() %>/admin/deleteMemberForm.jsp?memberNo=<%=member.getMemberNo() %>">강제탈퇴</a>
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
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=1" class="btn btn-outline-dark">≪</a>
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=currentPage - ROW_PER_PAGE %>&first=<%=first - ROW_PER_PAGE %>&searchMemberId=<%=searchMemberId %>" class="btn btn-outline-dark">＜</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
<%		
		}

		for(int i=first; i<first+ROW_PER_PAGE; i++) {
			if((lastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
				break;
			} else if(currentPage == i) {	// 현재 선택한 페이지 -> btn-dark
%>	
				<a class="btn btn-dark" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=i %>&first=<%=first%>&searchMemberId=<%=searchMemberId %>"><%=i %></a>
<%
			} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
%>
				<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=i %>&first=<%=first%>" class="btn btn-outline-dark"><%=i %></a>
<%
			}
		}
		
		if(currentPage < lastPage && ROW_PER_PAGE < lastPage) {
%>
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=currentPage + ROW_PER_PAGE %>&first=<%=first + ROW_PER_PAGE %>&searchMemberId=<%=searchMemberId %>" class="btn btn-outline-dark">＞</a>
		<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
		
		<a href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=lastPage %>&searchMemberId=<%=searchMemberId %>" class="btn btn-outline-dark">≫</a>
<%
		}
%>
	</div>
	<!-- end : 페이징 -->
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	
	<!-- memberId로 검색 -->
	<!-- ISSUE : 검색했을 때 searchMemberId도 함께 넘겨야한다. -->
	<div class="text-center">
		<form action="<%=request.getContextPath() %>/admin/selectMemberList.jsp" method="get">
			<input type="text" name="searchMemberId" placeholder="memberId">
			<button type="submit"class="btn btn-outline-dark">search</button>
		</form>
	</div>
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
</div>
</body>
</html>