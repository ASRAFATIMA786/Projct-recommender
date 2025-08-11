package com.customer;

import java.io.IOException;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.connection.DatabaseConnection;

/**
 * Servlet implementation class AddReview
 */
@WebServlet("/AddReview")
public class AddReview extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddReview() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String pid=request.getParameter("productid");
		String review=request.getParameter("review");
		String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		StringBuilder salt = new StringBuilder();
		Random rnd = new Random();
		int id = rnd.nextInt(9000) + 10000;
		HttpSession hs=request.getSession();
		try{
		int addCustomer = DatabaseConnection.insertUpdateFromSqlQuery(
				"insert into review(id,productid,review)values('" + id
						+ "','" + pid + "','" +review + "')");
		if (addCustomer > 0) {
			String message="Review added successfully.";
			hs.setAttribute("success-message", message);
			response.sendRedirect("review.jsp");
		} else {
			String message="Review failed";
			hs.setAttribute("fail-message", message);
			response.sendRedirect("review.jsp");
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}
