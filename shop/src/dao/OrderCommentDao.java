package dao;

import java.util.*;
import java.sql.*;

import commons.DBUtil;
import vo.*;

public class OrderCommentDao {
	// [회원] 후기 작성
	public void insertOrderComment(OrderComment orderComment) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(orderComment.getOrderNo() +" <-- OrderCommentDao.insertOrderComment param orderNo");
		System.out.println(orderComment.getEbookNo() +" <-- OrderCommentDao.insertOrderComment param ebookNo");
		System.out.println(orderComment.getOrderScore() +" <-- OrderCommentDao.insertOrderComment param orderScore");
		System.out.println(orderComment.getOrderCommentContent() +" <-- OrderCommentDao.insertOrderComment param orderCommentContent");
		
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
