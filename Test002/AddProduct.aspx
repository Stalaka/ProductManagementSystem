<%@ Page Title="Add Product" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="AddProduct.aspx.cs" Inherits="AddProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container d-flex justify-content-center align-items-center" style="min-height: 80vh;">
        <div class="glass-card p-5 border-0 shadow-lg" style="width: 100%; max-width: 600px; border-radius: 20px; background: white;">
            
            <h2 class="fw-bold text-center text-dark mb-4">Add New Product</h2>

            <div class="mb-3">
                <label class="form-label small fw-bold text-muted">PRODUCT NAME</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-lg border-0 bg-light shadow-sm"></asp:TextBox>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label small fw-bold text-muted">CATEGORY</label>
                    <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control form-control-lg border-0 bg-light shadow-sm"></asp:TextBox>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label small fw-bold text-muted">PRICE</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control form-control-lg border-0 bg-light shadow-sm"></asp:TextBox>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-bold text-muted">QUANTITY</label>
                <asp:TextBox ID="txtQty" runat="server" TextMode="Number" CssClass="form-control form-control-lg border-0 bg-light shadow-sm"></asp:TextBox>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted">DESCRIPTION</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control border-0 bg-light shadow-sm" placeholder="e.g. 15kg Front Load, Silver..."></asp:TextBox>
            </div>

            <div class="d-grid">
                <asp:Button ID="btnSave" runat="server" Text="Save Product" OnClick="btnSave_Click" CssClass="btn btn-primary btn-lg rounded-pill shadow" style="background: #6c5ce7; border: none;" />
            </div>

            <div class="mt-3 text-center">
                <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold"></asp:Label>
            </div>

        </div>
    </div>

</asp:Content>