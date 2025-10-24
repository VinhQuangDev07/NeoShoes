<%-- 
    Document   : Manage-Categories
    Created on : 22-10-2025, 20:33:54
    Author     : Asus
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Category Management</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <style>
        :root {
            --header-h: 74px;
            --sidebar-w: 300px;
            --bg: #f5f6f8;
            --text: #111827;
            --line: #e5e7eb;
        }

        * {
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        html, body {
            height: 100%;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            padding-top: var(--header-h);
        }

        .wrap {
            padding: 20px 24px;
            max-width: 1400px;
            margin: 0 0 0 var(--sidebar-w);
        }

        .role-switcher {
            margin-bottom: 12px;
            padding: 10px 12px;
            background: #f3f4f6;
            border: 1px solid var(--line);
            border-radius: 10px;
        }

        .role-switcher a {
            margin-right: 12px;
            text-decoration: none;
            color: #2563eb;
            font-weight: 600;
        }

        .toolbar {
            margin: 14px 0 18px;
        }

        .btn-add {
            display: inline-block;
            padding: 10px 14px;
            border-radius: 10px;
            background: #111827;
            color: #fff;
            text-decoration: none;
            font-weight: 700;
            transition: .15s;
        }

        .btn-add:hover {
            filter: brightness(.9);
            transform: translateY(-1px);
            color: #fff;
        }

        .table-card {
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 20px rgba(17, 24, 39, .04);
        }

        .table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        colgroup col.col-id {
            width: 8%;
        }

        colgroup col.col-image {
            width: 15%;
        }

        colgroup col.col-name {
            width: auto;
        }

        colgroup col.col-status {
            width: 12%;
        }

        colgroup col.col-actions {
            width: 25%;
        }

        thead th {
            background: #111827;
            color: #fff;
            padding: 12px 14px;
            text-align: left;
            font-weight: 700;
            letter-spacing: .2px;
        }

        tbody td {
            padding: 12px 14px;
            border-top: 1px solid #f1f5f9;
            vertical-align: middle;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .image-box {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            border: 1px solid var(--line);
            border-radius: 10px;
            background: #fff;
            overflow: hidden;
        }

        .image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-active {
            background: #d1fae5;
            color: #065f46;
        }

        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }

        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
            padding: 9px 12px;
            border-radius: 10px;
            border: 1px solid transparent;
            text-decoration: none;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
            transition: .15s;
        }

        .btn-edit {
            background: #eef2ff;
            color: #3730a3;
            border-color: #c7d2fe;
        }

        .btn-edit:hover {
            background: #e0e7ff;
            transform: translateY(-1px);
            color: #3730a3;
        }

        .btn-toggle {
            background: #fef3c7;
            color: #92400e;
            border-color: #fde68a;
        }

        .btn-toggle:hover {
            background: #fde68a;
            transform: translateY(-1px);
            color: #92400e;
        }

        .btn-delete {
            background: #fef2f2;
            color: #991b1b;
            border-color: #fecaca;
        }

        .btn-delete:hover {
            background: #fee2e2;
            transform: translateY(-1px);
            color: #991b1b;
        }

        .empty {
            padding: 16px;
            color: #6b7280;
            background: #fff;
            border-top: 1px solid #f1f5f9;
            text-align: center;
        }

        @media (max-width: 992px) {
            :root {
                --sidebar-w: 0px;
            }
            .wrap {
                margin-left: 0;
                padding: 16px;
            }
            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

    <!-- Header & Sidebar -->
    <jsp:include page="common/staff-header.jsp"/>
    <jsp:include page="common/staff-sidebar.jsp"/>
    <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

    <div class="wrap">
        <!-- Role switch -->
        <div class="role-switcher">
            <strong>Current Role:</strong> <code>${userRole}</code> &nbsp;|&nbsp;
            <a href="<c:url value='/managecategoriesforstaff'><c:param name='role' value='admin'/></c:url>">Set as Admin</a>
            <a href="<c:url value='/managecategoriesforstaff'><c:param name='role' value='staff'/></c:url>">Set as Staff</a>
        </div>

        <!-- Toolbar -->
        <c:if test="${canModify}">  
            <div class="toolbar">
                <a class="btn-add" href="<c:url value='/managecategoriesforstaff/add'><c:param name='role' value='${userRole}'/></c:url>">
                    + Add New Category
                </a>
            </div>
        </c:if>

        <!-- Table -->
        <div class="table-card">
            <div class="table-scroll">
                <table>
                    <colgroup>
                        <col class="col-id"/>
                        <col class="col-image"/>
                        <col class="col-name"/>
                        <col class="col-status"/>
                        <c:if test="${canModify}"><col class="col-actions"/></c:if>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Category Name</th>
                            <th>Status</th>
                            <c:if test="${canModify}"><th>Actions</th></c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="category" items="${categories}">
                            <tr>
                                <td>${category.categoryId}</td>
                                <td>
                                    <c:if test="${not empty category.image}">
                                        <span class="image-box">
                                            <img src="${category.image}" alt="${category.name}">
                                        </span>
                                    </c:if>
                                </td>
                                <td title="${category.name}">${category.name}</td>
                                <td>
                                    <span class="status-badge ${category.isActive ? 'status-active' : 'status-inactive'}">
                                        ${category.isActive ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <c:if test="${canModify}">
                                    <td>
                                        <div class="actions">
                                            <a class="btn btn-edit"
                                               href="<c:url value='/managecategoriesforstaff/edit'>
                                                   <c:param name='id' value='${category.categoryId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>">
                                                <i data-lucide="edit-2" style="width:16px;height:16px"></i>
                                                Edit
                                            </a>

                                            <a class="btn btn-toggle"
                                               href="<c:url value='/managecategoriesforstaff/toggle-status'>
                                                   <c:param name='id' value='${category.categoryId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>">
                                                <i data-lucide="${category.isActive ? 'toggle-right' : 'toggle-left'}" style="width:16px;height:16px"></i>
                                                ${category.isActive ? 'Disable' : 'Enable'}
                                            </a>

                                            <a class="btn btn-delete"
                                               href="<c:url value='/managecategoriesforstaff/delete'>
                                                   <c:param name='id' value='${category.categoryId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>"
                                               onclick="return confirm('Are you sure you want to delete this category?');">
                                                <i data-lucide="trash-2" style="width:16px;height:16px"></i>
                                                Delete
                                            </a>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty categories}">
                <div class="empty">No categories found.</div>
            </c:if>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Active sidebar
            var el = document.getElementById('category');
            if (el) el.classList.add('active');

            // Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        });
    </script>
</body>
</html>
