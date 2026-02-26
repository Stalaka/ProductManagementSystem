<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-dark m-0">Dashboard</h2>
            <p class="text-muted m-0">Real-time business intelligence and performance metrics</p>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="glass-card p-4 border-0 shadow-sm h-100" style="border-radius: 15px; border-left: 5px solid #28a745 !important;">
                <p class="text-muted fw-bold small mb-1">TOTAL REVENUE</p>
                <h3 class="fw-bold text-dark m-0"><asp:Label ID="lblRevenue" runat="server" Text="0 KES"></asp:Label></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-4 border-0 shadow-sm h-100" style="border-radius: 15px; border-left: 5px solid #007bff !important;">
                <p class="text-muted fw-bold small mb-1">TOTAL ITEMS SOLD</p>
                <h3 class="fw-bold text-dark m-0"><asp:Label ID="lblSold" runat="server" Text="0"></asp:Label></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-4 border-0 shadow-sm h-100" style="border-radius: 15px; border-left: 5px solid #ffc107 !important;">
                <p class="text-muted fw-bold small mb-1">REMAINING INVENTORY</p>
                <h3 class="fw-bold text-dark m-0"><asp:Label ID="lblInventory" runat="server" Text="0"></asp:Label></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-4 border-0 shadow-sm h-100" style="border-radius: 15px; border-left: 5px solid #dc3545 !important;">
                <p class="text-muted fw-bold small mb-1">REFUNDS PROCESSED</p>
                <h3 class="fw-bold text-dark m-0"><asp:Label ID="lblRefunds" runat="server" Text="0"></asp:Label></h3>
            </div>
        </div>
    </div>

    <div class="row g-4">
        
        <div class="col-md-8">
            <div class="glass-card p-4 border-0 shadow-sm h-100" style="border-radius: 15px;">
                <h5 class="fw-bold text-dark mb-4"><i class="fas fa-chart-line text-primary me-2"></i>Revenue Trend (Last 7 Active Days)</h5>
                <canvas id="revenueChart" height="100"></canvas>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="glass-card p-4 border-0 shadow-sm h-100" style="border-radius: 15px;">
                <h5 class="fw-bold text-dark mb-4"><i class="fas fa-chart-pie text-success me-2"></i>Top Selling Products</h5>
                <canvas id="productsChart" height="200"></canvas>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            
            // Securely injecting the C# JSON arrays directly into JavaScript!
            const dates = <%= DatesJson %>;
            const revenues = <%= RevenueJson %>;
            const productNames = <%= ProductNamesJson %>;
            const productQtys = <%= ProductQtyJson %>;

            // Chart 1: Revenue Line Chart
            const ctxRev = document.getElementById('revenueChart').getContext('2d');
            new Chart(ctxRev, {
                type: 'line',
                data: {
                    labels: dates,
                    datasets: [{
                        label: 'Daily Revenue (KES)',
                        data: revenues,
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0, 123, 255, 0.1)',
                        borderWidth: 3,
                        tension: 0.4, 
                        fill: true,
                        pointBackgroundColor: '#007bff',
                        pointRadius: 5,
                        pointHoverRadius: 7
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: { 
                        y: { beginAtZero: true, grid: { borderDash: [5, 5] } },
                        x: { grid: { display: false } }
                    }
                }
            });

            // Chart 2: Top Products Doughnut Chart
            const ctxProd = document.getElementById('productsChart').getContext('2d');
            new Chart(ctxProd, {
                type: 'doughnut',
                data: {
                    labels: productNames,
                    datasets: [{
                        data: productQtys,
                        backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545', '#17a2b8'],
                        borderWidth: 0,
                        hoverOffset: 6
                    }]
                },
                options: {
                    responsive: true,
                    cutout: '75%', // Makes the center hole larger for a modern look
                    plugins: {
                        legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20 } }
                    }
                }
            });
        });
    </script>
    
    <style>
        .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); }
    </style>
</asp:Content>