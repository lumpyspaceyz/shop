package dao;

import java.sql.*;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class OrderDao {
	
	// [관리자] 전체 주문 조회
	public ArrayList<OrderEbookMember> selectOrderList(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		ArrayList<OrderEbookMember> list = new ArrayList<>();
		
		// debug
		System.out.println(beginRow + " <-- OrderDao.selectOrderList param beginRow");
		System.out.println(ROW_PER_PAGE + " <-- OrderDao.selectOrderList param ROW_PER_PAGE");
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT o.order_no orderNo, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_price orderPrice, o.create_date createDate FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no ORDER BY o.create_date DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// 조인해서 추출한 값 각각 Order o, Ebook e, Member m에 저장하고
			// o, e, m을 OrderEbookMember oem에 저장해서 사용
			OrderEbookMember oem = new OrderEbookMember();
			
			Order o = new Order();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setCreateDate(rs.getString("createDate"));
			oem.setOrder(o);
			
			Ebook e = new Ebook();
			e.setEbookNo(rs.getInt("ebookNo"));
			e.setEbookTitle(rs.getString("ebookTitle"));
			oem.setEbook(e);
			
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			oem.setMember(m);
			
			list.add(oem);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return list;
	}
	
	// [주문 관리] 전체 주문 조회 - paging totalCount
	public int selectTotalCount() throws ClassNotFoundException, SQLException {
		int totalCount = 0;

		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM orders";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- OrderDao.selectTotalCount stmt");
  		System.out.println(rs + " <-- OrderDao.selectTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [회원] 나의 주문 조회
	public ArrayList<OrderEbookMember> selectOrderListByMember(int memberNo, int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		ArrayList<OrderEbookMember> list = new ArrayList<>();

		// debug
		System.out.println(memberNo + " <-- OrderDao.selectOrderListByMember param memberNo");
		System.out.println(beginRow + " <-- OrderDao.selectOrderListByMember param beginRow");
		System.out.println(ROW_PER_PAGE + " <-- OrderDao.selectOrderListByMember param ROW_PER_PAGE");
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT o.order_no orderNo, e.ebook_no ebookNo, e.ebook_title ebookTitle, e.ebook_img ebookImg, m.member_no memberNo, m.member_id memberId, o.order_price orderPrice, o.create_date createDate FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no WHERE m.member_no=? ORDER BY o.create_date DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, ROW_PER_PAGE);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// 조인해서 추출한 값 각각 Order o, Ebook e, Member m에 저장하고
			// o, e, m을 OrderEbookMember oem에 저장해서 사용
			OrderEbookMember oem = new OrderEbookMember();
			
			Order o = new Order();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setCreateDate(rs.getString("createDate"));
			oem.setOrder(o);
			
			Ebook e = new Ebook();
			e.setEbookNo(rs.getInt("ebookNo"));
			e.setEbookTitle(rs.getString("ebookTitle"));
			e.setEbookImg(rs.getString("ebookImg"));
			oem.setEbook(e);
			
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			oem.setMember(m);
			
			list.add(oem);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return list;
	}
	
	// [회원] 주문 목록 출력 - paging totalCount
	public int selectTotalCount(int memberNo) throws ClassNotFoundException, SQLException {
		int totalCount = 0;

		// debug
		System.out.println(memberNo + " <-- OrderDao.selectTotalCount param memberNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM orders WHERE member_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, memberNo);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- OrderDao.selectTotalCount stmt");
  		System.out.println(rs + " <-- OrderDao.selectTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [회원] 나의 주문 상세조회
	public Order selectOrderOneByMember(int memberNo, int orderNo) throws ClassNotFoundException, SQLException {
		Order order = null;
		
		// debug
		System.out.println(memberNo + " <-- OrderDao.selectOrderOneByMember memberNo");
		System.out.println(orderNo + " <-- OrderDao.selectOrderOneByMember orderNo");
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT order_no orderNo, ebook_no ebookNo, order_price orderPrice, update_date updateDate FROM orders WHERE member_no=? AND order_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		stmt.setInt(2, orderNo);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			order = new Order();
			order.setOrderNo(orderNo);
			order.setEbookNo(rs.getInt("ebookNo"));
			order.setOrderPrice(rs.getInt("orderPrice"));
			order.setUpdateDate(rs.getString("updateDate"));
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return order;
	}
	
	// [관리자] 주문 상세조회
	public Order selectOrderOneByAdmin(int orderNo) throws ClassNotFoundException, SQLException {
		Order order = null;
		
		// debug
		System.out.println(orderNo + " <-- OrderDao.selectOrderOneByAdmin orderNo");
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT order_no orderNo, ebook_no ebookNo, member_no memberNo, order_price orderPrice, update_date updateDate FROM orders WHERE order_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			order = new Order();
			order.setOrderNo(orderNo);
			order.setEbookNo(rs.getInt("ebookNo"));
			order.setMemberNo(rs.getInt("memberNo"));
			order.setOrderPrice(rs.getInt("orderPrice"));
			order.setUpdateDate(rs.getString("updateDate"));
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return order;
	}
	
	// [회원] 주문하기
	public void insertOrder(int ebookNo, int memberNo, int orderPrice) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(ebookNo +" <-- OrderDao.updateOrder param ebookNo");
		System.out.println(memberNo +" <-- OrderDao.updateOrder param memberNo");
		System.out.println(orderPrice +" <-- OrderDao.updateOrder param orderPrice");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "INSERT INTO orders (ebook_no, member_no, order_price, update_date, create_date) VALUES (?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		stmt.setInt(2, memberNo);
		stmt.setInt(3, orderPrice);
		stmt.executeUpdate();
		// debug
		System.out.println(stmt + "<-- OrderDao.updateOrder stmt");
		
		stmt.close();
 		conn.close();
	}
}
