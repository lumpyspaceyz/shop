package dao;

import java.sql.*;
import java.util.*;

//import java.lang.reflect.Member;

import commons.DBUtil;
import vo.Member;

public class MemberDao {
	
	// [비회원]
	public boolean insertMember(Member member) throws ClassNotFoundException, SQLException {
		boolean result = false;
		// debug
		System.out.println(member.getMemberId() +" <-- MemberDao.insertMebmer param memberId");
		System.out.println(member.getMemberPw() +" <-- MemberDao.insertMebmer param memberPw");
		System.out.println(member.getMemberName() +" <-- MemberDao.insertMebmer param memberName");
		System.out.println(member.getMemberAge() +" <-- MemberDao.insertMebmer param memberAge");
		System.out.println(member.getMemberGender() +" <-- MemberDao.insertMebmer param memberGender");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "INSERT INTO member (member_id, member_pw, member_level, member_name, member_age, member_gender, update_date, create_date) VALUES (?, PASSWORD(?), 0, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		stmt.setString(3, member.getMemberName());
		stmt.setInt(4, member.getMemberAge());
		stmt.setString(5, member.getMemberGender());
		int row = stmt.executeUpdate();
		// debug
		System.out.println(stmt + "<-- MemberDao.insertMember stmt");
		System.out.println(row + "<-- MemberDao.insertMember insert 결과 row");
		
		if(row == 1) {
		    result = true;
	    }
		
 		stmt.close();
 		conn.close();
 		
        return result;
	}	
	
