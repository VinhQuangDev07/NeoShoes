
package Controllers.Customer;

import DAOs.AddressDAO;
import Models.Address;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet(name = "AddressServlet", urlPatterns = {"/address"})
public class AddressServlet extends HttpServlet {

    

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        String addressAction = request.getParameter("addressAction");
//        AddressDAO addressDAO = new AddressDAO();
//        if (addressAction.equals("newAddress")) {
//            request.getRequestDispatcher("/WEB-INF/views/customer/address/add.jsp").forward(request, response);
//        }
//        if (addressAction.equals("editAddress")) {
//
//            try {
//                int addressId = Integer.parseInt(request.getParameter("addressId"));
//                Address address;
//                address = addressDAO.getAddressById(addressId);
//                request.setAttribute("address", address);
//                request.getRequestDispatcher("/WEB-INF/views/customer/address/edit.jsp")
//                        .forward(request, response);
//            } catch (SQLException ex) {
//                Logger.getLogger(AddressServlet.class.getName()).log(Level.SEVERE, null, ex);
//            }
//
//        }
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
        AddressDAO addressDAO = new AddressDAO();
        String addressAction = request.getParameter("addressAction");
        if ("addAddress".equals(addressAction)) {
            try {
             int customerId = Integer.parseInt(request.getParameter("customerId"));
//                int customerId = 2;
                String addressName = request.getParameter("addressName");
                String addressDetails = request.getParameter("addressDetails");
                String recipientName = request.getParameter("recipientName");
                String recipientPhone = request.getParameter("recipientPhone");

                // Kiểm tra đã có địa chỉ nào chưa
                List<Address> existing = addressDAO.getAllAddressByCustomerId(customerId);

                boolean isDefault;
                if (existing == null || existing.isEmpty()) {
                    // nếu chưa có địa chỉ -> luôn mặc định
                    isDefault = true;
                } else {
                    // nếu đã có -> lấy từ checkbox
                    isDefault = "true".equals(request.getParameter("isDefault"));
                }
                boolean isDeleted = false;
                // Nếu set default thì cập nhật các address cũ về false
                if (isDefault) {
                    addressDAO.clearDefaultAddress(customerId);
                }
                // Thêm địa chỉ mới
                addressDAO.addAddress(customerId, addressName, addressDetails,
                        recipientName, recipientPhone, isDefault, isDeleted);

                response.sendRedirect(request.getContextPath() + "/profile?id="+customerId);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(500, "Error adding address");
            }
        }
        if ("deleteAddress".equals(addressAction)) {
            try {
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                Address address = addressDAO.getAddressById(addressId);
                if (address.isIsDefault()) {
                    request.setAttribute("erroMassage", "Can not delete default address!");
                    response.sendRedirect(request.getContextPath() + "/profile?id="+customerId);
                } else {
                    addressDAO.delete(addressId);
                    response.sendRedirect(request.getContextPath() + "/profile?id="+customerId);
                }
            } catch (SQLException ex) {
                Logger.getLogger(AddressServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if ("updateAddress".equals(addressAction)) {
            try {
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                int addressId = Integer.parseInt(request.getParameter("addressId"));
//               int customerId = Integer.parseInt(request.getParameter("customerId"));
                //int customerId = 2;
                String addressName = request.getParameter("addressName");
                String addressDetails = request.getParameter("addressDetails");
                String recipientName = request.getParameter("recipientName");
                String recipientPhone = request.getParameter("recipientPhone");
                boolean isDefault = request.getParameter("isDefault") != null;
                Address currentAddress = addressDAO.getAddressById(addressId);
                if (currentAddress.isIsDefault()) {
                    isDefault = true;
                }
                if (isDefault) {
                    addressDAO.clearDefaultAddress(customerId);
                }
                addressDAO.updateAddress(addressId, addressName, addressDetails, recipientName, recipientPhone, isDefault);
                response.sendRedirect(request.getContextPath() + "/profile?id="+customerId);
            } catch (SQLException ex) {
                Logger.getLogger(AddressServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

   

}
