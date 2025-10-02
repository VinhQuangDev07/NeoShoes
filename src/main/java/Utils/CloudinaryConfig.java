/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class CloudinaryConfig {
    
    private static Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "drqip0exk",
                "api_key", "562633272677887",
                "api_secret", "kaVK2g4CzpsJ3YCah2mAgzr7zMY",
                "secure", true
        ));
    }

    public static Cloudinary getCloudinary() {
        return cloudinary;
    }
    
    public static List<String> uploadImages(Collection<Part> imageParts) throws IOException {
        List<String> imageUrls = new ArrayList<>();

        for (Part part : imageParts) {
            if (part.getSubmittedFileName() != null && part.getSize() > 0) {
                try ( InputStream inputStream = part.getInputStream();  ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {

                    byte[] data = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, bytesRead);
                    }

                    byte[] imageBytes = buffer.toByteArray();

                    Map<String, Object> options = new HashMap<>();
                    options.put("resource_type", "auto");
                    options.put("public_id", part.getSubmittedFileName());

                    Map<?, ?> uploadResult = cloudinary.uploader().upload(imageBytes, options);

                    String secureUrl = (String) uploadResult.get("secure_url");
                    imageUrls.add(secureUrl);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        return imageUrls;
    }

    public static String uploadSingleImage(Part imagePart) throws IOException {
        if (imagePart != null && imagePart.getSize() > 0) {
            try ( InputStream inputStream = imagePart.getInputStream();  ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {

                byte[] data = new byte[1024];
                int bytesRead;
                while ((bytesRead = inputStream.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, bytesRead);
                }

                byte[] imageBytes = buffer.toByteArray();

                Map<String, Object> options = new HashMap<>();
                options.put("resource_type", "auto");
                options.put("public_id", "brand_" + System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName());

                Map<?, ?> uploadResult = cloudinary.uploader().upload(imageBytes, options);

                String secureUrl = (String) uploadResult.get("secure_url");
                return secureUrl;

            } catch (Exception e) {
                e.printStackTrace();
                throw new IOException("Error uploading image: " + e.getMessage());
            }
        }
        return null;
    }
    
}
