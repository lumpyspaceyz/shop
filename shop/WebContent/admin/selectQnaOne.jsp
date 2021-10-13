<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	//encoding
	request.setCharacterEncoding("utf-8");
	
	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	
	// qnaNo 유효성 검사
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/admin/selectQnaList.jsp?currentPage=1");
		return;
	}
	
	// dao
	QnaDao qnaDao = new QnaDao();
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	System.out.println("qnaMemberNo --> " + qna.getMemberNo());
	System.out.println("qnaSecret --> " + qna.getQnaSecret());
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
	<!-- start : 관리자 메뉴 include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : 관리자 메뉴 include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>관리자 페이지 - qna게시판 관리</h1>
		</div>
	
		<table class="table table-borderless text-center">
			<thead>
				<tr class="font-weight-bold">
					<th>qnaNo</th>
					<th>qnaCategory</th>
					<th>qnaTitle</th>
					<th>memberNo</th>
				</tr>
				<tr class="border-bottom">
					<td><%=qna.getQnaNo() %></td>
					<td><%=qna.getQnaCategory() %></td>
					<td width="35%"><%=qna.getQnaTitle() %></td>
					<td><%=qna.getMemberNo() %></td>
				</tr>
			</thead>
			<tbody>
				<tr class="font-weight-bold text-left">
					<th colspan="4" style="padding-left: 60px; padding-top: 30px;">qnaContent</th>
				</tr>
				<tr class="border-bottom">
					<td colspan="4">
						<div class="container p-3 my-3 border" style="height: 250px; line-height: 200px;">
							<%=qna.getQnaContent() %>
						</div>
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<!-- <th colspan="2" style="padding-top: 30px;" width="45%" class="text-right">qnaSecret</th> -->
					<td colspan="2" style="padding-top: 30px;" class="text-left">
						<input type="hidden" id="qnaSecret" value="<%=qna.getQnaSecret() %>">
						<input type="hidden" id="loginMemberNo" value="<%=loginMember.getMemberNo() %>">
						<input type="hidden" id="qnaMemberNo" value="<%=qna.getMemberNo() %>">
					</td>
				</tr>
			</tfoot>	
		</table>
	</div>
	
	<div class="text-center">
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/deleteQnaForm.jsp?qnaNo=<%=qna.getQnaNo() %>">삭제</a>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/admin/selectQnaList.jsp?currentPage=1">목록</a>
	</div>
	
	<div class="container pt-3"></div>
		
	
	<div class="container p-3 my-3 border">
	<%
		if(loginMember.getMemberLevel() > 0 || loginMember.getMemberNo() == qna.getMemberNo()) {
	%>
		<!-- 답글 입력 partial -->
		<form action="<%=request.getContextPath() %>/insertQnaCommentAction.jsp" method="post">
			<input type="hidden" name="qnaNo" value="<%=qnaNo%>">
			<div class="form-group">
				<br>
				<label for="comment">Comment : </label>
				<textarea name="qnaCommentContent" class="form-control" rows="5"></textarea>
			</div>
			<div class="text-right">
				<button class="btn btn-sm btn-outline-dark" type="submit">답글입력</button>
			</div>
		</form>
	<%
		}
	%>

	<div class="container pt-3"></div>
	
	<!--  답글 목록 -->
	<label>QnaComment list : </label>
	<div class="text-center">
<%
	// 답글 페이징
	int commentCurrentPage = 1; // 현재 페이지
	if(request.getParameter("commentCurrentPage") != null) {
		commentCurrentPage = Integer.parseInt(request.getParameter("commentCurrentPage"));
	}

	int COMMENT_ROW_PER_PAGE = 3; // 페이징 수 설정 (상수)
	
	int nowPage = (commentCurrentPage / COMMENT_ROW_PER_PAGE) + 1; // 현재 시작 페이징(=commentFirst)을 계산하기 위한 변수
	
	int commentBeginRow = (commentCurrentPage-1) * COMMENT_ROW_PER_PAGE;
	
	int commentFirst = (nowPage * COMMENT_ROW_PER_PAGE) - (COMMENT_ROW_PER_PAGE-1); // 현재 시작 페이징 번호
		if(request.getParameter("commentFirst") != null) {
			commentFirst = Integer.parseInt(request.getParameter("commentFirst"));
		}
	
	// comment paging debug
	System.out.println("paging debug " + commentCurrentPage + " <-- currentPage");
	System.out.println("paging debug " + nowPage + " <-- nowPage");
	System.out.println("paging debug " + commentBeginRow + " <-- beginRow");
	System.out.println("paging debug " + commentFirst + " <-- first");
	
	ArrayList<QnaComment> qnaCommentList = qnaCommentDao.selectQnaCommentListByPage(qnaNo, commentBeginRow, COMMENT_ROW_PER_PAGE); // 댓글 목록 불러오기
	
