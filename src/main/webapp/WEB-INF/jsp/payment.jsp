<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Payment</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>body{background:#0f1724;color:#e6eef8;padding:30px}.btn-gold{background:#f6c85f;color:#0b1220}</style>
</head>
<body>
<div class="container">
  <div class="card p-4">
    <h3>Payment</h3>
    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>
    <p>Order: ${payment.id}</p>
    <p>Amount: ${payment.amount}</p>
    <p>Status: ${payment.status}</p>
    <p>QR:</p>

    <c:choose>
      <c:when test="${not empty qrUrl}">
        <img src="${qrUrl}" alt="QR" style="max-width:220px;background:#fff;padding:8px;border-radius:8px">
      </c:when>
      <c:otherwise>
        <p style="color:red;">QR not available</p>
      </c:otherwise>
    </c:choose>

    <p class="mt-3"><a class="btn btn-gold" href="${pageContext.request.contextPath}/index">Back</a></p>
  </div>
</div>
</body>
</html>
