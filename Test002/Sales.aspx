<%@ Page Title="Sales" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Sales.aspx.cs" Inherits="Sales" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1060;">
        <div id="liveToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fs-6" id="toastMessage"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-dark m-0">Sales Records</h2>
            <p class="text-muted m-0">Track outgoing stock and process returns</p>
        </div>
        <button type="button" class="btn btn-primary px-4 rounded-pill shadow-sm" onclick="openNewModal()">
            <i class="fas fa-shopping-cart me-2"></i>Record Sale
        </button>
    </div>

    <div class="glass-card border-0 shadow-sm overflow-hidden" style="border-radius: 15px;">
        <asp:GridView ID="gvSales" runat="server" AutoGenerateColumns="False" 
            CssClass="table table-hover align-middle mb-0 border-0" GridLines="None" 
            OnPageIndexChanging="gvSales_PageIndexChanging" AllowPaging="True" PageSize="8">
            
            <HeaderStyle CssClass="bg-light text-uppercase small fw-bold text-muted border-bottom" Height="50px" />
            <RowStyle CssClass="border-bottom" Height="65px" />
            
            <Columns>
                <asp:TemplateField HeaderText="PRODUCT">
                    <ItemTemplate>
                        <div class="d-flex align-items-center">
                            <div class="bg-light rounded-circle p-2 me-3 text-success">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <span class="fw-bold text-dark"><%# Eval("ProductName") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Quantity" HeaderText="QTY OUT" ItemStyle-CssClass="fw-bold text-dark" />
                <asp:BoundField DataField="UnitPrice" HeaderText="SOLD PRICE" DataFormatString="{0:N0} KES" ItemStyle-CssClass="text-muted" />
                
                <asp:TemplateField HeaderText="REVENUE">
                    <ItemTemplate>
                        <span class="badge px-3 py-2 rounded-pill <%# Eval("Status").ToString() == "Refunded" ? "bg-danger bg-opacity-10 text-danger text-decoration-line-through" : "bg-success bg-opacity-10 text-success" %>">
                            <%# Eval("Status").ToString() == "Refunded" ? "- " : "+ " %> <%# Eval("TotalAmount", "{0:N0}") %> KES
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CustomerName" HeaderText="CUSTOMER" ItemStyle-CssClass="text-muted small" />
                
                <asp:TemplateField HeaderText="RECORDED BY">
                    <ItemTemplate>
                        <div class="fw-bold text-dark small">
                            <i class="fas fa-user-circle text-primary me-1"></i> <%# Eval("CreatedBy") %>
                        </div>
                        <div class="text-muted" style="font-size: 0.75rem;">
                            <i class="fas fa-clock me-1"></i> <%# Eval("SaleDate", "{0:dd MMM yyyy}") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="STATUS & REVIEW">
                    <ItemTemplate>
                        <asp:PlaceHolder runat="server" Visible='<%# Eval("Status").ToString() == "Completed" %>'>
                            <span class="badge bg-success bg-opacity-10 text-success px-2 py-1 rounded-pill mb-1">
                                <i class="fas fa-check-circle me-1"></i> Completed
                            </span>
                        </asp:PlaceHolder>

                        <asp:PlaceHolder runat="server" Visible='<%# Eval("Status").ToString() == "Refunded" %>'>
                            <span class="badge bg-danger bg-opacity-10 text-danger px-2 py-1 rounded-pill mb-1">
                                <i class="fas fa-undo me-1"></i> Refunded
                            </span>
                            <div class="small text-muted" style="max-width: 150px; font-size: 0.75rem;">
                                "<%# Eval("CustomerFeedback") %>"
                            </div>
                        </asp:PlaceHolder>

                        <asp:PlaceHolder runat="server" Visible='<%# Eval("Rating") != DBNull.Value %>'>
                            <div class="text-warning small mt-1 mb-1">
                                <%# new String('⭐', Convert.ToInt32(Eval("Rating") == DBNull.Value ? 0 : Eval("Rating"))) %>
                            </div>
                            <div class="small text-muted fst-italic" style="max-width: 150px; font-size: 0.75rem;">
                                "<%# Eval("CustomerReview") %>"
                            </div>
                        </asp:PlaceHolder>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="ACTIONS">
                    <ItemStyle CssClass="pe-4" Width="300px" /> 
                    <ItemTemplate>
                        <div class="d-flex justify-content-end align-items-center gap-2 flex-nowrap">
                            
                            <a href='Receipt.aspx?id=<%# Eval("SaleId") %>' target="_blank" title="Print Receipt"
                                class="btn btn-light text-dark rounded-circle shadow-sm d-flex justify-content-center align-items-center" style="width:38px;height:38px; text-decoration:none;">
                                <i class="fas fa-print"></i>
                            </a>

                            <button type="button" title="Edit Sale"
                                onclick='openEditSale(<%# Eval("SaleId") %>, <%# Eval("Quantity") %>, <%# Eval("UnitPrice") %>, "<%# Eval("CustomerName") %>")' 
                                class='<%# Eval("Status").ToString() == "Refunded" ? "d-none" : "btn btn-light text-primary rounded-circle shadow-sm d-flex justify-content-center align-items-center" %>' 
                                style="width:38px;height:38px;">
                                <i class="fas fa-edit"></i>
                            </button>

                            <button type="button" title="Add Customer Review" 
                                onclick='openReviewModal(<%# Eval("SaleId") %>)' 
                                class='<%# Eval("Status").ToString() == "Refunded" ? "d-none" : "btn btn-light text-info rounded-circle shadow-sm d-flex justify-content-center align-items-center" %>' 
                                style="width:38px;height:38px;">
                                <i class="fas fa-star"></i>
                            </button>
                            
                            <button type="button" title="Process Refund"
                                onclick='openRefundSale(<%# Eval("SaleId") %>)' 
                                class='<%# Eval("Status").ToString() == "Refunded" ? "d-none" : "btn btn-warning text-dark rounded-pill shadow-sm d-flex justify-content-center align-items-center px-3 fw-bold" %>' 
                                style="height:38px; font-size: 0.85rem;">
                                Refund
                            </button>

                            <button type="button" title="Permanently Delete"
                                onclick='openDeleteSale(<%# Eval("SaleId") %>)' 
                                class="btn btn-light text-danger rounded-circle shadow-sm d-flex justify-content-center align-items-center" 
                                style="width:38px;height:38px;">
                                <i class="fas fa-trash"></i>
                            </button>

                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="p-3 text-center" HorizontalAlign="Center" />
        </asp:GridView>
    </div>

    <div class="modal fade" id="saleModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold ms-2">Record New Sale</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">SELECT PRODUCT</label>
                        <asp:DropDownList ID="ddlProducts" runat="server" CssClass="form-select border-0 bg-light py-2 shadow-sm text-dark fw-bold" ClientIDMode="Static"></asp:DropDownList>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold text-muted">QTY SOLD</label>
                            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" CssClass="form-control border-0 bg-light py-2 shadow-sm fw-bold" Text="1" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold text-muted">SELLING PRICE</label>
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control border-0 bg-light py-2 shadow-sm fw-bold" ClientIDMode="Static"></asp:TextBox>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">CUSTOMER NAME</label>
                        <asp:TextBox ID="txtCustomer" runat="server" CssClass="form-control border-0 bg-light py-2 shadow-sm fw-bold" ClientIDMode="Static" placeholder="Optional"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 px-4 pb-4">
                    <asp:Button ID="btnSave" runat="server" Text="Confirm Sale" CssClass="btn btn-success w-100 rounded-pill py-2 shadow" OnClick="btnSave_Click" OnClientClick="this.value='Recording...'; this.style.pointerEvents='none'; this.style.opacity='0.7';" UseSubmitBehavior="false" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editSaleModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold ms-2">Edit Sale Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" id="editSaleId" />
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold text-muted">EDIT QTY</label>
                            <input type="number" id="editQty" class="form-control border-0 bg-light py-2 shadow-sm fw-bold" />
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold text-muted">EDIT PRICE</label>
                            <input type="number" id="editPrice" class="form-control border-0 bg-light py-2 shadow-sm fw-bold" />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">CUSTOMER NAME</label>
                        <input type="text" id="editCustomer" class="form-control border-0 bg-light py-2 shadow-sm fw-bold" />
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 px-4 pb-4">
                    <button type="button" class="btn btn-primary w-100 rounded-pill py-2 shadow" onclick="saveEditSale()">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        var editModal;

        document.addEventListener("DOMContentLoaded", function () {
            editModal = new bootstrap.Modal(document.getElementById('editSaleModal'));
        });

        function openNewModal() {
            new bootstrap.Modal(document.getElementById('saleModal')).show();
        }

        function showToast(message, isSuccess = true) {
            const toastEl = document.getElementById('liveToast');
            document.getElementById('toastMessage').innerText = message;
            if (isSuccess) {
                toastEl.classList.remove('bg-danger');
                toastEl.classList.add('bg-success');
            } else {
                toastEl.classList.remove('bg-success');
                toastEl.classList.add('bg-danger');
            }
            new bootstrap.Toast(toastEl).show();
        }

        function openEditSale(id, qty, price, customer) {
            document.getElementById('editSaleId').value = id;
            document.getElementById('editQty').value = qty;
            document.getElementById('editPrice').value = price;
            document.getElementById('editCustomer').value = customer || '';
            editModal.show();
        }

        function saveEditSale() {
            const id = document.getElementById('editSaleId').value;
            const data = {
                Quantity: document.getElementById('editQty').value,
                UnitPrice: document.getElementById('editPrice').value,
                CustomerName: document.getElementById('editCustomer').value
            };

            fetch('/api/sales/' + id, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            }).then(async res => {
                if (res.ok) {
                    editModal.hide();
                    showToast("Sale Updated Successfully!");
                    setTimeout(() => window.location.reload(), 1500);
                } else {
                    const err = await res.text();
                    showToast("Error updating sale: " + err.substring(0, 50), false);
                }
            });
        }

        function openReviewModal(id) {
            Swal.fire({
                title: 'Customer Review',
                html: `
                    <div class="text-start mb-3 mt-3">
                        <label class="form-label text-muted small fw-bold">RATING (1-5 STARS)</label>
                        <select id="swal-rating" class="form-select border-0 bg-light shadow-sm fw-bold">
                            <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                            <option value="4">⭐⭐⭐⭐ (4 - Good)</option>
                            <option value="3">⭐⭐⭐ (3 - Average)</option>
                            <option value="2">⭐⭐ (2 - Poor)</option>
                            <option value="1">⭐ (1 - Terrible)</option>
                        </select>
                    </div>
                    <div class="text-start">
                        <label class="form-label text-muted small fw-bold">CUSTOMER FEEDBACK</label>
                        <textarea id="swal-review" class="form-control border-0 bg-light shadow-sm" rows="3" placeholder="What did they like or want us to improve?"></textarea>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#3498db',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="fas fa-save"></i> Save Review',
                customClass: { popup: 'border-0 shadow-lg', title: 'fw-bold text-dark' },
                backdrop: `rgba(0,0,0,0.4)`,
                preConfirm: () => {
                    return {
                        rating: document.getElementById('swal-rating').value,
                        review: document.getElementById('swal-review').value
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    const data = result.value;

                    fetch('/api/Review?id=' + id + '&rating=' + data.rating + '&text=' + encodeURIComponent(data.review), { method: 'POST' })
                        .then(res => {
                            if (res.ok) {
                                showToast("Review Saved Successfully!", true);
                                setTimeout(() => window.location.reload(), 1500);
                            } else {
                                showToast("Error saving review.", false);
                            }
                        });
                }
            });
        }

        function openRefundSale(id) {
            Swal.fire({
                title: 'Process Refund?',
                text: "Ask the customer why they are returning this item:",
                input: 'textarea',
                inputPlaceholder: 'Enter customer review / reason for return here...',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#f39c12',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="fas fa-undo"></i> Submit Refund',
                customClass: { popup: 'border-0 shadow-lg', title: 'fw-bold text-dark' },
                backdrop: `rgba(0,0,0,0.4)`
            }).then((result) => {
                if (result.isConfirmed) {
                    const feedbackText = result.value || "No feedback provided";

                    fetch('/api/sales', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ SaleId: id, Feedback: feedbackText })
                    })
                        .then(async res => {
                            if (res.ok) {
                                showToast("Refund Processed & Review Saved!", true);
                                setTimeout(() => window.location.reload(), 1500);
                            } else {
                                try {
                                    const errorData = await res.json();
                                    const realError = errorData.Message || errorData.ExceptionMessage || "Unknown Server Rejection";
                                    showToast("API says: " + realError, false);
                                } catch {
                                    const rawError = await res.text();
                                    showToast("Raw Error: " + rawError.substring(0, 100), false);
                                }
                            }
                        })
                        .catch(err => {
                            showToast("Network Crash: " + err.message, false);
                        });
                }
            });
        }

        function openDeleteSale(id) {
            Swal.fire({
                title: 'Delete?',
                text: "This will completely erase the record. If it isn't refunded yet, it will restock the inventory.",
                icon: 'error',
                showCancelButton: true,
                confirmButtonColor: '#e74c3c',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="fas fa-trash"></i> Delete',
                customClass: { popup: 'border-0 shadow-lg', title: 'fw-bold text-dark' },
                backdrop: `rgba(0,0,0,0.6)`
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('/api/sales/' + id, { method: 'DELETE' })
                        .then(res => {
                            if (res.ok) {
                                showToast("Record Erased!", true);
                                setTimeout(() => window.location.reload(), 1500);
                            } else {
                                showToast("Error deleting record.", false);
                            }
                        });
                }
            });
        }
    </script>
    
    <style>
        .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
    </style>
</asp:Content>