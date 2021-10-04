package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.Notice;
import vo.Qna;
import vo.QnaQnaComment;

public class QnaDao {
	// [회원+관리자] qna 입력
	public void insertQna(Qna qna) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(qna.getQnaCategory() +" <-- QnaDao.insertQna param qnaCategory");
		System.out.println(qna.getQnaTitle() +" <-- QnaDao.insertQna param qnaTitle");
		System.out.println(qna.getMemberNo() +" <-- QnaDao.insertQna param memberNo");
		System.out.println(qna.getQnaContent() +" <-- QnaDao.insertQna param qnaContent");
		System.out.println(qna.getQnaSecret() +" <-- QnaDao.insertQna param qnaSecret");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "INSERT INTO qna (qna_category, qna_title, qna_content, qna_secret, member_no, create_date, update_date) VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qna.getQnaCategory());
		stmt.setString(2, qna.getQnaTitle());
		stmt.setString(3, qna.getQnaContent());
		stmt.setString(4, qna.getQnaSecret());
		stmt.setInt(5, qna.getMemberNo());
		stmt.executeUpdate();
		
		// debug
		System.out.println(stmt + "<-- QnaDao.insertQna stmt");
		
 		stmt.close();
 		conn.close();
	}
	
	// [일반+회원+관리자] - qna 목록 출력
	public ArrayList<Qna> selectQnaList(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		ArrayList<Qna> qnaList = new ArrayList<>();
		
		//debug
		System.out.println(beginRow +" <-- QnaCommentDao.selectQnaList param beginRow");
		System.out.println(ROW_PER_PAGE +" <-- QnaCommentDao.selectQnaList param ROW_PER_PAGE");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT qna_no qnaNo, qna_category qnaCategory, qna_title qnaTitle, qna_content qnaContent, qna_secret qnaSecret, member_no memberNo, create_date createDate, update_date updateDate FROM qna ORDER BY createDate DESC LIMIT ?, ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, beginRow);
	    stmt.setInt(2, ROW_PER_PAGE);
	    ResultSet rs = stmt.executeQuery();
		
	    while(rs.next()) {
	    	Qna qna = new Qna();
	    	qna.setQnaNo(rs.getInt("qnaNo"));
	    	qna.setQnaCategory(rs.getString("qnaCategory"));
	    	qna.setQnaTitle(rs.getString("qnaTitle"));
	    	qna.setQnaContent(rs.getString("qnaContent"));
	    	qna.setQnaSecret(rs.getString("qnaSecret"));
	    	qna.setMemberNo(rs.getInt("memberNo"));
	    	qna.setCreateDate(rs.getString("createDate"));
	    	qna.setUpdateDate(rs.getString("updateDate"));
	    	qnaList.add(qna);				
		}
	    // debug
 		System.out.println(stmt + " <-- QnaDao.selectQnaList stmt");
 		System.out.println(rs + " <-- QnaDao.selectQnaList rs");
 		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
		return qnaList;
	}
	
	// [일반+회원+관리자] qna 목록 출력 - paging totalCount
	public int selectTotalCount() throws ClassNotFoundException, SQLException {
		int totalCount = 0;

		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM qna";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- QnaDao.selectTotalCount stmt");
  		System.out.println(rs + " <-- QnaDao.selectTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [회원+관리자] qna 상세 조회
	public Qna selectQnaOne(int qnaNo) throws ClassNotFoundException, SQLException {
		Qna qna = null;
		
		// debug
		System.out.println(qnaNo +" <-- QnaDao.selectQnaOne param qnaNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT qna_no qnaNo, qna_category qnaCategory, qna_title qnaTitle, qna_content qnaContent, qna_secret qnaSecret, member_no memberNo, create_date createDate, update_date updateDate FROM qna WHERE qna_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, qnaNo);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	qna = new Qna();
	    	qna.setQnaNo(rs.getInt("qnaNo"));
	    	qna.setQnaCategory(rs.getString("qnaCategory"));
	    	qna.setQnaTitle(rs.getString("qnaTitle"));
	    	qna.setQnaContent(rs.getString("qnaContent"));
	    	qna.setQnaSecret(rs.getString("qnaSecret"));
	    	qna.setMemberNo(rs.getInt("memberNo"));
	    	qna.setCreateDate(rs.getString("createDate"));
	    	qna.setUpdateDate(rs.getString("updateDate"));
	    }
	    // debug
  		System.out.println(stmt + " <--  QnaDao.selectQnaOne stmt");
  		System.out.println(rs + " <--  QnaDao.selectQnaOne rs");
  		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
	    return qna;
	}
	
	// [회원] qna 수정
	public void updateQna(Qna qna) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(qna.getQnaNo() +" <-- QnaDao.updateQna param qnaNo");
		System.out.println(qna.getMemberNo() +" <-- QnaDao.updateQna param memberNo");
		System.out.println(qna.getQnaCategory() +" <-- QnaDao.updateQna param qnaCategory");
		System.out.println(qna.getQnaTitle() +" <-- QnaDao.updateQna param qnaTitle");
		System.out.println(qna.getQnaContent() +" <-- QnaDao.updateQna param qnaContent");
		System.out.println(qna.getQnaSecret() +" <-- QnaDao.updateQna param qnaSecret");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE qna SET qna_category=?, qna_title=?, qna_content=?, qna_secret=?, update_date=NOW() WHERE qna_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, qna.getQnaCategory());
	    stmt.setString(2, qna.getQnaTitle());
	    stmt.setString(3, qna.getQnaContent());
	    stmt.setString(4, qna.getQnaSecret());
	    stmt.setInt(5, qna.getQnaNo());
	    stmt.executeUpdate();
	    // debug
  		System.out.println(stmt + " <-- QnaDao.updateQna stmt");
	    
 		stmt.close();
 		conn.close();
	}
	
	// [공지 관리] 공지 삭제
	public void deleteQna(int qnaNo) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(qnaNo +" <-- QnaDao.deleteQna param qnaNo");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "DELETE FROM qna WHERE qna_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, qnaNo);
	    stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- QnaDao.deleteQna stmt");
	    
 		stmt.close();
 		conn.close();
	}
	
	// [관리자] [adminIndex] 답글이 달리지 않은 최근 qna 5개 조회
	public ArrayList<QnaQnaComment> selectNewerQnaList() throws ClassNotFoundException, SQLException {
		ArrayList<QnaQnaComment> qqcList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT q.qna_no qnaNo, q.member_no memberNo, q.qna_title qnaTitle, q.update_date updateDate FROM qna q LEFT JOIN qna_comment qc ON q.qna_no = qc.qna_no WHERE qc.qna_no IS NULL LIMIT 0, 5";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next()) {
	    	QnaQnaComment qqc = new QnaQnaComment();
	    	
	    	Qna qna = new Qna();
	    	qna.setQnaNo(rs.getInt("qnaNo"));
	    	qna.setMemberNo(rs.getInt("memberNo"));
	    	qna.setQnaTitle(rs.getString("qnaTitle"));
	    	qna.setUpdateDate(rs.getString("updateDate"));
	    	qqc.setQna(qna);	
	    	
	    	qqcList.add(qqc);
	    }
	    
	    // debug
  		System.out.println(stmt + " <-- QnaDao.selectNewerQnaList stmt");
  		System.out.println(rs + " <-- QnaDao.selectNewerQnaList rs");
  		
  		rs.close();
  		stmt.close();
  		conn.close();
	  		
		return qqcList;
	}
	
	// [회원] qna 비밀글 qnaSecret 검사
	public boolean qnaSecretCheck(int qnaNo, String qnaSecret, int memberNo) throws ClassNotFoundException, SQLException {
		boolean result = false;
		int memberPw = 0;
		
		// debug
		System.out.println(qnaNo +" <-- QnaDao.qnaSecretCheck param qnaNo");
		System.out.println(qnaSecret +" <-- QnaDao.qnaSecretCheck param qnaSecret");
		System.out.println(memberNo +" <-- QnaDao.qnaSecretCheck param memberNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT q.qna_no, q.member_no FROM qna q INNER JOIN member m ON m.member_pw=PASSWORD(?) WHERE q.qna_no=? AND q.member_no=?;";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, qnaSecret);
	    stmt.setInt(2, qnaNo);
	    stmt.setInt(3,  memberNo);
	    ResultSet rs = stmt.executeQuery();
	    while(rs.next()) {
	    	result = true;
	    }
	    // debug
		System.out.println(stmt + "<-- QnaDao.qnaSecretCheck stmt");
		System.out.println(rs + "<-- QnaDao.qnaSecretCheck rs");
		
		System.out.println(result + " <-- QnaDao.qnaSecretCheck result");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
 		
 		return result; // true:성공, false:실패
	}
	

}
