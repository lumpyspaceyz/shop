<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*"%>
<%
	//encoding
	request.setCharacterEncoding("utf-8");
	
	//방어코드 : 접속회원 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) { // 로그인한 회원 + 관리자 : Qna 조회 가능
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}
	
	//debug
	System.out.println("loginMemberNo --> " + loginMember.getMemberNo());

	// 방어코드
	if(request.getParameter("qnaNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}

	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// debug
	System.out.println("debug " + qnaNo + " <-- qnaNo");
	
	// dao
	QnaDao qnaDao = new QnaDao();
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	System.out.println("qnaMemberNo --> " + qna.getMemberNo());
	System.out.println("qnaSecret --> " + qna.getQnaSecret());
	
	/* updateQnaComment */
	int qnaCommentNo = Integer.parseInt(request.getParameter("qnaCommentNo"));
	
	// 방어코드
	if(request.getParameter("qnaCommentNo") == null) {
		response.sendRedirect(request.getContextPath() + "/selectQnaList.jsp?currentPage=1");
		return;
	}	
	
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
	<!-- start : mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : mainMenu include -->
	
	<div class="container p-3 my-3 border">
		<div class="jumbotron">
		  <h1>회원 페이지 - qna 상세보기</h1>
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
	<%
		if(loginMember.getMemberNo() == qna.getMemberNo()) {
	%>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/updateQnaForm.jsp?qnaNo=<%=qna.getQnaNo() %>">수정</a>
			<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/deleteQnaForm.jsp?qnaNo=<%=qna.getQnaNo() %>">삭제</a>
	<%
		}
	%>
		<a class="btn btn-outline-dark" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=1">목록</a>
	</div>
	
	<div class="container pt-3"></div>
		
	
	<div class="container p-3 my-3 border">
	
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
	<!-- Update qnaComment -->
	<form method="post" action="<%=request.getContextPath() %>/updateQnaCommentAction.jsp">
		<table class="table">
			<thead>
					<tr class="font-weight-bold">
						<td>번호</td>
						<td>memberNo</td>
						<td>commentContent</td>
						<td>commentDate</td>
						<td>update</td>
					</tr>
				</thead>
				<tbody>
			<%
				int no = 1 + commentBeginRow;
				for(QnaComment qnaComment : qnaCommentList) {
					if(qnaComment.getQnaCommentNo() == qnaCommentNo && qnaComment.getMemberNo() == loginMember.getMemberNo()) {
			%>
						<tr>
							<td><%=no%>
								<input type="hidden" name="qnaNo" value="<%=qnaComment.getQnaNo() %>">
								<input type="hidden" name="qnaCommentNo" value="<%=qnaComment.getQnaCommentNo() %>">
							</td>
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
							<td><textarea name="qnaCommentContent" class="form-control" rows="2"><%=qnaComment.getQnaCommentContent() %></textarea></td>
							<td><%=qnaComment.getUpdateDate()%></td>
							<td><button type="submit" class="btn btn-outline-light text-dark">수정</button></td>
						</tr>
		<%		
					} else {
		%>
						<tr>
							<td><%=no%></td>
							<td>
								<%
									if(qnaComment.getMemberNo() == 1) {
								%>	
										<span>관리자</span>	
								<%
									}
								%>
							</td>
							<td><%=qnaComment.getQnaCommentContent() %></td>
							<td><%=qnaComment.getUpdateDate()%></td>
							<td></td>
						</tr>
		<%
					}
					no++;
				}
		%>
			</tbody>
		</table>
	</form>
		
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
				<a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=1" class="btn btn-sm btn-outline-dark">≪</a>
				<a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=commentCurrentPage - COMMENT_ROW_PER_PAGE %>&commentFirst=<%=commentFirst - COMMENT_ROW_PER_PAGE %>" class="btn btn-sm btn-outline-dark">＜</a>
				<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 빼서 전달 -->
<%		
				}
	
				for(int i=commentFirst; i<commentFirst+COMMENT_ROW_PER_PAGE; i++) {
					if((commentLastPage+1) == i) {	// 마지막 페이지면 for문 빠져나가기
						break;
					} else if(commentCurrentPage == i) {	// 현재 선택한 페이지 -> btn-dark
%>	
						<a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=i%>&commentFirst=<%=commentFirst%>" class="btn btn-sm btn-dark"><%=i%></a>
					
<%
					} else {	// 현재 선택하지 않은 페이지 -> btn-outline-dark
%>
						<a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=i%>&commentFirst=<%=commentFirst%>" class="btn btn-sm btn-outline-dark"><%=i%></a>
<%
						
					}
				}
				
				// 현재 페이지가 마지막 페이지보다 작고 && 마지막 페이지가 페이징 수보다 클 때 다음,끝으로 버튼 활성화
				if(commentCurrentPage < commentLastPage && COMMENT_ROW_PER_PAGE < commentLastPage) { 
%>
				<a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=commentCurrentPage + COMMENT_ROW_PER_PAGE %>&commentFirst=<%=commentFirst + COMMENT_ROW_PER_PAGE %>" class="btn btn-sm btn-outline-dark">＞</a>
				<!-- 현재 페이지, 시작 페이징: 페이징 수 만큼 더해서 전달 -->
				
				<a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=qnaNo %>&commentCurrentPage=<%=commentLastPage%>" class="btn btn-sm btn-outline-dark">≫</a>
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