<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%> <!-- 파일이름 중복 피할 수 있도록 -->
<%
	//encoding
	request.setCharacterEncoding("utf-8");

	//방어코드 : 관리자 세션 관리
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) { // 순서 중요. 둘 중 앞부터 연산. 디버깅 코드를 남기려면 else if문으로 따로!
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		return;
	}

	// multipart/form-data로 넘겼기 때문에 request.getParameter("ebookNo"); 형태 사용 불가!
	
	MultipartRequest mr = new MultipartRequest(request, "/var/lib/tomcat9/webapps/shop1202/image/", 1024*1024*1024, "utf-8", new DefaultFileRenamePolicy()); // (request대체, 파일 위치(역슬래시 2개!), 1GB, encoding, 파일 이름 중복x) 
	
	int ebookNo = Integer.parseInt(mr.getParameter("ebookNo")); // ebookNo->request로 전달
	String ebookImg = mr.getFilesystemName("ebookImg");
	
	Ebook ebook = new Ebook();
	ebook.setEbookNo(ebookNo);
	ebook.setEbookImg(ebookImg);
	
	// dao
	EbookDao ebookDao = new EbookDao();
	ebookDao.updateEbookImg(ebook); // [전자책 관리] ebook 이미지 수정
	
	File afterImg = mr.getFile("ebookImg"); // 바꾼 이미지
	// debug
	System.out.println("afterImg --> " + afterImg);
	
	response.sendRedirect(request.getContextPath() + "/admin/selectEbookOne.jsp?ebookNo=" + ebookNo);
%>