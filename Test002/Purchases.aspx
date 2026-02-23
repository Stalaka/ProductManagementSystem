<%@ Page Title="Purchases" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Purchases.aspx.cs" Inherits="Purchases" %>

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
            <h2 class="fw-bold text-dark m-0">Purchase History</h2>
            <p class="text-muted m-0">Track your incoming stock</p>
        </div>
        <button type="button" class="btn btn-primary px-4 rounded-pill shadow-sm" onclick="openNewModal()">
            <i class="fas fa-plus me-2"></i>Record Purchase
        </button>
    </div>

    <div class="glass-card border-0 shadow-sm overflow-hidden" style="border-radius: 15px;">
        <asp:GridView ID="gvPurchases" runat="server" AutoGenerateColumns="False" 
            CssClass="table table-hover align-middle mb-0 border-0" GridLines="None" 
            OnPageIndexChanging="gvPurchases_PageIndexChanging" AllowPaging="True" PageSize="8">
            
            <HeaderStyle CssClass="bg-light text-uppercase small fw-bold text-muted border-bottom" Height="50px" />
            <RowStyle CssClass="border-bottom" Height="60px" />
            
            <Columns>
                <asp:TemplateField HeaderText="PRODUCT">
                    <ItemTemplate>
                        <div class="d-flex align-items-center">
                            <div class="bg-light rounded-circle p-2 me-3 text-primary">
                                <i class="fas fa-box"></i>
                            </div>
                            <span class="fw-bold text-dark"><%# Eval("ProductName") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Quantity" HeaderText="QTY" ItemStyle-CssClass="fw-bold text-dark" />
                
                <asp:BoundField DataField="UnitPrice" HeaderText="UNIT PRICE" DataFormatString="{0:N0} KES" ItemStyle-CssClass="text-muted" />
                
                <asp:TemplateField HeaderText="TOTAL">
                    <ItemTemplate>
                        <span class="badge bg-soft-primary text-primary px-3 py-2 rounded-pill">
                            <%# Eval("TotalAmount", "{0:N0}") %> KES
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Supplier" HeaderText="SUPPLIER" ItemStyle-CssClass="text-muted small" />
                
                <asp:BoundField DataField="PurchaseDate" HeaderText="DATE" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="text-muted small" />

                <asp:TemplateField HeaderText="ACTIONS" ItemStyle-CssClass="text-end pe-4">
                    <ItemTemplate>
                        <button type="button" onclick='openDeleteConfirm(<%# Eval("PurchaseId") %>)' class="btn btn-light text-danger rounded-circle shadow-sm" style="width:38px;height:38px;">
                            <i class="fas fa-trash"></i>
                        </button>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

            <PagerStyle CssClass="p-3 text-center" HorizontalAlign="Center" />
        </asp:GridView>
    </div>

    <div class="modal fade" id="purchaseModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold ms-2" id="modalTitle">New Purchase</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">SELECT PRODUCT</label>
                        <asp:DropDownList ID="ddlProducts" runat="server" CssClass="form-select border-0 bg-light py-2 shadow-sm text-dark fw-bold" ClientIDMode="Static"></asp:DropDownList>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold text-muted">QUANTITY</label>
                            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" CssClass="form-control border-0 bg-light py-2 shadow-sm fw-bold" Text="1" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold text-muted">UNIT PRICE</label>
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control border-0 bg-light py-2 shadow-sm fw-bold" ClientIDMode="Static"></asp:TextBox>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">SUPPLIER</label>
                        <asp:TextBox ID="txtSupplier" runat="server" CssClass="form-control border-0 bg-light py-2 shadow-sm fw-bold" ClientIDMode="Static"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 px-4 pb-4">
                    <asp:Button ID="btnSave" runat="server" Text="Save Record" CssClass="btn btn-primary w-100 rounded-pill py-2 shadow" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-body p-4 text-center">
                    <div class="text-danger mb-3">
                        <i class="fas fa-exclamation-triangle fa-3x"></i>
                    </div>
                    <h5 class="fw-bold text-dark">Delete Purchase?</h5>
                    <p class="text-muted small mb-4">This will automatically reverse the stock in your inventory.</p>
                    <input type="hidden" id="deletePurchaseId" />
                    
                    <div class="d-flex justify-content-center gap-2">
                        <button type="button" class="btn btn-light rounded-pill px-4 shadow-sm" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger rounded-pill px-4 shadow-sm" onclick="executeDelete()">Delete</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var confirmModal;

        function openNewModal() {
            var myModal = new bootstrap.Modal(document.getElementById('purchaseModal'));
            myModal.show();
        }

        
        function showToast(message, isSuccess = true) {
            const toastEl = document.getElementById('liveToast');
            const toastMsg = document.getElementById('toastMessage');

            toastMsg.innerText = message;
            if (isSuccess) {
                toastEl.classList.remove('bg-danger');
                toastEl.classList.add('bg-success');
            } else {
                toastEl.classList.remove('bg-success');
                toastEl.classList.add('bg-danger');
            }

            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        }

        
        function openDeleteConfirm(id) {
            document.getElementById('deletePurchaseId').value = id;
            confirmModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            confirmModal.show();
        }

        
        function executeDelete() {
            const id = document.getElementById('deletePurchaseId').value;

            fetch('/api/purchases/' + id, { method: 'DELETE' })
                .then(res => {
                    if (res.ok) {
                        confirmModal.hide(); 
                        showToast("Purchase voided successfully!"); 

                        
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);

                    } else {
                        confirmModal.hide();
                        showToast("Error deleting the purchase record.", false);
                    }
                });
        }
    </script>
    
    <style>
        .bg-soft-primary { background-color: #e8f0fe; }
        .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
    </style>
</asp:Content>