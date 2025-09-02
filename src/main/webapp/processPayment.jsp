<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

String idsParam = request.getParameter("booking_ids");
String method   = request.getParameter("payment_method");

if (idsParam == null || idsParam.trim().isEmpty()) {
    out.println("<p style='color:red'>Invalid booking!</p>");
    return;
}
if (method == null || method.trim().isEmpty()) {
    out.println("<p style='color:red'>Payment method required!</p>");
    return;
}

String[] idParts = idsParam.split(",");
List<Integer> bookingIds = new ArrayList<>();
for (String p : idParts) {
    try { bookingIds.add(Integer.parseInt(p.trim())); } catch(Exception ex){}
}
if (bookingIds.isEmpty()) {
    out.println("<p style='color:red'>Invalid booking IDs!</p>");
    return;
}

String inClause = String.join(",", Collections.nCopies(bookingIds.size(), "?"));

double grandTotal = 0.0;
Connection conn = null;
String txnId = "TXN" + java.util.UUID.randomUUID().toString().replace("-", "").substring(0,12);

try {
    conn = con;
    conn.setAutoCommit(false);

    // 0️⃣ Guard: block if any selected booking already paid
    PreparedStatement psAlready = conn.prepareStatement(
        "SELECT GROUP_CONCAT(booking_id) AS paid_ids " +
        "FROM bookings WHERE booking_id IN (" + inClause + ") AND payment_status='Paid'"
    );
    for (int i=0; i<bookingIds.size(); i++) psAlready.setInt(i+1, bookingIds.get(i));
    ResultSet rsAlready = psAlready.executeQuery();
    String paidIds = null;
    if (rsAlready.next()) paidIds = rsAlready.getString("paid_ids");
    rsAlready.close(); psAlready.close();

    if (paidIds != null && !paidIds.trim().isEmpty()) {
        conn.rollback();
        out.println("<p style='color:red'>Payment already completed for booking(s): " + paidIds + ".</p>");
        return;
    }

    // 1️⃣ Compute grand total
    PreparedStatement psFare = conn.prepareStatement(
        "SELECT SUM(ss.fare) AS totalFare " +
        "FROM bookings b JOIN schedule_seats ss ON b.schedule_seat_id=ss.schedule_seat_id " +
        "WHERE b.booking_id IN (" + inClause + ")"
    );
    for (int i=0; i<bookingIds.size(); i++) psFare.setInt(i+1, bookingIds.get(i));
    ResultSet rsFare = psFare.executeQuery();
    if (rsFare.next()) grandTotal = rsFare.getDouble("totalFare");
    rsFare.close(); psFare.close();

    // 2️⃣ Insert single payment row
    PreparedStatement psPay = conn.prepareStatement(
        "INSERT INTO payments (booking_id, amount, payment_method, transaction_id, status) VALUES (?,?,?,?,?)",
        Statement.RETURN_GENERATED_KEYS
    );
    psPay.setInt(1, bookingIds.get(0)); // reference any one booking
    psPay.setDouble(2, grandTotal);
    psPay.setString(3, method);
    psPay.setString(4, txnId);
    psPay.setString(5, "Success");
    psPay.executeUpdate();

    ResultSet keys = psPay.getGeneratedKeys();
    int paymentId = 0;
    if (keys.next()) paymentId = keys.getInt(1);
    keys.close();
    psPay.close();

    // 3️⃣ Map all bookings to this payment
    // If you've added UNIQUE(booking_id), you can use INSERT IGNORE to avoid accidental duplicates.
    PreparedStatement psLink = conn.prepareStatement(
        "INSERT INTO payment_bookings (payment_id, booking_id) VALUES (?,?)"
        // If you prefer to re-point existing mapping to this payment, use:
        // + " ON DUPLICATE KEY UPDATE payment_id=VALUES(payment_id)"
    );
    for (Integer bid : bookingIds) {
        psLink.setInt(1, paymentId);
        psLink.setInt(2, bid);
        psLink.executeUpdate();
    }
    psLink.close();

    // 4️⃣ Update bookings as paid & booked
    PreparedStatement psUpd = conn.prepareStatement(
        "UPDATE bookings SET status='Booked', payment_status='Paid' WHERE booking_id IN (" + inClause + ")"
    );
    for (int i=0; i<bookingIds.size(); i++) psUpd.setInt(i+1, bookingIds.get(i));
    psUpd.executeUpdate();
    psUpd.close();

    // 5️⃣ Mark seats booked
    PreparedStatement psSeat = conn.prepareStatement(
        "UPDATE schedule_seats ss " +
        "JOIN bookings b ON ss.schedule_seat_id=b.schedule_seat_id " +
        "SET ss.is_booked=1 " +
        "WHERE b.booking_id IN (" + inClause + ")"
    );
    for (int i=0; i<bookingIds.size(); i++) psSeat.setInt(i+1, bookingIds.get(i));
    psSeat.executeUpdate();
    psSeat.close();

    conn.commit();

    // 6️⃣ PRG: redirect to success page (GET)
    String url = "paymentSuccess.jsp?txn=" + URLEncoder.encode(txnId, "UTF-8");
    response.sendRedirect(url);
    return;

} catch (Exception e) {
    if (conn != null) conn.rollback();
    out.println("<p style='color:red'>Payment Error: " + e.getMessage() + "</p>");
    e.printStackTrace();
} finally {
    if (conn != null) conn.setAutoCommit(true);
}
%>
