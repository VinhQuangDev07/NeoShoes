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
    private static final String SMTP_USERNAME = "tangminhvinhquang@gmail.com";
    private static final String SMTP_PASSWORD = "hztmckyjlahylknm";

    /**
     * Send verification code via email
     */
    public static boolean sendVerificationCode(String toEmail, String customerName, String verificationCode) {
        
        System.out.println("Sending email to: " + toEmail);
        System.out.println("From: " + SMTP_USERNAME);
        System.out.println("Code: " + verificationCode);
        
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
            System.out.println("Sending email...");
            Transport.send(message);

            System.out.println("Email sent successfully to: " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("MessagingException: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Failed to send email: " + e.getMessage());
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

    /**
     * Send password reset OTP email
     */
    public static boolean sendPasswordResetOTP(String toEmail, String customerName, String otp) {
        System.out.println("Sending password reset OTP to: " + toEmail);
        System.out.println("OTP: " + otp);
        
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USERNAME, "NeoShoes"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("OTP Code Reset Password - NeoShoes");

            String htmlContent = "<html>" +
                "<body style='font-family: Arial, sans-serif; padding: 20px; background: #f8f9fa;'>" +
                "  <div style='max-width: 600px; margin: 0 auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);'>" +
                "    <h2 style='color: #667eea; margin-bottom: 20px;'>Reset Password</h2>" +
                "    <p>Hello <strong>" + customerName + "</strong>,</p>" +
                "    <p>You have requested to reset your password. Your OTP code is:</p>" +
                "    <div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; text-align: center; margin: 30px 0;'>" +
                "      <h1 style='margin: 0; font-size: 40px; letter-spacing: 10px; font-weight: bold;'>" + otp + "</h1>" +
                "    </div>" +
                "    <p style='color: #ef4444; font-weight: bold;'>This code will expire in 10 minutes.</p>" +
                "    <p style='color: #6b7280; font-size: 14px; margin-top: 30px;'>If you did not request a password reset, please ignore this email.</p>" +
                "    <hr style='border: none; border-top: 1px solid #e5e7eb; margin: 20px 0;'>" +
                "    <p style='color: #9ca3af; font-size: 12px; text-align: center;'>© 2024 NeoShoes. All rights reserved.</p>" +
                "  </div>" +
                "</body>" +
                "</html>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            System.out.println("Sending password reset OTP email...");
            Transport.send(message);
            System.out.println("Password reset OTP sent successfully to: " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("MessagingException: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Failed to send password reset OTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}