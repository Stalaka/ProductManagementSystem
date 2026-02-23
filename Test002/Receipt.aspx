<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Receipt.aspx.cs" Inherits="Receipt" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Download Receipt PDF</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    
    <style>
        body { background-color: #f0f2f5; font-family: 'Courier New', Courier, monospace; }
        .receipt-container { 
            max-width: 400px; 
            margin: 40px auto; 
            background: white; 
            padding: 30px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border-top: 5px solid #16213e;
        }
        .dotted-line { border-bottom: 2px dashed #ccc; margin: 15px 0; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="text-center mt-3 no-print" id="btnContainer">
            <button type="button" onclick="generatePDF()" class="btn btn-danger rounded-pill px-4 shadow">
                <i class="fas fa-file-pdf me-2"></i>Download PDF Again
            </button>
            <p class="text-muted mt-2 small">Your PDF should download automatically...</p>
        </div>

        <div class="receipt-container" id="receiptBox">
            <div class="text-center mb-4">
                <h3 class="fw-bold mb-0">STEPHANIE'S STORE</h3>
                <p class="mb-0 text-muted small">Nairobi, Kenya</p>
                <p class="mb-0 text-muted small">Tel: +254 700 000 000</p>
            </div>

            <div class="dotted-line"></div>

            <div class="d-flex justify-content-between small fw-bold">
                <span>Receipt #: <asp:Label ID="lblReceiptId" runat="server" ClientIDMode="Static"></asp:Label></span>
                <span><asp:Label ID="lblDate" runat="server"></asp:Label></span>
            </div>
            <div class="small fw-bold mt-1">
                Customer: <asp:Label ID="lblCustomer" runat="server" CssClass="text-uppercase"></asp:Label>
            </div>

            <div class="dotted-line"></div>

            <table class="table table-borderless table-sm mb-0">
                <thead>
                    <tr class="small fw-bold border-bottom">
                        <td>ITEM</td>
                        <td class="text-center">QTY</td>
                        <td class="text-end">PRICE</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="fw-bold"><asp:Label ID="lblProduct" runat="server"></asp:Label></td>
                        <td class="text-center"><asp:Label ID="lblQty" runat="server"></asp:Label></td>
                        <td class="text-end"><asp:Label ID="lblPrice" runat="server"></asp:Label></td>
                    </tr>
                </tbody>
            </table>

            <div class="dotted-line"></div>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <span class="fw-bold fs-5">TOTAL</span>
                <span class="fw-bold fs-4 text-dark"><asp:Label ID="lblTotal" runat="server"></asp:Label> KES</span>
            </div>

            <div class="text-center mt-4">
                <p class="fw-bold mb-0">Thank you for your business!</p>
                <p class="small text-muted">Powered by Stephanie's Product Mgmt</p>
            </div>
        </div>

    </form>

    <script>
        function generatePDF() {
            
            const element = document.getElementById('receiptBox');

            
            const receiptNum = document.getElementById('lblReceiptId').innerText || "Receipt";

            
            var opt = {
                margin: 0.3,
                filename: receiptNum + '.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 }, 
                jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
            };

            
            html2pdf().set(opt).from(element).save();
        }

        
        window.onload = function () {
            
            setTimeout(generatePDF, 500);
        }
    </script>
</body>
</html>