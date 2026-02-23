<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <h2 class="fw-bold mb-4">Overview</h2>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="glass-card p-4 d-flex align-items-center">
                <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary me-3 flex-shrink-0">
                    <i class="fas fa-box fa-2x"></i>
                </div>
                <div class="overflow-hidden">
                    <h5 class="text-muted mb-1 small text-uppercase fw-bold">Total Products</h5>
                    <h2 class="fw-bold m-0 text-truncate"><asp:Label ID="lblTotalProducts" runat="server" Text="0" /></h2>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="glass-card p-4 d-flex align-items-center">
                <div class="bg-success bg-opacity-10 p-3 rounded-circle text-success me-3 flex-shrink-0">
                    <i class="fas fa-dollar-sign fa-2x"></i>
                </div>
                <div style="min-width: 0;"> <h5 class="text-muted mb-1 small text-uppercase fw-bold">Inventory Value</h5>
                    <h2 class="fw-bold m-0 text-break" style="font-size: 1.8rem;">
                        <asp:Label ID="lblTotalValue" runat="server" Text="$0.00" />
                    </h2>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="glass-card p-4 d-flex align-items-center">
                <div class="bg-warning bg-opacity-10 p-3 rounded-circle text-warning me-3 flex-shrink-0">
                    <i class="fas fa-exclamation-triangle fa-2x"></i>
                </div>
                <div class="overflow-hidden">
                    <h5 class="text-muted mb-1 small text-uppercase fw-bold">Low Stock</h5>
                    <h2 class="fw-bold m-0"><asp:Label ID="lblLowStock" runat="server" Text="0" /></h2>
                </div>
            </div>
        </div>
    </div>

    <div class="glass-card p-5 text-center">
        <h4 class="fw-bold">Welcome back!</h4>
        <p class="text-muted">System status: <span class="text-success fw-bold">Operational</span></p>
        <a href="AddProduct.aspx" class="btn-gradient text-decoration-none mt-3">Add New Item</a>
    </div>

</asp:Content>