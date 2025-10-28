package Utils;

import java.util.Properties;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Email Service for sending verification codes
 */
public class EmailService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    // ✅ THAY ĐỔI 2 DÒNG NÀY
    private static final String SMTP_USERNAME = "tangminhvinhquang@gmail.com";     // ← Email Gmail của bạn
    private static final String SMTP_PASSWORD = "hztmckyjlahylknm";           // ← App Password (bỏ dấu cách)

    /**
     * Send verification code via email
     */
    public static boolean sendVerificationCode(String toEmail, String customerName, String verificationCode) {
        
        System.out.println("🔄 Sending email to: " + toEmail);
        System.out.println("📧 From: " + SMTP_USERNAME);
        System.out.println("🔑 Code: " + verificationCode);
        
        try {
            // Setup SMTP properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            // Create session with authentication
            Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
                }
            });

            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USERNAME, "NeoShoes"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("NeoShoes - Email Verification Code");

            // HTML content
            String htmlContent = "<html>" +
                "<body style='font-family: Arial, sans-serif; padding: 20px; background: #f8f9fa;'>" +
                "  <div style='max-width: 600px; margin: 0 auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);'>" +
                "    <h2 style='color: #667eea; margin-bottom: 20px;'>Welcome to NeoShoes!</h2>" +
                "    <p>Hi <strong>" + customerName + "</strong>,</p>" +
                "    <p>Thank you for registering with NeoShoes. Your verification code is:</p>" +
                "    " +
                "    <div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; text-align: center; margin: 30px 0;'>" +
                "      <h1 style='margin: 0; font-size: 40px; letter-spacing: 10px; font-weight: bold;'>" + verificationCode + "</h1>" +
                "    </div>" +
                "    " +
                "    <p style='color: #ef4444; font-weight: bold;'>⏱️ This code will expire in 10 minutes.</p>" +
                "    " +
                "    <p style='color: #6b7280; font-size: 14px; margin-top: 30px;'>" +
                "      If you didn't create an account, please ignore this email." +
                "    </p>" +
                "    " +
                "    <hr style='border: none; border-top: 1px solid #e5e7eb; margin: 20px 0;'>" +
                "    " +
                "    <p style='color: #9ca3af; font-size: 12px; text-align: center;'>" +
                "      © 2024 NeoShoes. All rights reserved." +
                "    </p>" +
                "  </div>" +
                "</body>" +
                "</html>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            // Send email
            System.out.println("📤 Sending email...");
            Transport.send(message);

            System.out.println("✅ Email sent successfully to: " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("❌ MessagingException: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("❌ Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Generate random 6-digit verification code
     */
    public static String generateVerificationCode() {
        return String.valueOf(100000 + (int) (Math.random() * 900000));
    }

//    /**
//     * Test email configuration
//     */
//    public static void main(String[] args) {
//        System.out.println("🧪 Testing email service...");
//        
//        // ✅ THAY EMAIL TEST CỦA BẠN
//        String testEmail = "vinhuquangoker2004@gmail.com"; // ← Email nhận test
//        String testName = "Test User";
//        String testCode = generateVerificationCode();
//        
//        boolean sent = sendVerificationCode(testEmail, testName, testCode);
//        
//        if (sent) {
//            System.out.println("✅ Test email sent successfully!");
//        } else {
//            System.out.println("❌ Test email failed!");
//        }
//    }
}