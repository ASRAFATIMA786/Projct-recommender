
<%@page import="com.controller.DatabaseConnection"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Product Review Summary</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f9f9f9;
        }
        #chartContainer {
            width: 80%;
            margin: 40px auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 10px #ccc;
            border-radius: 10px;
        }
        .rating {
            margin: 10px;
        }
    </style>
</head>
<body>
<%
    class ProductData {
        int productId;
        int totalReviews = 0;
        int totalScore = 0;

        ProductData(int productId) {
            this.productId = productId;
        }

        int getAverageRating() {
            if (totalReviews == 0) return 0;
            int avg = Math.round((float) totalScore / totalReviews);
            return Math.min(avg, 5);  // Ensure max rating is 5
        }
    }

    String[] positiveWords = {"good", "great", "excellent", "amazing", "nice", "happy", "satisfied", "awesome", "love"};
    String[] negativeWords = {"bad", "poor", "terrible", "worst", "unsatisfied", "angry", "disappointed", "hate"};

    Map<Integer, ProductData> productMap = new HashMap<Integer, ProductData>();
    try {
        Connection con = DatabaseConnection.getConnection();
        String query = "SELECT productid, review FROM review";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            int productId = rs.getInt("productid");
            String review = rs.getString("review");

            if (!productMap.containsKey(productId)) {
                productMap.put(productId, new ProductData(productId));
            }

            ProductData data = productMap.get(productId);
            data.totalReviews++;

            int score = 3; // Neutral base score
            if (review != null) {
                review = review.toLowerCase();
                for (String word : positiveWords) {
                    if (review.contains(word)) score++;
                }
                for (String word : negativeWords) {
                    if (review.contains(word)) score--;
                }
            }

            // Clamp score between 1 and 5
            score = Math.max(1, Math.min(score, 5));
            data.totalScore += score;
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }

    // Prepare JS arrays
    StringBuilder productLabels = new StringBuilder();
    StringBuilder reviewCounts = new StringBuilder();
    StringBuilder ratingArray = new StringBuilder();

    for (Map.Entry<Integer, ProductData> entry : productMap.entrySet()) {
        int pid = entry.getKey();
        ProductData d = entry.getValue();

        productLabels.append("'Product ").append(pid).append("',");
        reviewCounts.append(d.totalReviews).append(",");
        ratingArray.append(d.getAverageRating()).append(",");
    }

    // Remove last commas
    if (productLabels.length() > 0) productLabels.setLength(productLabels.length() - 1);
    if (reviewCounts.length() > 0) reviewCounts.setLength(reviewCounts.length() - 1);
    if (ratingArray.length() > 0) ratingArray.setLength(ratingArray.length() - 1);
%>

<div id="chartContainer">
    <h2>Product Review Summary</h2>
    <canvas id="reviewChart"></canvas>

    <h3>⭐ Average Star Ratings</h3>
    <div class="rating">
        <%
            for (Map.Entry<Integer, ProductData> entry : productMap.entrySet()) {
                int stars = entry.getValue().getAverageRating();
        %>
            <p>Product <%=entry.getKey()%>: 
                <%
                    for (int i = 1; i <= stars; i++) {
                        out.print("⭐");
                    }
                    for (int i = stars + 1; i <= 5; i++) {
                        out.print("☆");
                    }
                %>
            </p>
        <% } %>
    </div>
</div>

<script>
    const ctx = document.getElementById('reviewChart').getContext('2d');
    const reviewChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [<%= productLabels.toString() %>],
            datasets: [
                {
                    label: 'Number of Reviews',
                    data: [<%= reviewCounts.toString() %>],
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                },
                {
                    label: 'Average Rating (out of 5)',
                    data: [<%= ratingArray.toString() %>],
                    backgroundColor: 'rgba(255, 206, 86, 0.7)',
                    borderColor: 'rgba(255, 206, 86, 1)',
                    borderWidth: 1,
                    type: 'line'
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    max: 10
                }
            }
        }
    });
</script>

</body>
</html>
