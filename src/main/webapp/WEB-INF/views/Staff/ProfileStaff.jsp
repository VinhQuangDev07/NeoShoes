<%-- Staff Profile --%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
            :root{
                --bg:#f6f7fb;
                --card:#fff;
                --text:#111827;
                --muted:#6b7280;
                --line:#e5e7eb;
                --primary:#111;
                --radius:14px;
                --banana:#DCFCE7;
                --banana-weak:#DCFCE7;    /* nhạt hơn cho readonly */
            }
            *{
                box-sizing:border-box
            }
            html,body{
                margin:0;
                background:var(--bg);
                color:var(--text);
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif
            }
            .wrap{
                max-width:1120px;
                margin:24px auto;
                padding:0 20px
            }
            .card{
                background:var(--card);
                border:1px solid var(--line);
                border-radius:var(--radius);
                box-shadow:0 4px 24px rgba(0,0,0,.06)
            }
            .head{
                padding:24px;
                border-bottom:1px solid var(--line);
                display:flex;
                gap:12px;
                justify-content:center;
                align-items:center;
                flex-wrap:wrap
            }
            .avatar{
                width:96px;
                height:96px;
                border-radius:999px;
                background:#f1f5f9;
                border:3px solid #fff;
                display:grid;
                place-items:center;
                box-shadow:0 6px 18px rgba(0,0,0,.08);
                overflow:hidden
            }
            .head {
                flex-direction: column !important;
                align-items: center !important;
            }

            .avatar img{
                width:100%;
                height:100%;
                object-fit:cover
            }
            .btn{
                border:1px solid var(--line);
                background:#fff;
                padding:10px 14px;
                border-radius:10px;
                font-weight:600;
                cursor:pointer
            }
            .btn-primary{
                background:#E0E7FF;
                color:#111827;
                border-color:#c7d2fe;
            }

            .body{
                padding:24px
            }
            .grid{
                display:grid;
                gap:16px;
                grid-template-columns:repeat(12,minmax(0,1fr))
            }
            .col-6{
                grid-column:span 6
            }
            .col-12{
                grid-column:span 12
            }
            @media(max-width:920px){
                .col-6{
                    grid-column:span 12
                }
            }
            .field{
                display:flex;
                flex-direction:column;
                gap:6px
            }
            .label{
                font-size:13px;
                font-weight:700;
                color:var(--muted)
            }
            .ctrl{
                display:flex;
                align-items:center;
                gap:10px;
                background:var(--banana);
                border:1px solid var(--line);
                border-radius:10px;
                padding:12px;
                min-height:44px
            }
            .ctrl.readonly{
                background:var(--banana-weak)
            }
            .ctrl input,.ctrl select{
                border:0;
                background:transparent;
                width:100%;
                outline:0;
                font-size:15px;
                color:var(--text)
            }
            .actions{
                display:flex;
                justify-content:flex-end;
                padding:0 24px 24px;
                margin-top:20px;
            }
            .alert{
                margin:12px 24px 0;
                padding:12px 14px;
                border-radius:10px;
                border:1px solid;
                display:flex;
                gap:10px;
                font-weight:600
            }
            .success{
                color:#065f46;
                background:#ecfdf5;
                border-color:#a7f3d0
            }
            .error{
                color:#991b1b;
                background:#fef2f2;
                border-color:#fecaca
            }
        </style>
    </head>
    <body>
        <div class="wrap"><div class="card">

                <div class="head">
                    <div class="avatar" id="avatarBox">
                        <c:choose>
                            <c:when test="${not empty staff.avatar}">
                                <img id="avatarImg" src="${staff.avatar}" alt="Avatar">
                            </c:when>
                            <c:otherwise><i class="fa-solid fa-user fa-2x" style="color:#9ca3af"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <label class="btn"><i class="fa-solid fa-image"></i> Change Avatar
                        <input id="avatarFile" type="file" accept="image/*" style="display:none">
                    </label>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert ${messageType}">
                        <i class="fa-solid ${messageType eq 'success' ? 'fa-circle-check' : 'fa-triangle-exclamation'}"></i>${message}
                    </div>
                </c:if>

                <form class="body" action="${pageContext.request.contextPath}/profilestaff" method="post">
                    <input type="hidden" name="avatar" id="avatarUrlHidden" value="${staff.avatar}"/>

                    <div class="grid">
                        <div class="col-12 field">
                            <span class="label">Full Name</span>
                            <div class="ctrl"><input name="name" value="${staff.name}" required></div>
                        </div>

                        <div class="col-6 field">
                            <span class="label">Email Address</span>
                            <div class="ctrl readonly"><i class="fa-regular fa-envelope"></i><input value="${staff.email}" readonly></div>
                        </div>

                        <div class="col-6 field">
                            <span class="label">Phone Number</span>
                            <div class="ctrl"><i class="fa-solid fa-phone"></i>
                                <input name="phoneNumber" value="${staff.phoneNumber}" pattern="\\+?\\d{8,15}" placeholder="+84xxxxxxxxx">
                            </div>
                        </div>

                        <div class="col-6 field">
                            <span class="label">Gender</span>
                            <div class="ctrl">
                                <i class="fa-solid fa-venus-mars"></i>
                                <select name="gender">
                                    <option value="Male"   <c:if test="${staff.gender eq 'Male'}">selected</c:if>>Male</option>
                                    <option value="Female" <c:if test="${staff.gender eq 'Female'}">selected</c:if>>Female</option>
                                    <option value="Other"  <c:if test="${staff.gender eq 'Other'}">selected</c:if>>Other</option>
                                    </select>
                                </div>
                            </div>



                            <!-- NEW: Address -->
                            <div class="col-6 field">
                                <span class="label">Address</span>
                                <div class="ctrl"><i class="fa-solid fa-location-dot"></i><input name="address" value="${staff.address}" placeholder="Street, City, ..."></div>
                        </div>

                        <!-- NEW: Date of Birth -->
                        <div class="col-6 field">
                            <span class="label">Date of Birth</span>
                            <div class="ctrl"><i class="fa-regular fa-calendar"></i>
                                <input type="date" name="dateOfBirth" value="${staff.dateOfBirth}">
                            </div>
                        </div>

                        <div class="col-6 field">
                            <span class="label">Staff ID</span>
                            <div class="ctrl readonly"><i class="fa-solid fa-id-badge"></i><input value="${staff.staffId}" readonly></div>
                        </div>


                    </div>

                    <div class="actions">
                        <button class="btn btn-primary"><i class="fa-regular fa-floppy-disk"></i> Save Changes</button>
                    </div>
                </form>
            </div></div>

        <script>
            // preview/reset avatar (đơn giản)
            const file = document.getElementById('avatarFile');
            const img = document.getElementById('avatarImg');
            const box = document.getElementById('avatarBox');
            const hidden = document.getElementById('avatarUrlHidden');
            const resetBtn = document.getElementById('btnResetAvatar');
            file?.addEventListener('change', e => {
            const f = e.target.files?.[0]; if (!f) return;
            const url = URL.createObjectURL(f);
            if (img) img.src = url; else {
            const newImg = document.createElement('img');
            newImg.id = 'avatarImg'; newImg.src = url; newImg.alt = 'Avatar';
            box.innerHTML = ''; box.appendChild(newImg);
            }
            });
            resetBtn?.addEventListener('click', () => {
            const original = "${staff.avatar}";
            if (original){
            if (img) img.src = original;
            else { const n = document.createElement('img'); n.id = 'avatarImg'; n.src = original; n.alt = 'Avatar'; box.innerHTML = ''; box.appendChild(n); }
            } else { box.innerHTML = '<i class="fa-solid fa-user fa-2x" style="color:#9ca3af"></i>'; }
            hidden.value = original; if (file) file.value = "";
            });
        </script>
    </body>
</html>
