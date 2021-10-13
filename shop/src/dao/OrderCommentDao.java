package dao;

import java.util.*;
import java.sql.*;

import commons.DBUtil;
import vo.*;

public class OrderCommentDao {
	// [회원] 후기 작성
	public void insertOrderComment(OrderComment orderComment) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(orderComment +" <-- OrderCommentDao.insertOrderComment param");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "INSERT INTO order_comment (order_no, ebook_no, order_score, order_comment_content, update_date, create_date) VALUES (?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderComment.getOrderNo());
		stmt.setInt(2, orderComment.getEbookNo());
		stmt.setInt(3, orderComment.getOrderScore());
		stmt.setString(4, orderComment.getOrderCommentContent());
		int row = stmt.executeUpdate();
		// debug
		System.out.println(stmt + "<-- OrderCommentDao.insertOrderComment stmt");
		System.out.println(row + "<-- OrderCommentDao.insertOrderComment insert 결과 row");
		
 		stmt.close();
 		conn.close();
	}
	
	// [회원] 후기 조회
	public OrderComment selectOrderComment(int orderNo, int ebookNo) throws ClassNotFoundException, SQLException {
		OrderComment orderComment = null;
		
		// debug
		System.out.println(orderNo +" <-- OrderCommentDao.selectOrderComment param orderNo");
		System.out.println(ebookNo +" <-- OrderCommentDao.selectOrderComment param ebookNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "SELECT order_no orderNo, ebook_no ebookNo, order_score orderScore, order_comment_content orderCommentContent FROM order_comment WHERE order_no=? AND ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		stmt.setInt(2, ebookNo);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			orderComment = new OrderComment();
			orderComment.setOrderNo(rs.getInt("orderNo"));
			orderComment.setEbookNo(rs.getInt("ebookNo"));
			orderComment.setOrderScore(rs.getInt("orderScore"));
			orderComment.setOrderCommentContent(rs.getString("orderCommentContent"));
	    }
		// debug
		System.out.println(stmt + "<-- OrderCommentDao.selectOrderComment stmt");
		System.out.println(rs + "<-- OrderCommentDao.selectOrderComment rs");
		
		rs.close();
 		stmt.close();
 		conn.close();
 		
 		return orderComment;
	}
	
	// [회원] 후기 중복 체크
	public boolean checkComment(int orderNo, int ebookNo)throws SQLException, ClassNotFoundException {
		boolean result = false;
		
		// debug
		System.out.println(orderNo +" <-- OrderCommentDao.checkComment param orderNo");
		System.out.println(ebookNo +" <-- OrderCommentDao.checkComment param ebookNo");
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql ="SELECT order_no, ebook_no FROM order_comment WHERE order_no=? AND ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1,orderNo);
		stmt.setInt(2, ebookNo);
		ResultSet rs = stmt.executeQuery();
		// debug
		System.out.println(stmt + "<-- OrderCommentDao.selectOrderComment stmt");
		System.out.println(rs + "<-- OrderCommentDao.selectOrderComment rs");
		
		if(rs.next()) {
			result = true;
		}
		
		rs.close();
 		stmt.close();
 		conn.close();
		
 		return result;
	}
	
	// [회원+비회원] 별점 평균 구하기
	public double selectOrderScoreAvg(int ebookNo) throws ClassNotFoundException, SQLException {
		double avgScore = 0;
		
		// debug
		System.out.println(ebookNo +" <-- OrderCommentDao.selectOrderScoreAvg param ebookNo");
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql ="SELECT AVG(order_score) av FROM order_comment WHERE ebook_no=? ORDER BY ebook_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			avgScore = rs.getDouble("av");
		}
		// debug
		System.out.println(stmt + "<-- OrderCommentDao.selectOrderComment stmt");
		System.out.println(rs + "<-- OrderCommentDao.selectOrderComment rs");

		rs.close();
 		stmt.close();
 		conn.close();
		
		return avgScore;
	}
	
	// [회원+비회원] 상품별 후기목록
	public ArrayList<OrderComment> selectOrderCommentListByEbookNo(int beginRow, int ROW_PER_PAGE, int ebookNo) throws ClassNotFoundException, SQLException {
		ArrayList<OrderComment> orderCommentList = new ArrayList<>();
		
		// debug
		System.out.println(beginRow +" <-- OrderCommentDao.selectOrderCommentListByEbookNo param beginRow");
		System.out.println(ROW_PER_PAGE +" <-- OrderCommentDao.selectOrderCommentListByEbookNo param ROW_PER_PAGE");
		System.out.println(ebookNo +" <-- OrderCommentDao.selectOrderCommentListByEbookNo param ebookNo");
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql ="SELECT order_no orderNo, ebook_no ebookNo, order_score orderScore, order_comment_content orderCommentContent, update_date updateDate FROM order_comment WHERE ebook_no=? ORDER BY update_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		stmt.setInt(2, beginRow);
	    stmt.setInt(3, ROW_PER_PAGE);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			OrderComment orderComment = null;
			orderComment = new OrderComment();
			orderComment.setOrderNo(rs.getInt("orderNo"));
			orderComment.setEbookNo(rs.getInt("ebookNo"));
			orderComment.setOrderScore(rs.getInt("orderScore"));
			orderComment.setOrderCommentContent(rs.getString("orderCommentContent"));	
			orderComment.setUpdateDate(rs.getString("updateDate"));	
			orderCommentList.add(orderComment);
		}
		// debug
		System.out.println(stmt + "<-- OrderCommentDao.selectOrderCommentListByEbookNo stmt");
		System.out.println(rs + "<-- OrderCommentDao.selectOrderCommentListByEbookNo rs");

		rs.close();
 		stmt.close();
 		conn.close();
		
		return orderCommentList;
		
	}
	
	// [관리자] 전체 후기목록
	public ArrayList<OrderComment> selectOrderCommentListByAdmin(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		ArrayList<OrderComment> orderCommentList = new ArrayList<>();
		
		// debug
		System.out.println(beginRow +" <-- OrderCommentDao.selectOrderCommentListByAdmin param beginRow");
		System.out.println(ROW_PER_PAGE +" <-- OrderCommentDao.selectOrderCommentListByAdmin param ROW_PER_PAGE");
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql ="SELECT order_no orderNo, ebook_no ebookNo, order_score orderScore, order_comment_content orderCommentContent, update_date updateDate FROM order_comment  ORDER BY update_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
	    stmt.setInt(2, ROW_PER_PAGE);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			OrderComment orderComment = null;
			orderComment = new OrderComment();
			orderComment.setOrderNo(rs.getInt("orderNo"));
			orderComment.setEbookNo(rs.getInt("ebookNo"));
			orderComment.setOrderScore(rs.getInt("orderScore"));
			orderComment.setOrderCommentContent(rs.getString("orderCommentContent"));	
			orderComment.setUpdateDate(rs.getString("updateDate"));	
			orderCommentList.add(orderComment);
		}
		// debug
		System.out.println(stmt + "<-- OrderCommentDao.selectOrderCommentListByAdmin stmt");
		System.out.println(rs + "<-- OrderCommentDao.selectOrderCommentListByAdmin rs");

		rs.close();
 		stmt.close();
 		conn.close();
		
		return orderCommentList;
		
	}
	
	// [관리자] 전체 후기목록 - paging totalCount
	public int selectOrderCommentTotalCountByAdmin() throws ClassNotFoundException, SQLException {
		int totalCount = 0;
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM order_comment";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- OrderCommentDao.selectOrderCommentTotalCountByAdmin stmt");
  		System.out.println(rs + " <-- OrderCommentDao.selectOrderCommentTotalCountByAdmin rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	/*
	// [회원+비회원] 상품별 후기목록
		public ArrayList<OrderCommentMember> selectOrderCommentListByEbookNo(int beginRow, int ROW_PER_PAGE, int ebookNo) throws ClassNotFoundException, SQLException {
			ArrayList<OrderCommentMember> ocmList  = new ArrayList<OrderCommentMember>();
			
			// debug
			System.out.println(ebookNo +" <-- OrderCommentDao.selectOrderCommentListByEbookNo param ebookNo");
			
			DBUtil dbutil = new DBUtil();
			Connection conn = dbutil.getConnection();
			
			String sql ="SELECT oc.order_no orderNo, oc.ebook_no ebookNo, oc.order_score orderScore, oc.order_comment_content orderCommentContent, oc.update_date updateDate, m.member_id memberId, m.member_no memberNo FROM order_comment oc INNER JOIN member m ON oc.member_no = m.member_no  WHERE oc.ebook_no=? ORDER BY oc.update_date DESC LIMIT ?,?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setInt(1, ebookNo);
			stmt.setInt(2, beginRow);
		    stmt.setInt(3, ROW_PER_PAGE);
			ResultSet rs = stmt.executeQuery();
			
			while(rs.next()) {
				// 조인 쿼리문의 결과를 받을 OrderComment, Member 클래스의 집합체를 생성
				OrderCommentMember ocm = new OrderCommentMember();
				
				// 조회결과의 OrderComment와 관련된 결과를 OrderComment 클래스에 저장
				OrderComment oc = new OrderComment();
				oc.setOrderNo(rs.getInt("orderNo"));
				oc.setEbookNo(rs.getInt("ebookNo"));
				oc.setOrderScore(rs.getInt("orderScore"));
				oc.setOrderCommentContent(rs.getString("orderCommentContent"));	
				oc.setUpdateDate(rs.getString("updateDate"));
				// oc에 저장된 결과 ocm에 저장
				ocm.setOrderComment(oc);
				
				// 조회결과의 Member와 관련된 결과를 Member 클래스에 저장
				Member m = new Member();
				m.setMemberId(rs.getString("memberId"));
				m.setMemberNo(rs.getInt("memberNo"));
				// m에 저장된 결과 ocm에 저장
				ocm.setMember(m);
				
				// ocmList에 ocm(oc+m) 저장
				ocmList.add(ocm);
			}
			// debug
			System.out.println(stmt + "<-- OrderCommentDao.selectOrderCommentListByEbookNo stmt");
			System.out.println(rs + "<-- OrderCommentDao.selectOrderCommentListByEbookNo rs");

			rs.close();
	 		stmt.close();
	 		conn.close();
			
			return ocmList;
			
		}
	*/
	
	// [회원+비회원] 상품별 후기목록 - paging totalCount
	public int selectOrderCommentTotalCount(int ebookNo) throws ClassNotFoundException, SQLException {
		int totalCount = 0;

		// debug
		System.out.println(ebookNo +" <-- OrderCommentDao.selectOrderCommentTotalCount param ebookNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM order_comment WHERE ebook_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, ebookNo);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- OrderCommentDao.selectOrderCommentTotalCount stmt");
  		System.out.println(rs + " <-- OrderCommentDao.selectOrderCommentTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
}