	// [비회원] 아이디 중복 검사
	public String selectMemberId(String memberIdCheck) throws ClassNotFoundException, SQLException {
		String memberId = null;
		
		// debug
		System.out.println(memberIdCheck +" <-- MemberDao.selectMemberId param memberIdCheck");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT member_id memberId FROM member WHERE member_id=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, memberIdCheck);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	memberId = rs.getString("member_id");
	    }
	    // debug
		System.out.println(stmt + "<-- MemberDao.selectMemberId stmt");
		System.out.println(rs + "<-- MemberDao.selectMemberId rs");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
 		
 		return memberId; // null:사용가능, null!:사용불가(사용중)
	}
	
	// [회원] 로그인
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		Member returnMember = null;
		// debug
		System.out.println(member.getMemberId() +" <-- MemberDao.login param memberId");
		System.out.println(member.getMemberPw() +" <-- MemberDao.login param memberPw");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_pw memberPw, member_name memberName FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberNo(rs.getInt("memberNo"));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberLevel(rs.getInt("memberLevel"));
			returnMember.setMemberPw(rs.getString("memberPw"));
			returnMember.setMemberName(rs.getString("memberName"));
		}
		// debug
		System.out.println(stmt + "<-- MemberDao.login stmt");
		System.out.println(rs + "<-- MemberDao.login rs");

 		rs.close();
 		stmt.close();
 		conn.close();
 		
		return returnMember;
	}
	
	// [관리자] 회원목록 출력
	public ArrayList<Member> selectMemberListAllByPage(int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		ArrayList<Member> memberList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member ORDER BY createDate DESC limit ?, ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, beginRow);
	    stmt.setInt(2, ROW_PER_PAGE);
	    ResultSet rs = stmt.executeQuery();
		
	    while(rs.next()) {
			Member member = new Member();
			member.setMemberNo(rs.getInt("memberNo"));
			member.setMemberId(rs.getString("memberId"));
			member.setMemberLevel(rs.getInt("memberLevel"));
			member.setMemberName(rs.getString("memberName"));
			member.setMemberAge(rs.getInt("memberAge"));
			member.setMemberGender(rs.getString("memberGender"));
			member.setCreateDate(rs.getString("updateDate"));
			member.setUpdateDate(rs.getString("createDate"));
			memberList.add(member);				
		}
	    // debug
 		System.out.println(stmt + " <-- MemberDao.selectMemberListAllByPage stmt");
 		System.out.println(rs + " <-- MemberDao.selectMemberListAllByPage rs");
 		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
		return memberList;
	}
	
	// [관리자] 회원목록 출력 - paging totalCount
	public int selectTotalCount() throws ClassNotFoundException, SQLException {
		int totalCount = 0;

		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM member";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- MemberDao.selectTotalCount stmt");
  		System.out.println(rs + " <-- MemberDao.selectTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [관리자] 회원 검색 - 회원목록 출력
	public ArrayList<Member> selectMemberListAllBySearchMemberId(int beginRow, int ROW_PER_PAGE, String searchMemberId) throws ClassNotFoundException, SQLException{
		ArrayList<Member> memberList = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member WHERE member_id LIKE ? ORDER BY createDate DESC limit ?, ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, "%" + searchMemberId + "%");
	    stmt.setInt(2, beginRow);
	    stmt.setInt(3, ROW_PER_PAGE);
	    ResultSet rs = stmt.executeQuery();
		
	    while(rs.next()) {
			Member member = new Member();
			member.setMemberNo(rs.getInt("memberNo"));
			member.setMemberId(rs.getString("memberId"));
			member.setMemberLevel(rs.getInt("memberLevel"));
			member.setMemberName(rs.getString("memberName"));
			member.setMemberAge(rs.getInt("memberAge"));
			member.setMemberGender(rs.getString("memberGender"));
			member.setCreateDate(rs.getString("updateDate"));
			member.setUpdateDate(rs.getString("createDate"));
			memberList.add(member);				
		}
	    // debug
 		System.out.println(stmt + " <-- MemberDao.selectMemberListAllBySearchMemberId stmt");
 		System.out.println(rs + " <-- MemberDao.selectMemberListAllBySearchMemberId rs");
 		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
		return memberList;
	}
		
	// [관리자] 회원 검색 - paging totalCount
	public int selectTotalCountBySearchMemberId(String searchMemberId) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(searchMemberId +" <-- MemberDao.selectTotalCountBySearchMemberId param searchMemberId");
		
		int totalCount = 0;

		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT COUNT(*) FROM member WHERE member_id=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, searchMemberId);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
			totalCount = rs.getInt("COUNT(*)");
		}
	    // debug
  		System.out.println(stmt + " <-- MemberDao.selectTotalCount stmt");
  		System.out.println(rs + " <-- MemberDao.selectTotalCount rs");

	    rs.close();
		stmt.close();
		conn.close();
		
		return totalCount;
	}
	
	// [관리자+회원] 회원정보 상세 조회
	public Member selectMemberOne(int memberNo) throws ClassNotFoundException, SQLException {
		Member member = null;
		
		// debug
		System.out.println(memberNo +" <-- MemberDao.selectMemberOne param memberNo");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_pw memberPw, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member WHERE member_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, memberNo);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	member = new Member();
			member.setMemberNo(rs.getInt("memberNo"));
			member.setMemberId(rs.getString("memberId"));
			member.setMemberLevel(rs.getInt("memberLevel"));
			member.setMemberPw(rs.getString("memberPw"));
			member.setMemberName(rs.getString("memberName"));
			member.setMemberAge(rs.getInt("memberAge"));
			member.setMemberGender(rs.getString("memberGender"));
			member.setCreateDate(rs.getString("updateDate"));
			member.setUpdateDate(rs.getString("createDate"));
	    }
	    // debug
  		System.out.println(stmt + " <-- MemberDao.selectMemberOne stmt");
  		System.out.println(rs + " <-- MemberDao.selectMemberOne rs");
  		
 		rs.close();
 		stmt.close();
 		conn.close();
 		
	    return member;
	}
	
