package dao;

import java.sql.*;
import java.util.*;

//import java.lang.reflect.Member;

import commons.DBUtil;
import vo.Category;
import vo.Member;

public class CategoryDao {
	
	// [카테고리 관리] - 카테고리 추가
	public void insertCategory(Category category) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(category.getCategoryName() +" <-- CategoryDao.insertCategory param categoryName");
		System.out.println(category.getCategoryState() +" <-- CategoryDao.insertCategory param categoryState");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "INSERT INTO category (category_name, update_date, create_date, category_state) VALUES (?, NOW(), NOW(), ?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, category.getCategoryName());
		stmt.setString(2, category.getCategoryState());
		int row = stmt.executeUpdate();
		// debug
		System.out.println(stmt + "<-- CategoryDao.insertCategory stmt");
		System.out.println(row + "<-- CategoryDao.insertCategory insert 결과 row");
		
 		stmt.close();
 		conn.close();
	}	
	
	// [카테고리 관리] - 카테고리 중복 검사
	public String selectCategoryName(String categoryNameCheck) throws ClassNotFoundException, SQLException {
		String categoryName = null;
		
		// debug
		System.out.println(categoryNameCheck +" <-- CategoryDao.selectCategoryName param categoryNameCheck");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT category_name categoryName FROM category WHERE category_name=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, categoryNameCheck);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	categoryName = rs.getString("category_name");
	    }
	    // debug
		System.out.println(stmt + "<-- CategoryDao.selectCategoryName stmt");
		System.out.println(rs + "<-- CategoryDao.selectCategoryName rs");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
 		
 		return categoryName; // null:사용가능, null!:사용불가(사용중)
	}
	
	// [카테고리 관리] - 카테고리 목록 출력
	public ArrayList<Category> selectCategoryList() throws ClassNotFoundException, SQLException{
		ArrayList<Category> categoryList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT category_name categoryName, update_date updateDate, create_date createDate, category_state categoryState FROM category ORDER BY createDate DESC";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
		
	    while(rs.next()) {
			Category category = new Category();
			category.setCategoryName(rs.getString("category_name"));
			category.setUpdateDate(rs.getString("update_date"));
			category.setCreateDate(rs.getString("create_date"));
			category.setCategoryState(rs.getString("category_state"));
			categoryList.add(category);				
		}
	    // debug
 		System.out.println(stmt + " <-- CategoryDao.selectCategoryList stmt");
 		System.out.println(rs + " <-- CategoryDao.selectCategoryList rs");
 		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
		return categoryList;
	}
	
	// [카테고리 관리] - 카테고리 정보 상세 조회
	public Category selectCategoryOne(String categoryName) throws ClassNotFoundException, SQLException {
		Category category = null;
		
		// debug
		System.out.println(categoryName +" <-- CategoryDao.selectCategoryOne param categoryName");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT category_name, update_date, create_date, category_state FROM category WHERE category_name=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, categoryName);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	category = new Category();
	    	category.setCategoryName(rs.getString("category_name"));
	    	category.setUpdateDate(rs.getString("update_date"));
	    	category.setCreateDate(rs.getString("create_date"));
	    	category.setCategoryState(rs.getString("category_state"));
	    }
	    // debug
  		System.out.println(stmt + " <-- CategoryDao.selectCategoryOne stmt");
  		System.out.println(rs + " <-- CategoryDao.selectCategoryOne rs");
  		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
	    return category;
	}
	
	// [카테고리 관리] - 카테고리 정보 수정
	public void updateCategory(Category category) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(category.getCategoryName() +" <-- CategoryDao.updateCategory param categoryName");
		System.out.println(category.getCategoryState() +" <-- CategoryDao.updateCategory param categoryState");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE category SET category_name=?, category_state=?, update_date=NOW() WHERE category_name=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, category.getCategoryName());
	    stmt.setString(2, category.getCategoryState());
	    stmt.setString(3, category.getCategoryName());
	    ResultSet rs = stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- CategoryDao.updateCategory stmt");
  		System.out.println(rs + " <-- CategoryDao.updateCategory rs");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
	}

}
