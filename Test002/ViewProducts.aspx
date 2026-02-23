<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ViewProducts.aspx.cs" Inherits="ViewProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1060;">
        <div id="liveToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fs-6" id="toastMessage"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-dark m-0">Product Management</h2>
            <p class="text-muted m-0">Manage your inventory stock</p>
        </div>
        <a href="AddProduct.aspx" class="btn btn-primary px-4 rounded-pill shadow-sm">
            <i class="fas fa-plus me-2"></i>Add New
        </a>
    </div>

    <div class="glass-card p-3 mb-4 border-0 shadow-sm" style="border-radius: 15px; background: white;">
        <div class="input-group">
            <span class="input-group-text bg-transparent border-0"><i class="fas fa-search text-muted"></i></span>
            <input type="text" id="searchInput" class="form-control border-0 bg-transparent fw-bold" placeholder="Search products..." onkeyup="filterProducts()">
        </div>
    </div>

    <div class="glass-card border-0 shadow-sm overflow-hidden" style="border-radius: 15px; background: white;">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light">
                <tr class="text-uppercase small fw-bold text-muted" style="height: 50px;">
                    <th class="ps-4">ID</th>
                    <th>Product Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th class="text-end pe-4">Actions</th>
                </tr>
            </thead>
            <tbody id="productTableBody">
                <tr><td colspan="6" class="text-center p-5 text-muted">Loading data...</td></tr>
            </tbody>
        </table>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold ms-2">Edit Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 pt-0">
                    <input type="hidden" id="editId" />
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Name</label>
                        <input type="text" id="editName" class="form-control border-0 bg-light py-2 shadow-sm fw-bold" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Category</label>
                        <input type="text" id="editCategory" class="form-control border-0 bg-light py-2 shadow-sm fw-bold" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Price</label>
                        <input type="number" id="editPrice" class="form-control border-0 bg-light py-2 shadow-sm fw-bold" />
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4">
                    <button type="button" onclick="saveUpdate()" class="btn btn-primary w-100 rounded-pill shadow">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var allProducts = [];
        var myModal;

        document.addEventListener('DOMContentLoaded', function () {
            var modalEl = document.getElementById('editModal');
            if (modalEl) {
                myModal = new bootstrap.Modal(modalEl);
            }
            loadProducts();
        });

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

        function loadProducts() {
            fetch('/api/products')
                .then(res => res.json())
                .then(data => {
                    allProducts = data;
                    renderTable(data);
                });
        }

        function renderTable(products) {
            const tbody = document.getElementById('productTableBody');
            tbody.innerHTML = '';

            if (products.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center p-5 text-muted">No products found.</td></tr>';
                return;
            }

            products.forEach(p => {
                let stockBadge = p.Quantity < 10
                    ? `<span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill"><i class="fas fa-exclamation-circle me-1"></i> ${p.Quantity} Low</span>`
                    : `<span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill"><i class="fas fa-check-circle me-1"></i> ${p.Quantity} In Stock</span>`;

                let price = new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES', maximumFractionDigits: 0 }).format(p.Price);

               
                let row = `
                    <tr>
                        <td class="ps-4 text-muted fw-bold">#${p.ProductId}</td>
                        <td class="fw-bold text-dark">${p.ProductName}</td>
                        <td><span class="badge bg-light text-dark border">${p.Category}</span></td>
                        <td class="fw-bold text-primary">${price}</td>
                        <td>${stockBadge}</td>
                        <td class="pe-4">
                            <div class="d-flex justify-content-end align-items-center gap-2 flex-nowrap">
                                <button type="button" onclick="openEdit(${p.ProductId})" class="btn btn-light text-primary rounded-circle shadow-sm d-flex justify-content-center align-items-center" style="width:38px;height:38px;">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" onclick="deleteProduct(${p.ProductId})" class="btn btn-light text-danger rounded-circle shadow-sm d-flex justify-content-center align-items-center" style="width:38px;height:38px;">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>`;
                tbody.innerHTML += row;
            });
        }

        function openEdit(id) {
            const product = allProducts.find(p => p.ProductId == id);
            if (product) {
                document.getElementById('editId').value = product.ProductId;
                document.getElementById('editName').value = product.ProductName;
                document.getElementById('editCategory').value = product.Category;
                document.getElementById('editPrice').value = product.Price;
                if (myModal) myModal.show();
            }
        }

        function saveUpdate() {
            const id = document.getElementById('editId').value;
            const updatedProduct = {
                ProductName: document.getElementById('editName').value,
                Category: document.getElementById('editCategory').value,
                Price: document.getElementById('editPrice').value
            };

            fetch('/api/products/' + id, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(updatedProduct)
            }).then(res => {
                if (res.ok) {
                    if (myModal) myModal.hide();
                    showToast("Update Successful!");
                    loadProducts();
                } else {
                    showToast("Update Failed", false);
                }
            });
        }

        // NEW: The beautiful SweetAlert2 Delete Function!
        function deleteProduct(id) {
            Swal.fire({
                title: 'Delete this product?',
                text: "This action cannot be undone!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e74c3c',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="fas fa-trash"></i> Yes, delete it!',
                customClass: {
                    popup: 'border-0 shadow-lg',
                    title: 'fw-bold text-dark'
                },
                backdrop: `rgba(0,0,0,0.4)`
            }).then((result) => {
                // If they click 'Yes', we call your API to delete it
                if (result.isConfirmed) {
                    fetch('/api/products/' + id, { method: 'DELETE' })
                        .then(res => {
                            if (res.ok) {
                                showToast("Product Deleted", true);
                                loadProducts(); // Instantly refresh the table
                            } else {
                                showToast("Error deleting product", false);
                            }
                        });
                }
            });
        }

        function filterProducts() {
            const term = document.getElementById('searchInput').value.toLowerCase();
            const filtered = allProducts.filter(p => p.ProductName.toLowerCase().includes(term));
            renderTable(filtered);
        }
    </script>
    <style>
        .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
    </style>
</asp:Content>