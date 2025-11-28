package com.example.valet.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.stereotype.Service;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.time.Instant;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Service
public class PaymentGatewayService {

    public Map<String,Object> createQrisPayment(String orderId, int amount) {
        Map<String,Object> resp = new HashMap<>();
        resp.put("order_id", orderId);
        resp.put("amount", amount);

        try {
            String data = "PAY:" + orderId + ":" + amount + ":valet";
            QRCodeWriter qrWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrWriter.encode(data, BarcodeFormat.QR_CODE, 300, 300);
            BufferedImage image = MatrixToImageWriter.toBufferedImage(bitMatrix);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            javax.imageio.ImageIO.write(image, "PNG", baos);
            String base64 = Base64.getEncoder().encodeToString(baos.toByteArray());
            String dataUrl = "data:image/png;base64," + base64;

            Map<String,Object> qris = new HashMap<>();
            qris.put("qr_string", base64);
            qris.put("qr_data_url", dataUrl);

            resp.put("qris", qris);
            resp.put("status", "pending");
            resp.put("created_at", Instant.now().toString());
            resp.put("ok", true);
        } catch (WriterException we) {
            resp.put("ok", false);
            resp.put("error", we.getMessage());
        } catch (Exception e) {
            resp.put("ok", false);
            resp.put("error", e.getMessage());
        }
        return resp;
    }
}
