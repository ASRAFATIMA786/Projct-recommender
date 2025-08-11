<%@page import="com.controller.DatabaseConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>PRUS: Product Recommender System Based on User Specifications and Customer Reviews</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
    <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="js/bootstrap-3.1.1.min.js"></script>
</head>
<body>

<style>
/* Ensure product thumbnails are uniform */
.product-men {
    padding: 15px;
}

.men-thumb-item img {
    width: 100%;
    height: 220px;
    object-fit: cover; /* maintain aspect ratio */
    border-radius: 10px;
}

/* Equal height for all product cards */
.men-pro-item {
    border: 1px solid #ddd;
    border-radius: 12px;
    padding: 15px;
    height: 420px;
    background: #fff;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

/* Consistent title height */
.item-info-product h4 {
    height: 40px;
    overflow: hidden;
    font-weight: bold;
    text-align: center;
}

/* Price spacing and button */
.info-product-price {
    text-align: center;
    margin: 10px 0;
}

.item_price {
    font-weight: bold;
    color: green;
}

.item-info-product input[type="submit"] {
    width: 100%;
    margin-top: auto;
    background-color: #ffc107;
    border: none;
    font-weight: bold;
    border-radius: 5px;
    padding: 10px;
}

.item-info-product input[type="submit"]:hover {
    background-color: #ff9800;
    transition: 0.3s ease;
}
</style>

<ul>
					<li><a href="index.jsp" style="width: 150px;"><i
							class="fas fa-user"></i>&nbsp;Recomended Ranking</a></li>
			
					<li><a href="chart.jsp" style="width: 150px;"><i
							class="fas fa-user"></i>&nbsp;Analysis</a></li>
				
				</ul>
				
<!-- <a href="chart.jsp">Analysis</a>
<a href="index.jsp">Recommended</a> -->
    <div class="container">
        <h1 class="text-center text-success">PRUS: Product Recommender System Based on User Specifications and Customer Reviews</h1>

        <h2 class="text-center">Top Rated Grocery Products</h2>

        <div class="row">
            <%
                class ProductScore {
                    int productId;
                    String name;
                    String image;
                    double avgRating;
                    int reviewCount;
                    double price;
                    double mrp;
                }

                List<ProductScore> products = new ArrayList<>();

                String[] positiveWords = {"good", "great", "excellent", "amazing", "nice", "happy", "satisfied", "awesome", "love"};
                String[] negativeWords = {"bad", "poor", "terrible", "worst", "unsatisfied", "angry", "disappointed", "hate"};

                Connection con = DatabaseConnection.getConnection();
                ResultSet rs = DatabaseConnection.getResultFromSqlQuery("SELECT * FROM tblproduct WHERE product_category='Grocery Product'");
                while (rs.next()) {
                    int productId = rs.getInt("id");
                    String name = rs.getString("name");
                    String image = rs.getString("image_name");
                    double price = rs.getDouble("price");
                    double mrp = rs.getDouble("mrp_price");

                    PreparedStatement reviewStmt = con.prepareStatement("SELECT review FROM review WHERE productid=?");
                    reviewStmt.setInt(1, productId);
                    ResultSet reviewRs = reviewStmt.executeQuery();
                    int total = 0, score = 0;
                    while (reviewRs.next()) {
                        String review = reviewRs.getString("review");
                        int s = 3;
                        if (review != null) {
                            review = review.toLowerCase();
                            for (String p : positiveWords) if (review.contains(p)) s++;
                            for (String n : negativeWords) if (review.contains(n)) s--;
                        }
                        s = Math.max(1, Math.min(5, s));
                        score += s;
                        total++;
                    }
                    reviewRs.close();
                    reviewStmt.close();

                    double avg = total == 0 ? 0 : (double) score / total;
                    ProductScore ps = new ProductScore();
                    ps.productId = productId;
                    ps.name = name;
                    ps.image = image;
                    ps.avgRating = avg;
                    ps.reviewCount = total;
                    ps.price = price;
                    ps.mrp = mrp;
                    products.add(ps);
                }
                con.close();

                // Sort products by average rating descending
                products.sort((a, b) -> Double.compare(b.avgRating, a.avgRating));

                for (ProductScore p : products) {
            %>
            <form action="AddToCart" method="post" class="col-md-3">
                <div class="product-men">
                    <div class="men-pro-item simpleCart_shelfItem">
                        <div class="men-thumb-item">
                            <input type="hidden" name="productId" value="<%=p.productId%>">
                            <a href="user-recommander.jsp?mainp=<%=p.productId%>">
                                <img src="uploads/<%=p.image%>" alt="" class="img-responsive">
                            </a>
                        </div>
                        <div class="item-info-product text-center">
                            <h4><a href="#"><%=p.name%></a></h4>
                            <p>
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <%= i <= Math.round(p.avgRating) ? "" : "" %>
                                <% } %>
                                (<%=String.format("%.1f", p.avgRating)%>/5 from <%=p.reviewCount%> reviews)
                            </p>
                            <div class="info-product-price">
                                <input type="hidden" name="price" value="<%=p.price%>">
                                <input type="hidden" name="mrp_price" value="<%=p.mrp%>">
                                <span class="item_price"><%=p.price%> Rs.</span>
                                <del><%=p.mrp%> Rs.</del>
                            </div>
                            <input type="submit" value="Add to cart" class="btn btn-warning">
                            <a href="view-reviews.jsp?productid=<%=p.productId%>" class="btn btn-info" style="margin-top:5px;">View Reviews</a>
                        </div>
                    </div>
                </div>
            </form>
            <% } %>
        </div>
    </div>
</body>
</html>
