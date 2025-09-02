<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="modal fade" id="loginModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content p-4">
            <h4 class="text-center mb-3">Login</h4>

            <% if(request.getAttribute("loginError") != null){ %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("loginError") %>
                </div>
            <% } %>

            <form method="post" action="loginProcess.jsp">
                <input type="hidden" name="redirect" value="">
                <div class="mb-3">
                    <label>Email or Phone</label>
                    <input type="text" class="form-control" name="loginid" required>
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" class="form-control" name="password" required>
                </div>
                <div class="text-center mb-2">
                    <button type="submit" class="btn btn-success w-100">Login</button>
                </div>
                <p class="text-center mt-2">
                    <a href="javascript:void(0);" onclick="$('#registerModal').modal('show'); $('#loginModal').modal('hide');">Register</a> |
                    <a href="javascript:void(0);" onclick="$('#forgotModal').modal('show'); $('#loginModal').modal('hide');">Forgot Password?</a>
                </p>
            </form>
        </div>
    </div>
</div>
