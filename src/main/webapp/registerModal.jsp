
<div class="modal fade" id="registerModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content p-4">
            <h4 class="text-center mb-3">Register</h4>
            <form method="post" action="registerProcess.jsp">
                <input type="hidden" name="redirect" value="">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label>Full Name</label>
                        <input type="text" class="form-control" name="fullname" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label>Password</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Phone</label>
                        <input type="text" class="form-control" name="phone" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label>Gender</label>
                        <select class="form-control" name="gender">
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Date of Birth</label>
                        <input type="date" class="form-control" name="dob" required>
                    </div>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-success w-100">Register</button>
                </div>
                <p class="text-center mt-2">
    <a href="javascript:void(0);" onclick="$('#registerModal').modal('hide'); $('#loginModal').modal('show');">Back to Login</a>
</p>
                
            </form>
        </div>
    </div>
</div>
    