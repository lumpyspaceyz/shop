package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.Ebook;
import vo.Member;
import vo.Notice;

public class NoticeDao {
	// [공지 관리] - 공지 입력
	public void insertNotice(Notice notice) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(notice.getNoticeTitle() +" <-- NoticeDao.insertNotice param noticeTitle");
		System.out.println(notice.getNoticeContent() +" <-- NoticeDao.insertNotice param noticeContent");
		System.out.println(notice.getMemberNo() +" <-- NoticeDao.insertNotice param memberNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "INSERT INTO notice (notice_title, notice_content, member_no, update_date, create_date) VALUES (?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNoticeTitle());
		stmt.setString(2, notice.getNoticeContent());
		stmt.setInt(3, notice.getMemberNo());
		stmt.executeUpdate();
		
		// debug
		System.out.println(stmt + "<-- NoticeDao.insertNotice stmt");
		
 		stmt.close();
 		conn.close();
	}	
		
	// [공지 관리] - 공지 목록 출력
	public ArrayList<Notice> selectNoticeList(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		ArrayList<Notice> noticeList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate FROM notice ORDER BY createDate DESC LIMIT ?, ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, beginRow);
	    stmt.setInt(2, ROW_PER_PAGE);
	    ResultSet rs = stmt.executeQuery();
		
	    while(rs.next()) {
	    	Notice notice = new Notice();
	    	notice.setNoticeNo(rs.getInt("noticeNo"));
	    	notice.setNoticeTitle(rs.getString("noticeTitle"));
	    	notice.setNoticeContent(rs.getString("noticeContent"));
	    	notice.setMemberNo(rs.getInt("memberNo"));
	    	notice.setCreateDate(rs.getString("createDate"));
	    	notice.setUpdateDate(rs.getString("updateDate"));
	    	noticeList.add(notice);				
		}
	    // debug
 		System.out.println(stmt + " <-- NoticeDao.selectNoticeList stmt");
 		System.out.println(rs + " <-- NoticeDao.selectNoticeList rs");
 		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
		return noticeList;
	}
	
	// [공지 관리] 공지 목록 출력 - paging totalCount
	public int selectTotalCount() throws ClassNotFoundException, SQLException {
		int totalCount = 0;

		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM notice";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- NoticeDao.selectTotalCount stmt");
  		System.out.println(rs + " <-- NoticeDao.selectTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [공지 관리] 공지 상세 조회
	public Notice selectNoticeOne(int noticeNo) throws ClassNotFoundException, SQLException {
		Notice notice = null;
		
		// debug
		System.out.println(noticeNo +" <-- NoticeDao.selectNoticeOne param noticeNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate FROM notice WHERE notice_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, noticeNo);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	notice = new Notice();
	    	notice.setNoticeNo(rs.getInt("noticeNo"));
	    	notice.setNoticeTitle(rs.getString("noticeTitle"));
	    	notice.setNoticeContent(rs.getString("noticeContent"));
	    	notice.setMemberNo(rs.getInt("memberNo"));
	    	notice.setCreateDate(rs.getString("createDate"));
	    	notice.setUpdateDate(rs.getString("updateDate"));
	    }
	    // debug
  		System.out.println(stmt + " <-- NoticeDao.selectNoticeOne stmt");
  		System.out.println(rs + " <-- NoticeDao.selectNoticeOne rs");
  		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
	    return notice;
	}
	
	// [공지 관리] 공지 수정
	public void updateNotice(Notice notice) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(notice.getNoticeTitle() +" <-- NoticeDao.updateNotice param noticeTitle");
		System.out.println(notice.getNoticeContent() +" <-- NoticeDao.updateNotice param noticeContent");
		System.out.println(notice.getNoticeNo() +" <-- NoticeDao.updateNotice param noticeNo");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE notice SET notice_title=?, notice_content=?, update_date=NOW() WHERE notice_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, notice.getNoticeTitle());
	    stmt.setString(2, notice.getNoticeContent());
	    stmt.setInt(3, notice.getNoticeNo());
	    stmt.executeUpdate();
	    // debug
  		System.out.println(stmt + " <-- NoticeDao.updateNotice stmt");
	    
 		stmt.close();
 		conn.close();
	}
	
	// [공지 관리] 공지 삭제
	public void deleteNotice(int noticeNo) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(noticeNo +" <-- NoticeDao.deleteNotice param noticeNo");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "DELETE FROM notice WHERE notice_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, noticeNo);
	    stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- NoticeDao.deleteNotice stmt");
	    
 		stmt.close();
 		conn.close();
	}
	
	// [관리자 + 고객] [index] - 최신 공지 5개 출력
	public ArrayList<Notice> selectNewerNoticeList() throws ClassNotFoundException, SQLException {
		ArrayList<Notice> noticeList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, member_no memberNo, create_date createDate FROM notice ORDER BY create_date DESC LIMIT 0, 5";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next()) {
	    	Notice notice = new Notice();
	    	notice.setNoticeNo(rs.getInt("noticeNo"));
	    	notice.setNoticeTitle(rs.getString("noticeTitle"));
	    	notice.setMemberNo(rs.getInt("memberNo"));
	    	notice.setCreateDate(rs.getString("createDate"));
	    	noticeList.add(notice);				
	    }
	    
	    // debug
  		System.out.println(stmt + " <-- NoticeDao.selectNewerNoticeList stmt");
  		System.out.println(rs + " <-- NoticeDao.selectNewerNoticeList rs");
  		
  		rs.close();
  		stmt.close();
  		conn.close();
	  		
		return noticeList;
	}

}