//	// [관리자] 관리자 권한 확인
//	public boolean checkAdmin(Member checkAdmin) throws ClassNotFoundException, SQLException {
//		// debug
//		System.out.println(checkAdmin.getMemberId() +" <-- MemberDao.checkAdmin param memberId");
//		System.out.println(checkAdmin.getMemberPw() +" <-- MemberDao.checkAdmin param memberPw");
//		
//		boolean result = false;
//
//		DBUtil dbUtil = new DBUtil();
//	    Connection conn = dbUtil.getConnection();
//	    
//		String sql = "SELECT member_level FROM member WHERE member_id=? AND member_pw=?";
//		PreparedStatement stmt = conn.prepareStatement(sql);
//	    stmt.setString(1, checkAdmin.getMemberId());
//	    stmt.setString(2, checkAdmin.getMemberPw());
//	    ResultSet rs = stmt.executeQuery();
//	    
//	    int adminLevel = 0;
//	    if(rs.next()) {
//	    	adminLevel = rs.getInt("member_level");
//	    }
//	    
//	    if(adminLevel == 1) {
//	    	result = true;
//	    } else {
//	    	result = false;
//	    }
//	    // debug
//  		System.out.println(stmt + " <-- MemberDao.checkAdmin stmt");
//  		System.out.println(rs + " <-- MemberDao.checkAdmin rs");
//  		System.out.println(adminLevel + " <-- MemberDao.checkAdmin adminLevel");
//  		
// 		rs.close();
// 		stmt.close();
// 		conn.close();
//	    
//		return result;
//	}

	// [관리자+회원] 회원정보 전체 수정
	public void updateMemberAllByAdmin(Member member) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(member.getMemberNo() +" <-- MemberDao.updateMemberAllByAdmin param memberNo");
		System.out.println(member.getMemberId() +" <-- MemberDao.updateMemberAllByAdmin param memberId");
		System.out.println(member.getMemberLevel() +" <-- MemberDao.updateMemberAllByAdmin param memberLevel");
		System.out.println(member.getMemberName() +" <-- MemberDao.updateMemberAllByAdmin param memberName");
		System.out.println(member.getMemberAge() +" <-- MemberDao.updateMemberAllByAdmin param memberAge");
		System.out.println(member.getMemberGender() +" <-- MemberDao.updateMemberAllByAdmin param memberGender");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE member SET member_id=?, member_level=?, member_name=?, member_age=?, member_gender=?, update_date=NOW() WHERE member_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, member.getMemberId());
	    stmt.setInt(2, member.getMemberLevel());
	    stmt.setString(3, member.getMemberName());
	    stmt.setInt(4, member.getMemberAge());
	    stmt.setString(5, member.getMemberGender());
	    stmt.setInt(6, member.getMemberNo());
	    ResultSet rs = stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- MemberDao.updateMemberAllByAdmin stmt");
  		System.out.println(rs + " <-- MemberDao.updateMemberAllByAdmin rs");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
	}
	
	// [관리자] 회원 등급 수정
	public void updateMemberLevelByAdmin(Member member) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(member.getMemberNo() +" <-- MemberDao.updateMemberLevelByAdmin param memberNo");
		System.out.println(member.getMemberLevel() +" <-- MemberDao.updateMemberLevelByAdmin param MemberLevel");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE member SET member_level=? WHERE member_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, member.getMemberLevel());
	    stmt.setInt(2, member.getMemberNo());
	    ResultSet rs = stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- MemberDao.updateMemberLevelByAdmin stmt");
  		System.out.println(rs + " <-- MemberDao.updateMemberLevelByAdmin rs");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
	}
	
	// [관리자] 회원 비밀번호 수정
	public void updateMemberPwByAdmin(Member member) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(member.getMemberNo() +" <-- MemberDao.updateMemberPwByAdmin param memberNo");
		System.out.println(member.getMemberPw() +" <-- MemberDao.updateMemberPwByAdmin param MemberPw");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "UPDATE member SET member_pw=PASSWORD(?) WHERE member_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, member.getMemberPw());
	    stmt.setInt(2, member.getMemberNo());
	    ResultSet rs = stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- MemberDao.updateMemberPwByAdmin stmt");
  		System.out.println(rs + " <-- MemberDao.updateMemberPwByAdmin rs");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
	}
	
	// [관리자+회원] 회원 강제탈퇴
	public void deleteMember(int memberNo) throws ClassNotFoundException, SQLException {
		// debug
		System.out.println(memberNo +" <-- MemberDao.deleteMember param memberNo");
			
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    String sql = "DELETE FROM member WHERE member_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, memberNo);
	    ResultSet rs = stmt.executeQuery();
	    // debug
  		System.out.println(stmt + " <-- MemberDao.deleteMember stmt");
  		System.out.println(rs + " <-- MemberDao.deleteMember rs");
	    
 		rs.close();
 		stmt.close();
 		conn.close();
	}
	
}