%>
		<table class="table">
			<thead>
				<tr class="font-weight-bold">
					<td>번호</td>
					<td>memberNo</td>
					<td>commentContent</td>
					<td>commentDate</td>
					<td>update</td>
					<td>delete</td>
				</tr>
			</thead>
			<tbody>
<%
				int no = 1 + commentBeginRow;
				for(QnaComment qnaComment : qnaCommentList) {
%>
					<tr>
						<td><%=no%></td>
						<td>
							<%
								if(qnaComment.getMemberNo() == 1) {
							%>	
									<span>관리자</span>	
							<%
								} else if(qnaComment.getMemberNo() == qna.getMemberNo()) {
							%>
									<span>작성자</span>
							<%
								}
							%>
						</td>
						<td><%=qnaComment.getQnaCommentContent() %></td>
						<td><%=qnaComment.getUpdateDate()%></td>
					<%
						if(loginMember.getMemberNo() == qnaComment.getMemberNo()) {
					%>
						<td><a href="<%=request.getContextPath() %>/admin/updateQnaCommentForm.jsp?qnaNo=<%=qna.getQnaNo() %>&qnaCommentNo=<%=qnaComment.getQnaCommentNo() %>" class="btn btn-outline-light text-dark">수정</a></td>
						
					<%
						} else {
					%>
						<td></td>
					<%
						}
					%>
						<td><a href="<%=request.getContextPath() %>/admin/deleteQnaCommentAction.jsp?qnaNo=<%=qna.getQnaNo() %>&qnaCommentNo=<%=qnaComment.getQnaCommentNo() %>" class="btn btn-outline-light text-dark">삭제</a></td>
					</tr>
<%		
					no++;
				}
%>
			</tbody>
		</table>
		
			<!-- 답글 페이징 -->
			<div class="text-center">
	<%
				int commentTotalCount = qnaCommentDao.selectCommentTotalCount(qnaNo); // 댓글 총 개수
				
				// 마지막 페이지 정보
				int commentLastPage = commentTotalCount / COMMENT_ROW_PER_PAGE;
				if(commentTotalCount % COMMENT_ROW_PER_PAGE != 0) {
					commentLastPage++;	// lastPage+=1
				}
				
					// 디버깅
					System.out.println(commentTotalCount + "<-- 총 댓글 수");
					System.out.println(commentLastPage + "<-- 마지막 페이지");
				
				if(commentCurrentPage > COMMENT_ROW_PER_PAGE) {	// 현재 페이지 번호(commentCurrentPage)가 페이징 수(commentRowPerPage)보다 크면 commentRowPerPage씩 넘어갈 수 있는 이전 버튼 활성화
%>
				<a href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=1" class="btn btn-sm btn-outline-dark">≪</a>
				<a href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=commentCurrentPage - COMMENT_ROW_PER_PAGE %>&commentFirst=<%=commentFirst - COMMENT_ROW_PER_PAGE %>" class="btn btn-sm btn-outline-dark">＜</a>
				<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
<%		
				}
	
				for(int i=commentFirst; i<commentFirst+COMMENT_ROW_PER_PAGE; i++) {
					if((commentLastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
						break;
					} else if(commentCurrentPage == i) {	// 현재 선택한 페이지 -> btn-dark
%>	
						<a href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=i%>&commentFirst=<%=commentFirst%>" class="btn btn-sm btn-dark"><%=i%></a>
					
<%
					} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
%>
						<a href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=i%>&commentFirst=<%=commentFirst%>" class="btn btn-sm btn-outline-dark"><%=i%></a>
<%
						
					}
				}
				
				// 현재 페이지가 마지막 페이지보다 작고 && 마지막 페이지가 페이징 수보다 클 때 다음,끝으로 버튼 활성화
				if(commentCurrentPage < commentLastPage && COMMENT_ROW_PER_PAGE < commentLastPage) { 
%>
				<a href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=commentCurrentPage + COMMENT_ROW_PER_PAGE %>&commentFirst=<%=commentFirst + COMMENT_ROW_PER_PAGE %>" class="btn btn-sm btn-outline-dark">＞</a>
				<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
				
				<a href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=commentLastPage%>" class="btn btn-sm btn-outline-dark">≫</a>
<%
				}
	%>
			</div>
	</div>
	</div>
	
	<div class="container pt-3"></div>
	<div class="container pt-3"></div>
</div>
</body>
</html>