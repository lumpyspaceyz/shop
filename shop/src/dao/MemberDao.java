package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

//import java.lang.reflect.Member;

import commons.DBUtil;
import vo.Member;

public class MemberDao {
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
	
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		Member returnMember = null;

		System.out.println(member.getMemberId() +" <-- MemberDao.login param memberId");
		System.out.println(member.getMemberPw() +" <-- MemberDao.login param memberPw");
		
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
		String sql = "SELECT member_no memberNo, member_id memberId, member_name memberName FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberNo(rs.getInt("memberNo"));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberName(rs.getString("memberName"));
			return returnMember;
		}
		return null;
	}

}
