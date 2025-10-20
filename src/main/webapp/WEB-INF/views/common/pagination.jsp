
<%
    // Get parameters from request
    int currentPage = request.getParameter("page") != null ? 
        Integer.parseInt(request.getParameter("page")) : 1;
    int totalRecords = (Integer) request.getAttribute("totalRecords");
    int recordsPerPage = (Integer) request.getAttribute("recordsPerPage");
    String baseUrl = (String) request.getAttribute("baseUrl");
    
    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages) currentPage = totalPages;
%>

<div class="pagination-container">
    <div class="pagination-info">
        <p>Total: <strong><%= totalRecords %></strong> records | 
            Page <strong><%= currentPage %></strong>/<strong><%= totalPages %></strong></p>
    </div>

    <c:if test="${totalPages > 1}">
        <nav aria-label="Pagination">
            <ul class="pagination">
                <!-- First Page Button -->
                <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                    <a class="page-link" href="<%= currentPage == 1 ? '#' : baseUrl + "?page=1" %>" 
                       aria-label="First page">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                <!-- Previous Page Button -->
                <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                    <a class="page-link" href="<%= currentPage == 1 ? '#' : baseUrl + "?page=" + (currentPage - 1) %>" 
                       aria-label="Previous page">
                        <span aria-hidden="true">&lsaquo;</span>
                    </a>
                </li>

                <!-- Page buttons -->
                <%
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);

                    // Show first page and "..." if needed
                    if (startPage > 1) {
                        out.print("<li class='page-item'><a class='page-link' href='" + baseUrl + "?page=1'>1</a></li>");
                        if (startPage > 2) {
                            out.print("<li class='page-item disabled'><span class='page-link'>...</span></li>");
                        }
                    }

                    // Loop for visible pages around current page
                    for (int i = startPage; i <= endPage; i++) {
                        if (i == currentPage) {
                            out.print("<li class='page-item active'><span class='page-link'>" + i +
                                     "<span class='sr-only'>(current)</span></span></li>");
                        } else {
                            out.print("<li class='page-item'><a class='page-link' href='" + baseUrl +
                                     "?page=" + i + "'>" + i + "</a></li>");
                        }
                    }

                    // Show last page and "..." if needed
                    if (endPage < totalPages) {
                        if (endPage < totalPages - 1) {
                            out.print("<li class='page-item disabled'><span class='page-link'>...</span></li>");
                        }
                        out.print("<li class='page-item'><a class='page-link' href='" + baseUrl +
                                 "?page=" + totalPages + "'>" + totalPages + "</a></li>");
                    }
                %>


                <!-- Next Page Button -->
                <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                    <a class="page-link" href="<%= currentPage == totalPages ? '#' : baseUrl + "?page=" + (currentPage + 1) %>" 
                       aria-label="Next page">
                        <span aria-hidden="true">&rsaquo;</span>
                    </a>
                </li>

                <!-- Last Page Button -->
                <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                    <a class="page-link" href="<%= currentPage == totalPages ? '#' : baseUrl + "?page=" + totalPages %>" 
                       aria-label="Last page">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<style>
    .pagination-container {
        margin-top: 30px;
        text-align: center;
    }

    .pagination-info {
        margin-bottom: 20px;
        color: #666;
        font-size: 14px;
    }

    .pagination {
        display: inline-flex;
        list-style: none;
        padding: 0;
        gap: 5px;
        flex-wrap: wrap;
        justify-content: center;
    }

    .page-item {
        display: inline-block;
    }

    .page-link {
        display: inline-block;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        color: #0066cc;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .page-link:hover:not(.disabled .page-link) {
        background-color: #f5f5f5;
        border-color: #0066cc;
    }

    .page-item.active .page-link {
        background-color: #0066cc;
        border-color: #0066cc;
        color: white;
        cursor: default;
    }

    .page-item.disabled .page-link {
        color: #999;
        border-color: #ddd;
        cursor: not-allowed;
        background-color: #f9f9f9;
    }

    .sr-only {
        display: none;
    }
</style>