<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Valet Parking - Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background:#0f1724; color:#e6eef8; font-family: 'Poppins', sans-serif; padding:30px; }
    .card { border-radius:12px; border:none; background: linear-gradient(180deg,#0b1220,#0f1724); box-shadow: 0 6px 18px rgba(2,6,23,0.6); }
    .brand { color:#f6c85f; font-weight:700; }
    .btn-gold { background:#f6c85f; color:#0b1220; font-weight:700; border-radius:10px; }
    table th { background: rgba(255,255,255,0.03); color:#cfe3ff; }
    a.btn { text-decoration:none; }
  </style>
</head>
<body>
<div class="container">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="brand">Valet Parking</h1>
    <div>
      <small class="text-muted">Premium</small>
    </div>
  </div>

  <div class="card p-4 mb-4">
    <h4>New Entry</h4>
    <form action="${pageContext.request.contextPath}/entry" method="post" class="row g-2">
      <div class="col-auto">
        <input class="form-control form-control-lg" name="plate" placeholder="Plate number (e.g. B1234XYZ)" required>
      </div>
      <div class="col-auto">
        <button class="btn btn-gold btn-lg" type="submit">Entry</button>
      </div>
    </form>
  </div>

  <div class="card p-4">
    <h4>Active Parkings</h4>
    <div class="table-responsive mt-3">
      <table class="table table-borderless text-light align-middle">
        <thead>
          <tr>
            <th>ID</th><th>Plate</th><th>Entry</th><th>Exit</th><th>Fee</th><th>Paid</th><th>Action</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="p" items="${parkings}">
            <tr>
              <td style="max-width:180px; word-break:break-all">${p.id}</td>
              <td>${p.plate}</td>
              <td>${p.entryTime}</td>
              <td><c:out value='${p.exitTime}'/></td>
              <td><c:out value='${p.fee}'/></td>
              <td><c:choose><c:when test='${p.paid}'>Yes</c:when><c:otherwise>No</c:otherwise></c:choose></td>
              <td>
                <c:if test='${empty p.exitTime}'>
                    <form action="${pageContext.request.contextPath}/exit/${p.id}" method="post" style="display:inline">
                      <button class="btn btn-outline-light btn-sm">Request Exit</button>
                    </form>
                </c:if>
                <c:if test='${not empty p.paymentId}'>
                  <a class="btn btn-gold btn-sm" href="${pageContext.request.contextPath}/payment/${p.paymentId}">Pay</a>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
