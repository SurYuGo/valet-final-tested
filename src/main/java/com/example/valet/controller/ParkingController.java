package com.example.valet.controller;

import com.example.valet.model.Parking;
import com.example.valet.model.Payment;
import com.example.valet.repository.ParkingRepository;
import com.example.valet.repository.PaymentRepository;
import com.example.valet.service.PaymentGatewayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Controller
public class ParkingController {

    @Autowired
    private ParkingRepository parkingRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private PaymentGatewayService paymentGatewayService;

    @GetMapping({"/","/index"})
    public String index(Model model) {
        model.addAttribute("parkings", parkingRepository.findAll());
        return "index";
    }

    @PostMapping("/entry")
    public String entry(@RequestParam(required=false) String plate) {
        String id = UUID.randomUUID().toString();
        Parking p = new Parking();
        p.setId(id);
        p.setPlate(plate == null ? "UNKNOWN" : plate);
        p.setEntryTime(Instant.now());
        parkingRepository.save(p);
        return "redirect:/index";
    }

    @PostMapping("/exit/{parkingId}")
    public String exit(@PathVariable String parkingId, Model model) {
        Optional<Parking> opt = parkingRepository.findById(parkingId);
        if (opt.isEmpty()) {
            model.addAttribute("error", "Parking not found");
            return "index";
        }
        Parking p = opt.get();
        p.setExitTime(Instant.now());
        int fee = calculateFee(p.getEntryTime(), p.getExitTime());
        p.setFee(fee);
        String paymentId = "pay-" + UUID.randomUUID().toString();
        p.setPaymentId(paymentId);
        parkingRepository.save(p);

        Payment pay = new Payment();
        pay.setId(paymentId);
        pay.setParkingId(parkingId);
        pay.setAmount(fee);
        pay.setStatus("pending");
        pay.setCreatedAt(Instant.now());

        Map<String,Object> resp = paymentGatewayService.createQrisPayment(paymentId, fee);
        Object qris = resp.get("qris");
        if (qris instanceof Map) {
            Map<?,?> m = (Map<?,?>) qris;
            Object dataUrl = m.get("qr_data_url"); // data:image/png;base64,...
            if (dataUrl != null) pay.setQrUrl(dataUrl.toString());
        }

        pay.setRawResponse(resp.toString());
        paymentRepository.save(pay);

        model.addAttribute("payment", pay);
        model.addAttribute("parking", p);
        return "payment";
    }

    @GetMapping("/payment/{paymentId}")
    public String payment(@PathVariable String paymentId, Model model) {
        Optional<Payment> p = paymentRepository.findById(paymentId);
        if (p.isEmpty()) {
            model.addAttribute("error", "Payment not found");
            return "payment";
        }
        Payment pay = p.get();
        model.addAttribute("payment", pay);
        model.addAttribute("qrUrl", pay.getQrUrl() != null ? pay.getQrUrl() : "/static/images/dummy_qr.png");
        return "payment";
    }

    private int calculateFee(Instant entry, Instant exit) {
        long seconds = Math.max(0, exit.getEpochSecond() - entry.getEpochSecond());
        long hours = Math.max(1, (seconds + 3599) / 3600);
        return (int)(hours * 5000);
    }
}
