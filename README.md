Valet Final Tested - Spring Boot WAR (ZXing QR generation)

This project generates QR images on the server (base64 embedded as data URL)
so the QR always displays in the JSP without external hosting.

How to run locally:
1. Extract the zip.
2. In Eclipse: File -> Import -> Existing Maven Projects -> select extracted folder.
3. Update src/main/resources/application.properties with your MySQL credentials.
4. Create database 'valetdb' (use src/main/resources/schema.sql).
5. Build project: mvn clean package
6. Deploy target/valet-final-tested.war to external Tomcat (or run via IDE as Spring Boot app).
7. Open http://localhost:8080/valet-final-tested/ and test Entry -> Request Exit -> Pay.

How it works:
- When you click 'Request Exit' the controller creates a Payment record and calls PaymentGatewayService.
- PaymentGatewayService uses ZXing to build a PNG QR, encodes to base64 and sets payment.qrUrl to 'data:image/png;base64,...'.
- JSP renders <img src="${qrUrl}"> which displays QR inline.

Notes:
- I cannot run Tomcat here, so please run locally. If QR doesn't show, check that payment.qr_url column contains a long string starting with 'data:image/png;base64,'.
