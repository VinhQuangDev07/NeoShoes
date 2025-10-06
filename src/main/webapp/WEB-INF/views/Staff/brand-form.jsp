<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${formAction == 'update'}">Edit Brand</c:when>
            <c:otherwise>Add New Brand</c:otherwise>
        </c:choose>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { box-sizing: border-box; }

        /* Căn giữa form theo cả trục dọc & ngang */
        body {
            margin: 0;
            padding: 24px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: Arial, Helvetica, sans-serif;
            min-height: 100vh;
            display: flex;                /* NEW */
            align-items: center;          /* NEW */
            justify-content: center;      /* NEW */
        }

        /* Form chiếm full chiều ngang nhưng giới hạn độ rộng để nhìn gọn */
        .container {
            width: 100%;                  /* NEW */
            max-width: 960px;             /* NEW: muốn rộng hơn thì tăng số này */
            margin: 0 auto;
        }

        .card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,.1);
        }

        /* Header màu đen */
        .card-head {
            padding: 20px 24px;
            color: #fff;
            background: #000 !important;   /* NEW: đổi header sang đen */
        }
        .card-head h1 { margin: 0; font-size: 22px; font-weight: 600; }

        .card-body { padding: 24px; }
        .form-group { margin-bottom: 18px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; color: #344054; }
        .form-control {
            width: 100%; padding: 12px 14px; border: 1px solid #d0d5dd; border-radius: 8px;
            font-size: 15px; outline: none; transition: .2s;
        }
        .form-control:focus { border-color: #111; box-shadow: 0 0 0 3px rgba(0,0,0,.12); }
        .hint { color: #667085; font-size: 13px; margin-top: 6px; }
        .preview { margin-top: 10px; }
        .preview img { max-width: 96px; max-height: 96px; border: 1px solid #eee; border-radius: 8px; }
        .actions { display: flex; gap: 12px; margin-top: 16px; }
        .btn {
            display: inline-block; padding: 10px 16px; border-radius: 8px;
            text-decoration: none; border: none; cursor: pointer; font-weight: 600;
            transition: .15s;
        }
        .btn-primary { background: #12b76a; color: #fff; }
        .btn-primary:hover { filter: brightness(0.95); transform: translateY(-1px); }
        .btn-secondary { background: #f2f4f7; color: #344054; }
        .btn-secondary:hover { background: #e6e9ef; transform: translateY(-1px); }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-head">
            <h1>
                <c:choose>
                    <c:when test="${formAction == 'update'}">Edit Brand</c:when>
                    <c:otherwise>Add New Brand</c:otherwise>
                </c:choose>
            </h1>
        </div>
        <div class="card-body">
            <form
                action="<c:url value='/managebrands/${formAction}'><c:param name='role' value='${userRole}'/></c:url>"
                method="post">

                <c:if test="${formAction == 'update'}">
                    <input type="hidden" name="id" value="<c:out value='${brand.brandId}'/>">
                </c:if>

                <div class="form-group">
                    <label class="form-label" for="name">Brand Name</label>
                    <input id="name" name="name" type="text" class="form-control"
                           value="<c:out value='${brand.name}'/>" required
                           placeholder="Enter brand name">
                </div>

                <div class="form-group">
                    <label class="form-label" for="logo">Logo URL</label>
                    <input id="logo" name="logo" type="text" class="form-control"
                           value="<c:out value='${brand.logo}'/>"
                           placeholder="https://example.com/logo.png">
                    <div class="hint">Paste an image URL. (Current code does not handle file uploads.)</div>

                    <c:if test="${not empty brand.logo}">
                        <div class="preview">
                            <img src="<c:out value='${brand.logo}'/>" alt="Logo preview">
                        </div>
                    </c:if>
                </div>

                <div class="actions">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <a class="btn btn-secondary"
                       href="<c:url value='/managebrands'><c:param name='role' value='${userRole}'/></c:url>">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
