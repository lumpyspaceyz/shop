package dao;

import java.util.*;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import java.sql.*;

import commons.DBUtil;
import vo.Ebook;
import vo.Member;

import java.io.File;

public class EbookDao {
	// [관리자 + 고객] [전자책 관리] ebook 전체목록 출력 
	public ArrayList<Ebook> selectEbookListAllByPage(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		ArrayList<Ebook> ebookList = new ArrayList<>();
		
		// debug
		System.out.println(beginRow +" <-- EbookDao.selectEbookList param beginRow");
		System.out.println(ROW_PER_PAGE +" <-- EbookDao.selectEbookList param ROW_PER_PAGE");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState, ebook_img ebookImg, ebook_price ebookPrice FROM ebook ORDER BY create_date DESC LIMIT ?, ?";
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
	    	ebook.setEbookImg(rs.getString("ebookImg"));
	    	ebook.setEbookPrice(rs.getInt("ebookPrice"));
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
	
	// [관리자 + 고객] [index] - 인기 상품 5개 출력
	public ArrayList<Ebook> selectPopualarEbookList() throws ClassNotFoundException, SQLException {
		ArrayList<Ebook> ebookList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT t.ebook_no ebookNo, e.ebook_title ebookTitle, e.ebook_img ebookImg, e.ebook_price ebookPrice FROM ebook e INNER JOIN (SELECT ebook_no,COUNT(ebook_no) cnt FROM orders GROUP BY ebook_no ORDER BY COUNT(ebook_no) DESC LIMIT 0,5) t ON e.ebook_no = t.ebook_no ORDER BY cnt DESC";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next()) {
	    	Ebook ebook = new Ebook();
	    	ebook.setEbookNo(rs.getInt("ebookNo"));
	    	ebook.setEbookTitle(rs.getString("ebookTitle"));
	    	ebook.setEbookImg(rs.getString("ebookImg"));
	    	ebook.setEbookPrice(rs.getInt("ebookPrice"));
	    	ebookList.add(ebook);				
	    }
	    
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectPopualarEbookList stmt");
  		System.out.println(rs + " <-- EbookDao.selectPopualarEbookList rs");
  		
  		rs.close();
  		stmt.close();
  		conn.close();
	  		
		return ebookList;
	}
	
	// [관리자 + 고객] [index] - 최신 상품 5개 출력
	public ArrayList<Ebook> selectNewerEbookList() throws ClassNotFoundException, SQLException {
		ArrayList<Ebook> ebookList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT ebook_no ebookNo, ebook_title ebookTitle, ebook_img ebookImg, ebook_price ebookPrice, create_date createDate FROM ebook ORDER BY create_date DESC LIMIT 0, 5";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next()) {
	    	Ebook ebook = new Ebook();
	    	ebook.setEbookNo(rs.getInt("ebookNo"));
	    	ebook.setEbookTitle(rs.getString("ebookTitle"));
	    	ebook.setEbookImg(rs.getString("ebookImg"));
	    	ebook.setEbookPrice(rs.getInt("ebookPrice"));
	    	ebook.setCreateDate(rs.getString("createDate"));
	    	ebookList.add(ebook);				
	    }
	    
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectNewerEbookList stmt");
  		System.out.println(rs + " <-- EbookDao.selectNewerEbookList rs");
  		
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
	    
	    String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE ebook_title LIKE ? ORDER BY create_date DESC limit ?, ?";
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
		
