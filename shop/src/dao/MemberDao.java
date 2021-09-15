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
		System.out.println(stmt + "<-- stmt");
		System.out.println(row + "<-- insert 결과 row");
		
		if(row == 1) {
		    result = true;
	    }
        return result;
	}	
	
	// [회원]
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		Member returnMember = null;

		System.out.println(member.getMemberId() +" <-- MemberDao.login param memberId");
		System.out.println(member.getMemberPw() +" <-- MemberDao.login param memberPw");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberNo(rs.getInt("memberNo"));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberLevel(rs.getInt("memberLevel"));
			returnMember.setMemberName(rs.getString("memberName"));
		}
		return returnMember;
	}
	
	// [관리자] 회원목록출력
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

}
