
<div class="modal fade" id="forgotModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content p-4">
            <h4 class="text-center mb-3">Reset Password</h4>
            <form method="post" action="forgotProcess.jsp">
                <input type="hidden" name="redirect" value="">
                <div class="mb-3">
                    <label>Email or Phone</label>
                    <input type="text" class="form-control" name="fp_loginid" required>
                </div>
                <div class="mb-3">
                    <label>New Password</label>
                    <input type="password" class="form-control" name="fp_newpassword" required>
                </div>
                <div class="mb-3">
                    <label>Confirm Password</label>
                    <input type="password" class="form-control" name="fp_confirmpassword" required>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-primary w-100">Reset Password</button>
                </div>
                <p class="text-center mt-2">
                    <a href="javascript:void(0);" onclick="$('#loginModal').modal('show'); $('#forgotModal').modal('hide');">Back to Login</a>
                </p>
            </form>
        </div>
    </div>
</div>
    