<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Brand Management</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            :root{
                --header-h:74px;   /* chiều cao header cố định (staff-header.jsp) */
                --sidebar-w:300px; /* chiều rộng sidebar cố định (staff-sidebar.jsp) */
                --bg:#f5f6f8;
                --text:#111827;
                --line:#e5e7eb;
            }

            *{
                box-sizing:border-box;
                font-family:Arial, Helvetica, sans-serif;
            }
            html,body{
                height:100%;
            }
            body{
                margin:0;
                background:var(--bg);
                color:var(--text);
                padding-top:var(--header-h); /* bù header fixed */
            }

            /* CONTENT WRAP */
            .wrap{
                padding:20px 24px;
                max-width:1200px;
                margin:0 0 0 var(--sidebar-w); /* bù sidebar fixed */
            }

            /* Role switch + toolbar */
            .role-switcher{
                margin-bottom:12px;
                padding:10px 12px;
                background:#f3f4f6;
                border:1px solid var(--line);
                border-radius:10px;
            }
            .role-switcher a{
                margin-right:12px;
                text-decoration:none;
                color:#2563eb;
                font-weight:600;
            }
            .toolbar{
                margin:14px 0 18px;
            }
            .btn-add{
                display:inline-block;
                padding:10px 14px;
                border-radius:10px;
                background:#111827;
                color:#fff;
                text-decoration:none;
                font-weight:700;
                transition:.15s;
            }
            .btn-add:hover{
                filter:brightness(.9);
                transform:translateY(-1px);
            }

            /* Table card + responsive scroll */
            .table-card{
                background:#fff;
                border:1px solid var(--line);
                border-radius:12px;
                overflow:hidden;
                box-shadow:0 10px 20px rgba(17,24,39,.04);
            }
            .table-scroll{
                width:100%;
                overflow-x:auto;
            }

            table{
                width:100%;
                border-collapse:collapse;
                table-layout:fixed;
            }
            colgroup col.col-id{
                width:12%;
            }
            colgroup col.col-name{
                width:auto;
            }  /* chiếm phần còn lại */
            colgroup col.col-logo{
                width:18%;
            }
            colgroup col.col-actions{
                width:22%;
            }

            thead th{
                background:#111827;
                color:#fff;
                padding:12px 14px;
                text-align:left;
                font-weight:700;
                letter-spacing:.2px;
            }
            tbody td{
                padding:12px 14px;
                border-top:1px solid #f1f5f9;
                vertical-align:middle;
                overflow:hidden;
                text-overflow:ellipsis;
                white-space:nowrap;
            }

            /* Logo cell */
            .logo-box{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                width:56px;
                height:56px;
                border:1px solid var(--line);
                border-radius:10px;
                background:#fff;
            }
            .logo-box img{
                max-width:52px;
                max-height:52px;
                border-radius:8px;
            }

            /* Action buttons */
            .actions{
                display:flex;
                gap:10px;
            }
            .btn{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                padding:9px 12px;
                border-radius:10px;
                border:1px solid transparent;
                text-decoration:none;
                cursor:pointer;
                font-weight:700;
                font-size:14px;
                transition:.15s;
            }
            .btn-edit{
                background:#eef2ff;
                color:#3730a3;
                border-color:#c7d2fe;
            }
            .btn-edit:hover{
                background:#e0e7ff;
                transform:translateY(-1px);
            }
            .btn-delete{
                background:#fef2f2;
                color:#991b1b;
                border-color:#fecaca;
            }
            .btn-delete:hover{
                background:#fee2e2;
                transform:translateY(-1px);
            }

            .empty{
                padding:16px;
                color:#6b7280;
                background:#fff;
                border-top:1px solid #f1f5f9;
            }

            /* Responsive */
            @media (max-width:992px){
                :root{
                    --sidebar-w:0px;
                }        /* ẩn/thu gọn sidebar -> nội dung full width */
                .wrap{
                    margin-left:0;
                    padding:16px;
                }
                colgroup col.col-id{
                    width:18%;
                }
                colgroup col.col-logo{
                    width:22%;
                }
                colgroup col.col-actions{
                    width:30%;
                }
                .actions{
                    flex-wrap:wrap;
                }
            }


        </style>
    </head>
    <body>

        <!-- Header & Sidebar cố định -->
        <jsp:include page="common/staff-header.jsp"/>
        <jsp:include page="common/staff-sidebar.jsp"/>

        <!-- Nội dung -->
        <div class="wrap">

            <!-- Role switch (demo) -->
            <div class="role-switcher">
                <strong>Current Role:</strong> <code>${userRole}</code> &nbsp;|&nbsp;
                <a href="<c:url value='/managebrands'><c:param name='role' value='admin'/></c:url>">Set as Admin</a>
                <a href="<c:url value='/managebrands'><c:param name='role' value='staff'/></c:url>">Set as Staff</a>
                </div>

                <!-- Nút Add chỉ hiển thị khi có quyền sửa đổi -->
            <c:if test="${canModify}">
                <div class="toolbar">
                    <a class="btn-add" href="<c:url value='/managebrands/add'><c:param name='role' value='${userRole}'/></c:url>">+ Add New Brand</a>
                    </div>
            </c:if>

            <div class="table-card">
                <div class="table-scroll"><!-- responsive container -->
                    <table>
                        <colgroup>
                            <col class="col-id"/>
                            <col class="col-name"/>
                            <col class="col-logo"/>
                            <c:if test="${canModify}"><col class="col-actions"/></c:if>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Logo</th>
                                <c:if test="${canModify}"><th>Actions</th></c:if>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="brand" items="${brands}">
                                <tr>
                                    <td>${brand.brandId}</td>
                                    <td title="${brand.name}">${brand.name}</td>
                                    <td>
                                        <c:if test="${not empty brand.logo}">
                                            <span class="logo-box">
                                                <img src="${brand.logo}" alt="${brand.name} logo">
                                            </span>
                                        </c:if>
                                    </td>
                                    <c:if test="${canModify}">
                                        <td>
                                            <div class="actions">
                                                <a class="btn btn-edit"
                                                   href="<c:url value='/managebrands/edit'>
                                                       <c:param name='id' value='${brand.brandId}'/>
                                                       <c:param name='role' value='${userRole}'/>
                                                   </c:url>">Edit</a>

                                                <a class="btn btn-delete"
                                                   href="<c:url value='/managebrands/delete'>
                                                       <c:param name='id' value='${brand.brandId}'/>
                                                       <c:param name='role' value='${userRole}'/>
                                                   </c:url>"
                                                   onclick="return confirm('Are you sure you want to delete this brand?');">Delete</a>
                                            </div>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty brands}">
                    <div class="empty">No brands found.</div>
                </c:if>
            </div>

        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                             // Initialize Lucide icons
                             lucide.createIcons();

        </script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // đánh dấu sidebar item Brands đang active
                var el = document.getElementById('brand');
                if (el)
                    el.classList.add('active');

                // lucide icons (nếu có)
                if (typeof lucide !== 'undefined' && typeof lucide.createIcons === 'function') {
                    lucide.createIcons();
                }
            });
        </script>
    </body>
</html>