	// [전자책 관리] ebook 검색 - paging totalCount
	public int selectTotalCountBySearchMemberId(String searchEbookTitle) throws ClassNotFoundException, SQLException {
		int totalCount = 0;
		
		// debug
		System.out.println(searchEbookTitle +" <-- MemberDao.selectTotalCountBySearchMemberId param searchEbookTitle");

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
	
	// [전자책 관리] ebook 상세 조회
	public Ebook selectEbookOne(int ebookNo) throws ClassNotFoundException, SQLException {
		Ebook ebook = null;
		
		// debug
		System.out.println(ebookNo +" <-- EbookDao.selectEbookOne param ebookNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT ebook_no ebookNo, ebook_isbn ebookISBN, category_name categoryName, ebook_title ebookTitle, ebook_author ebookAuthor, ebook_company ebookCompany, ebook_page_count ebookPageCount, ebook_price ebookPrice, ebook_img ebookImg, ebook_summary ebookSummary, ebook_state ebookState, update_date updateDate, create_date createDate FROM ebook WHERE ebook_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, ebookNo);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	ebook = new Ebook();
	    	ebook.setEbookNo(rs.getInt("ebookNo"));
	    	ebook.setEbookISBN(rs.getString("ebookISBN"));
	    	ebook.setCategoryName(rs.getString("categoryName"));
	    	ebook.setEbookTitle(rs.getString("ebookTitle"));
	    	ebook.setEbookAuthor(rs.getString("ebookAuthor"));
	    	ebook.setEbookCompany(rs.getString("ebookCompany"));
	    	ebook.setEbookPageCount(rs.getInt("ebookPageCount"));
	    	ebook.setEbookPrice(rs.getInt("ebookPrice"));
	    	ebook.setEbookImg(rs.getString("ebookImg"));
	    	ebook.setEbookSummary(rs.getString("ebookSummary"));
	    	ebook.setEbookState(rs.getString("ebookState"));
	    	ebook.setUpdateDate(rs.getString("updateDate"));
	    	ebook.setCreateDate(rs.getString("createDate"));
	    }
	    // debug
  		System.out.println(stmt + " <-- EbookDao.selectEbookOne stmt");
  		System.out.println(rs + " <-- EbookDao.selectEbookOne rs");
  		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
	    return ebook;
	}
	
	// [전자책 관리] ebook 이미지 수정시 이전 이미지 삭제
	// [전자책 관리] ebook 이미지 수정
	public void updateEbookImg(Ebook ebook) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(ebook.getEbookNo() +" <-- EbookDao.updateEbookImg param ebookNo");
		System.out.println(ebook.getEbookImg() +" <-- EbookDao.updateEbookImg param ebookImg");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE ebook SET ebook_img=? WHERE ebook_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, ebook.getEbookImg());
	    stmt.setInt(2, ebook.getEbookNo());
	    ResultSet rs = stmt.executeQuery();
	    
	    // debug
  		System.out.println(stmt + " <-- EbookDao.updateEbookImg stmt");
  		System.out.println(rs + " <-- EbookDao.updateEbookImg rs");
  		
 		rs.close();
 		stmt.close();
 		conn.close();
	}
	
	// [전자책 관리] ebook 이미지 수정시 이전 이미지가 기본 이미지인지 검사 : 기본 이미지는 삭제하지 않기 위함
	public String selectEbookImg(int ebookNo) throws ClassNotFoundException, SQLException {
		String result = "other";
		
		// debug
		System.out.println(ebookNo +" <-- EbookDao.selectEbookImg param ebookNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT ebook_img FROM ebook WHERE ebook_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, ebookNo);
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next() == true) {
		    if(rs.getString("ebook_img").equals("noimage.png")) {
		    	result = "noimage";
		    }
	    }
	    // debug
		System.out.println(stmt + "<-- EbookDao.selectEbookImg SELECT stmt");
		System.out.println(rs + "<-- EbookDao.selectEbookImg SELECT rs");
		System.out.println(result + " <-- EbookDao.selectEbookImg SELECT result");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
 		
 		return result; // noimage:기본이미지, other:다른이미지
	}
	
	// [전자책 관리] ebook 전체 수정
	public void updateEbookAll(Ebook ebook) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(ebook +" <-- EbookDao.updateEbookAll param");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = " UPDATE ebook SET category_name=?, ebook_title=?, ebook_author=?, ebook_company=?, ebook_price=?, ebook_summary=?, ebook_state=?, update_date=? WHERE ebook_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, ebook.getCategoryName());
	    stmt.setString(2, ebook.getEbookTitle());
	    stmt.setString(3, ebook.getEbookAuthor());
	    stmt.setString(4, ebook.getEbookCompany());
	    stmt.setInt(5, ebook.getEbookPrice());
	    stmt.setString(6, ebook.getEbookSummary());
	    stmt.setString(7, ebook.getEbookState());
	    stmt.setString(8, ebook.getUpdateDate());
	    stmt.setInt(9, ebook.getEbookNo());
	    ResultSet rs = stmt.executeQuery();
	    
	    // debug
  		System.out.println(stmt + " <-- EbookDao.updateEbookAll stmt");
  		System.out.println(rs + " <-- EbookDao.updateEbookAll rs");
  		
 		rs.close();
 		stmt.close();
 		conn.close();
	}
	
	//

}
