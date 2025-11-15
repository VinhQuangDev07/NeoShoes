package Controllers.Customer;

import DAOs.AddressDAO;
import Models.Address;
import Models.Customer;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AddressServlet", urlPatterns = {"/address"})
public class AddressServlet extends HttpServlet {

    private AddressDAO addressDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        addressDAO = new AddressDAO();
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int loggedInUserId = customer.getId(); // ✅ Lấy ID từ customer

        String addressAction = request.getParameter("addressAction");
        if ("addAddress".equals(addressAction)) {
            try {
                // Validation
                int customerId = validateCustomerId(request, loggedInUserId);
                String addressName = validateRequired(request.getParameter("addressName"), "Address name", 100);
                String addressDetails = validateRequired(request.getParameter("addressDetails"), "Address details", 500);
                String recipientName = validateRequired(request.getParameter("recipientName"), "Recipient name", 100);
                String recipientPhone = validatePhone(request.getParameter("recipientPhone"));

                // Check if first address
                List<Address> existing = addressDAO.getAllAddressByCustomerId(customerId);
                boolean isDefault = (existing == null || existing.isEmpty())
                        || "true".equals(request.getParameter("isDefault"));

                if (isDefault) {
                    addressDAO.clearDefaultAddress(customerId);
                }

                addressDAO.addAddress(customerId, addressName, addressDetails,
                        recipientName, recipientPhone, isDefault, false);

                // Use session for success message
                request.getSession().setAttribute("flash", "Address added successfully!");
                response.sendRedirect(request.getContextPath() + "/profile");

            } catch (ValidationException e) {
                request.getSession().setAttribute("errorMessage", e.getMessage());
                response.sendRedirect(request.getContextPath() + "/profile?id=" + loggedInUserId);
            } catch (SQLException e) {
                Logger.getLogger(AddressServlet.class.getName()).log(Level.SEVERE, "Error adding address", e);
                request.getSession().setAttribute("flash_error", "System error. Please try again.");
                response.sendRedirect(request.getContextPath() + "/profile?id=" + loggedInUserId);
            }
        }
        else if ("deleteAddress".equals(addressAction)) {
            try {
                int customerId = validateCustomerId(request, loggedInUserId);
                int addressId = validateInteger(request.getParameter("addressId"), "Address ID");

                Address address = addressDAO.getAddressById(addressId);

                // Security: Check ownership
                if (address == null || address.getCustomerId() != customerId) {
                    response.sendError(403, "Access denied");
                    return;
                }

                if (address.isIsDefault()) {
                    request.getSession().setAttribute("flash_error", "Cannot delete default address! Please set another address as default first.");
                    response.sendRedirect(request.getContextPath() + "/profile?id=" + customerId);
                    return;
                }

                addressDAO.delete(addressId, customerId);
                request.getSession().setAttribute("flash", "Address deleted successfully!");
                response.sendRedirect(request.getContextPath() + "/profile?id=" + customerId);

            } catch (ValidationException e) {
                request.getSession().setAttribute("flash_error", e.getMessage());
                response.sendRedirect(request.getContextPath() + "/profile?id=" + loggedInUserId);
            } catch (SQLException e) {
                Logger.getLogger(AddressServlet.class.getName()).log(Level.SEVERE, "Error deleting address", e);
                request.getSession().setAttribute("flash_error", "System error. Please try again.");
                response.sendRedirect(request.getContextPath() + "/profile?id=" + loggedInUserId);
            }
        }
        else if ("updateAddress".equals(addressAction)) {
            try {
                int customerId = validateCustomerId(request, loggedInUserId);
                int addressId = validateInteger(request.getParameter("addressId"), "Address ID");

                Address currentAddress = addressDAO.getAddressById(addressId);

                // Security: Check ownership
                if (currentAddress == null || currentAddress.getCustomerId() != customerId) {
                    response.sendError(403, "Access denied");
                    return;
                }

                String addressName = validateRequired(request.getParameter("addressName"), "Address name", 100);
                String addressDetails = validateRequired(request.getParameter("addressDetails"), "Address details", 500);
                String recipientName = validateRequired(request.getParameter("recipientName"), "Recipient name", 100);
                String recipientPhone = validatePhone(request.getParameter("recipientPhone"));

                // If current is default, cannot unset
                boolean isDefault = currentAddress.isIsDefault()
                        || "true".equals(request.getParameter("isDefault"));

                if (isDefault && !currentAddress.isIsDefault()) {
                    addressDAO.clearDefaultAddress(customerId);
                }

                addressDAO.updateAddress(addressId, customerId, addressName, addressDetails, recipientName, recipientPhone, isDefault);

                request.getSession().setAttribute("flash", "Address updated successfully!");
                response.sendRedirect(request.getContextPath() + "/profile?id=" + customerId);

            } catch (ValidationException e) {
                request.getSession().setAttribute("flash_error", e.getMessage());
                response.sendRedirect(request.getContextPath() + "/profile?id=" + loggedInUserId);
            } catch (SQLException e) {
                Logger.getLogger(AddressServlet.class.getName()).log(Level.SEVERE, "Error updating address", e);
                request.getSession().setAttribute("flash_error", "System error. Please try again.");
                response.sendRedirect(request.getContextPath() + "/profile?id=" + loggedInUserId);
            }
        }
    }

    // Validation methods
    private int validateCustomerId(HttpServletRequest request, int loggedInUserId) throws ValidationException {
        String customerIdStr = request.getParameter("customerId");
        if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
            throw new ValidationException("Customer ID is required");
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            // Security: Only allow user to manage their own addresses
            if (customerId != loggedInUserId) {
                throw new ValidationException("Access denied");
            }
            return customerId;
        } catch (NumberFormatException e) {
            throw new ValidationException("Invalid customer ID");
        }
    }

    private int validateInteger(String value, String fieldName) throws ValidationException {
        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException(fieldName + " is required");
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new ValidationException("Invalid " + fieldName);
        }
    }

    private String validateRequired(String value, String fieldName, int maxLength) throws ValidationException {
        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException(fieldName + " is required");
        }
        value = value.trim();
        if (value.length() > maxLength) {
            throw new ValidationException(fieldName + " must not exceed " + maxLength + " characters");
        }
        // Basic XSS protection
        value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        return value;
    }

    private String validatePhone(String phone) throws ValidationException {
        if (phone == null || phone.trim().isEmpty()) {
            throw new ValidationException("Phone number is required");
        }
        phone = phone.trim().replaceAll("\\s+", "");

        // Vietnamese phone validation: 10-11 digits, starts with 0
        if (!phone.matches("^0\\d{9,10}$")) {
            throw new ValidationException("Invalid phone number format");
        }
        return phone;
    }

// Custom exception
    class ValidationException extends Exception {

        public ValidationException(String message) {
            
            super(message);
        }

    }
}