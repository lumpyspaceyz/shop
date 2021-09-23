package dao;

import java.util.*;
import java.sql.*;

import commons.DBUtil;
import vo.Ebook;
import vo.Member;

public class EbookDao {
	// [전자책 관리] - ebook 전체목록 출력
	public ArrayList<Ebook> selectEbookListAllByPage(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		ArrayList<Ebook> ebookList = new ArrayList<>();
		
		// debug
		System.out.println(beginRow +" <-- EbookDao.selectEbookList param beginRow");
		System.out.println(ROW_PER_PAGE +" <-- EbookDao.selectEbookList param ROW_PER_PAGE");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook ORDER BY create_date DESC LIMIT ?, ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, beginRow);
	    stmt.setInt(2, ROW_PER_PAGE);
	    
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next()) {
	    	Ebook ebook = new Ebook();
	    	ebook.setEbookNo(rs.getInt("ebookNo"));
	    	ebook.setCategoryName(rs.getString("categoryName"));
	    	ebook.setEbookTitle(rs.getString("ebookTitle"));
	    	ebook.setEbookState(rs.getString("ebookState"));
	    	ebookList.add(ebook);				
	    }
	    
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectEbookList stmt");
  		System.out.println(rs + " <-- EbookDao.selectEbookList rs");
  		
  		rs.close();
  		stmt.close();
  		conn.close();
	  		
		return ebookList;
		
	}

	// [전자책 관리] ebook 전체목록 출력 - paging totalCount
		public int selectTotalCount() throws ClassNotFoundException, SQLException {
			int totalCount = 0;

			DBUtil dbUtil = new DBUtil();
		    Connection conn = dbUtil.getConnection();
		    
		    String sql = "SELECT COUNT(*) FROM ebook";
		    PreparedStatement stmt = conn.prepareStatement(sql);
		    ResultSet rs = stmt.executeQuery();
		    if(rs.next()) {
				totalCount = rs.getInt("COUNT(*)");
			}
		    // debug
	  		System.out.println(stmt + " <-- EbookDao.selectTotalCount stmt");
	  		System.out.println(rs + " <-- EbookDao.selectTotalCount rs");

		    rs.close();
			stmt.close();
			conn.close();
			
			return totalCount;
		}
		
	// [전자책 관리] - ebook 카테고리별 출력
	public ArrayList<Ebook> selectEbookListAllByCategory(int beginRow, int ROW_PER_PAGE, String categoryName) throws ClassNotFoundException, SQLException {
		ArrayList<Ebook> ebookList = new ArrayList<>();

		// debug
		System.out.println(beginRow +" <-- EbookDao.selectEbookListByCategory param beginRow");
		System.out.println(ROW_PER_PAGE +" <-- EbookDao.selectEbookListByCategory param ROW_PER_PAGE");
		System.out.println(categoryName +" <-- EbookDao.selectEbookListByCategory param categoryName");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMIT ?, ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, categoryName);
	    stmt.setInt(2, beginRow);
	    stmt.setInt(3, ROW_PER_PAGE);
	    
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next()) {
	    	Ebook ebook = new Ebook();
	    	ebook.setEbookNo(rs.getInt("ebookNo"));
	    	ebook.setCategoryName(rs.getString("categoryName"));
	    	ebook.setEbookTitle(rs.getString("ebookTitle"));
	    	ebook.setEbookState(rs.getString("ebookState"));
	    	ebookList.add(ebook);				
	    }
	    
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectEbookListByCategory stmt");
  		System.out.println(rs + " <-- EbookDao.selectEbookListByCategory rs");
  		
  		rs.close();
  		stmt.close();
  		conn.close();
	  		
		return ebookList;
	   }
	
	// [전자책 관리] ebook 카테고리별 목록 출력 - paging totalCount
	public int selectTotalCountByCategoryName(String categoryName) throws ClassNotFoundException, SQLException {
		int totalCount = 0;
		
		// debug
		System.out.println(categoryName +" <-- EbookDao.selectTotalCountByCategoryName param categoryName");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM ebook WHERE category_name=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, categoryName);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectTotalCountByCategoryName stmt");
  		System.out.println(rs + " <-- EbookDao.selectTotalCountByCategoryName rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [전자책 관리] ebook 검색 - ebookTitle로 특정 ebook조회
	public ArrayList<Ebook> selectEbookListAllBySearchEbookTitle(int beginRow, int ROW_PER_PAGE, String searchEbookTitle) throws ClassNotFoundException, SQLException{
		ArrayList<Ebook> ebookList = new ArrayList<>();
		
		// debug
		System.out.println(beginRow +" <-- EbookDao.selectEbookListAllBySearchEbookTitle param beginRow");
		System.out.println(ROW_PER_PAGE +" <-- EbookDao.selectEbookListAllBySearchEbookTitle param ROW_PER_PAGE");
		System.out.println(searchEbookTitle +" <-- EbookDao.selectEbookListAllBySearchEbookTitle param searchEbookTitle");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE ebook_title LIKE ? ORDER BY createDate DESC limit ?, ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, "%" + searchEbookTitle + "%");
	    stmt.setInt(2, beginRow);
	    stmt.setInt(3, ROW_PER_PAGE);
	    ResultSet rs = stmt.executeQuery();
		
	    while(rs.next()) {
	    	Ebook ebook = new Ebook();
	    	ebook.setEbookNo(rs.getInt("ebookNo"));
	    	ebook.setCategoryName(rs.getString("categoryName"));
	    	ebook.setEbookTitle(rs.getString("ebookTitle"));
	    	ebook.setEbookState(rs.getString("ebookState"));
	    	ebookList.add(ebook);				
	    }
	    
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectEbookListAllBySearchEbookTitle stmt");
  		System.out.println(rs + " <-- EbookDao.selectEbookListAllBySearchEbookTitle rs");
 		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
		return ebookList;
	}
		
	// [관리자] 회원 검색 - paging totalCount
	public int selectTotalCountBySearchMemberId(String searchEbookTitle) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(searchEbookTitle +" <-- MemberDao.selectTotalCountBySearchMemberId param searchEbookTitle");
		
		int totalCount = 0;

		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM ebook WHERE ebook_title=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, searchEbookTitle);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectTotalCountBySearchMemberId stmt");
  		System.out.println(rs + " <-- EbookDao.selectTotalCountBySearchMemberId rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}

}
