package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.Notice;
import vo.Qna;
import vo.QnaComment;
import vo.QnaQnaComment;

public class QnaCommentDao {
	// [관리자+qna작성자] qnaComment 입력
	public void insertQnaComment(QnaComment qnaComment) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(qnaComment.getQnaNo() +" <-- QnaCommentDao.insertQnaComment param qnaNo");
		System.out.println(qnaComment.getQnaCommentContent() +" <-- insertQnaComment.insertNotice param qnaCommentContent");
		System.out.println(qnaComment.getMemberNo() +" <-- QnaCommentDao.insertQnaComment param memberNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "INSERT INTO qna_comment (qna_no, qna_comment_content, member_no, update_date, create_date) VALUES (?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaComment.getQnaNo());
		stmt.setString(2, qnaComment.getQnaCommentContent());
		stmt.setInt(3, qnaComment.getMemberNo());
		stmt.executeUpdate();
		
		// debug
		System.out.println(stmt + "<-- QnaCommentDao.insertQnaComment stmt");
		
 		stmt.close();
 		conn.close();
	}
	
	// [회원+관리자] qna 답글 불러오기
	public ArrayList<QnaComment> selectQnaCommentListByPage(int qnaNo, int commentBeginRow, int COMMENT_ROW_PER_PAGE) throws SQLException, ClassNotFoundException {
		ArrayList<QnaComment> qnaCommentList = new ArrayList<>();
		
		// debug
		System.out.println(qnaNo +" <-- QnaCommentDao.selectQnaCommentListByPage param qnaNo");
		System.out.println(commentBeginRow +" <-- QnaCommentDao.selectQnaCommentListByPage param commentBeginRow");
		System.out.println(COMMENT_ROW_PER_PAGE +" <-- QnaCommentDao.selectQnaCommentListByPage param COMMENT_ROW_PER_PAGE");
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입을 변환(가공)
		String sql = "SELECT qna_no qnaNo, qna_comment_no qnaCommentNo, qna_comment_content qnaCommentContent, member_no memberNo, create_date createDate, update_date updateDate FROM qna_comment WHERE qna_no=? ORDER BY createDate DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		stmt.setInt(2, commentBeginRow);
		stmt.setInt(3, COMMENT_ROW_PER_PAGE);
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			QnaComment qnaComment = new QnaComment();
			qnaComment.setQnaNo(rs.getInt("qnaNo"));
			qnaComment.setQnaCommentNo(rs.getInt("qnaCommentNo"));
			qnaComment.setQnaCommentContent(rs.getString("qnaCommentContent"));
			qnaComment.setMemberNo(rs.getInt("memberNo"));
			qnaComment.setCreateDate(rs.getString("createDate"));
			qnaComment.setUpdateDate(rs.getString("updateDate"));
			qnaCommentList.add(qnaComment);				
		}
		// debug
		System.out.println(stmt + " QnaCommentDao.selectQnaCommentListByPage <-- stmt");
		System.out.println(rs + " QnaCommentDao.selectQnaCommentListByPage <-- rs");

		rs.close();
		stmt.close();
		conn.close();
		
		return qnaCommentList;
	}
	
	// [회원+관리자] qna 답글 불러오기 - paging totalCount
	public int selectCommentTotalCount(int qnaNo) throws ClassNotFoundException, SQLException {
		int totalCount = 0;

		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM qna_comment WHERE qna_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, qnaNo);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- QnaCommentDao.selectTotalCount stmt");
  		System.out.println(rs + " <-- QnaCommentDao.selectTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [회원+관리자] qna 답글 수정
	public void updateQnaComment(QnaComment qnaComment) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(qnaComment.getQnaCommentNo() +" <-- QnaCommentDao.updateQnaComment param qnaCommentNo");
		System.out.println(qnaComment.getQnaCommentContent() +" <-- QnaCommentDao.updateQnaComment param qnaCommentContent");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE qna_comment SET qna_comment_content=?, update_date=NOW() WHERE qna_comment_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, qnaComment.getQnaCommentContent());
	    stmt.setInt(2, qnaComment.getQnaCommentNo());
	    stmt.executeUpdate();
	    // debug
  		System.out.println(stmt + " <-- QnaCommentDao.updateQnaComment stmt");
	    
 		stmt.close();
 		conn.close();
	}
	
	// [회원+관리자] qna 답글 삭제
	public void deleteQnaComment(QnaComment qnaComment) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(qnaComment.getQnaNo() +" <-- QnaCommentDao.deleteQnaComment param qnaNo");
		System.out.println(qnaComment.getQnaCommentNo() +" <-- QnaCommentDao.deleteQnaComment param qnaCommentNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "DELETE FROM qna_comment WHERE qna_no=? AND qna_comment_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, qnaComment.getQnaNo());
	    stmt.setInt(2, qnaComment.getQnaCommentNo());
	    stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- QnaCommentDao.deleteQnaComment stmt");
	    
 		stmt.close();
 		conn.close();
	}

}
