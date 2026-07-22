<?php

declare(strict_types=1);

namespace App\Services;

use Dompdf\Dompdf;
use Dompdf\Options;

final class ReceiptPdfService
{
    /**
     * Generates a PDF receipt matching the frontend aesthetic and saves it to a file.
     *
     * @param array $order
     * @param array $user
     * @param array $items
     * @return string The absolute path to the generated PDF file.
     */
    public function generateReceiptPdf(array $order, array $user, array $items): string
    {
        $html = $this->renderHtml($order, $user, $items);

        $options = new Options();
        $options->set('isRemoteEnabled', true);
        $options->set('isHtml5ParserEnabled', true);
        
        $dompdf = new Dompdf($options);
        $dompdf->loadHtml($html);
        
        // Use a small thermal receipt format (e.g. 80mm width)
        // 80mm ~ 226pt width. We can set custom paper size: array(0,0, 226, 600)
        // Or we can just use standard A4 but styled nicely. Let's use A5 or custom receipt width.
        $dompdf->setPaper(array(0, 0, 240, 600), 'portrait');
        $dompdf->render();
        
        $output = $dompdf->output();
        
        $dir = base_path('storage/logs/emails');
        if (!is_dir($dir)) {
            @mkdir($dir, 0775, true);
        }
        
        $filename = 'YAROTECH-Receipt-' . ($order['order_number'] ?? time()) . '.pdf';
        $filepath = $dir . '/' . $filename;
        
        file_put_contents($filepath, $output);
        
        return $filepath;
    }

    private function renderHtml(array $order, array $user, array $items): string
    {
        $customer = htmlspecialchars((string) ($user['name'] ?? $order['customer_name'] ?? 'Walk-in customer'));
        $date = date('d/m/Y h:i A', strtotime($order['created_at'] ?? 'now'));
        $orderId = htmlspecialchars((string) ($order['order_number'] ?? $order['id'] ?? ''));
        $status = ucfirst(htmlspecialchars((string) ($order['payment_status'] ?? 'pending')));

        $itemsHtml = '';
        foreach ($items as $item) {
            $name = htmlspecialchars((string) ($item['product_name_snapshot'] ?? 'Item'));
            $sku = htmlspecialchars((string) ($item['sku_snapshot'] ?? '-'));
            $qty = (int) ($item['quantity'] ?? 1);
            $price = number_format((float) ($item['unit_price_snapshot'] ?? 0), 2);
            $lineTotal = number_format((float) ($item['line_total'] ?? 0), 2);

            $itemsHtml .= "
                <tr>
                    <td style='padding: 8px 0;'>
                        <div class='item-name'>{$name}</div>
                        <div class='item-sku'>{$sku}</div>
                    </td>
                    <td style='padding: 8px 0; text-align: right;'>
                        <div class='item-price'>&#8358;{$lineTotal}</div>
                        <div class='item-sku'>{$qty} x &#8358;{$price}</div>
                    </td>
                </tr>
            ";
        }

        $subtotal = number_format((float) ($order['subtotal'] ?? 0), 2);
        $vat = number_format((float) ($order['tax_amount'] ?? 0), 2);
        $delivery = number_format((float) ($order['delivery_fee'] ?? 0), 2);
        $total = number_format((float) ($order['total_amount'] ?? 0), 2);

        // Status badge color logic
        $statusColor = '#EAB308'; // yellow
        $statusBg = '#FEF9C3';
        if (strtolower($status) === 'success' || strtolower($status) === 'paid') {
            $statusColor = '#16A34A'; // green
            $statusBg = '#DCFCE7';
            $status = 'PAID';
        } elseif (strtolower($status) === 'failed') {
            $statusColor = '#DC2626'; // red
            $statusBg = '#FEE2E2';
        }

        return "
        <!DOCTYPE html>
        <html lang='en'>
        <head>
            <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
            <style>
                body {
                    font-family: 'DejaVu Sans', Helvetica, Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background: #ffffff;
                    color: #0D1C32;
                }
                .container {
                    padding: 20px;
                }
                .gradient-bar {
                    height: 6px;
                    background: #0D1C32; /* Primary */
                    border-bottom: 2px solid #FEA619; /* Accent */
                    margin-bottom: 20px;
                }
                .header {
                    text-align: center;
                    margin-bottom: 20px;
                }
                .header h2 {
                    margin: 0;
                    font-size: 18px;
                    font-weight: 900;
                    color: #0D1C32;
                    letter-spacing: -0.5px;
                }
                .header .subtitle {
                    margin: 4px 0 2px 0;
                    font-size: 8px;
                    font-weight: bold;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                    color: #6B7280;
                }
                .header .address {
                    margin: 0;
                    font-size: 8px;
                    color: #6B7280;
                }
                .metadata {
                    width: 100%;
                    border-top: 1px solid #E5E7EB;
                    border-bottom: 1px solid #E5E7EB;
                    padding: 12px 0;
                    margin-bottom: 20px;
                    border-collapse: collapse;
                }
                .metadata td {
                    width: 50%;
                    padding: 4px 0;
                    vertical-align: top;
                }
                .meta-label {
                    font-size: 8px;
                    font-weight: bold;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    color: #6B7280;
                    margin: 0 0 2px 0;
                }
                .meta-value {
                    font-size: 11px;
                    font-weight: bold;
                    color: #0D1C32;
                    margin: 0;
                }
                .status-badge {
                    display: inline-block;
                    padding: 2px 6px;
                    border-radius: 12px;
                    font-size: 9px;
                    font-weight: bold;
                    text-transform: uppercase;
                    color: {$statusColor};
                    background-color: {$statusBg};
                }
                .items-title {
                    font-size: 9px;
                    font-weight: bold;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    color: #6B7280;
                    margin-bottom: 8px;
                }
                .items-table {
                    width: 100%;
                    border-collapse: collapse;
                }
                .item-name {
                    font-size: 10px;
                    font-weight: bold;
                    color: #0D1C32;
                }
                .item-sku {
                    font-size: 9px;
                    color: #6B7280;
                    font-family: monospace;
                    margin-top: 2px;
                }
                .item-price {
                    font-size: 10px;
                    font-weight: bold;
                    color: #0D1C32;
                }
                .divider {
                    border-top: 1px dashed #E5E7EB;
                    margin: 16px 0;
                }
                .totals {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 10px;
                    color: #6B7280;
                }
                .totals td {
                    padding: 3px 0;
                }
                .totals .right {
                    text-align: right;
                    font-weight: bold;
                    color: #0D1C32;
                }
                .total-paid {
                    border-top: 1px solid #E5E7EB;
                }
                .total-paid td {
                    padding-top: 10px;
                    margin-top: 10px;
                }
                .total-label {
                    font-size: 12px;
                    font-weight: bold;
                    text-transform: uppercase;
                    color: #0D1C32;
                }
                .total-value {
                    font-size: 16px;
                    font-weight: 900;
                    color: #0D1C32;
                    text-align: right;
                }
                .barcode {
                    text-align: center;
                    margin-top: 24px;
                }
                .barcode-bars {
                    display: inline-block;
                    height: 30px;
                    background: repeating-linear-gradient(
                        90deg,
                        #0D1C32,
                        #0D1C32 2px,
                        transparent 2px,
                        transparent 4px,
                        #0D1C32 4px,
                        #0D1C32 5px,
                        transparent 5px,
                        transparent 8px
                    );
                    width: 120px;
                    opacity: 0.8;
                }
                .barcode-text {
                    font-family: monospace;
                    font-size: 9px;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                    color: #6B7280;
                    margin-top: 4px;
                }
            </style>
        </head>
        <body>
            <div class='gradient-bar'></div>
            <div class='container'>
                <div class='header'>
                    <h2>YAROTECH NETWORK LIMITED</h2>
                    <p class='subtitle'>Powering Connection. Building Future</p>
                    <p class='address'>Lokoro plaza A Farm Center, Kano State, Nigeria</p>
                </div>

                <table class='metadata'>
                    <tr>
                        <td>
                            <p class='meta-label'>Receipt Number</p>
                            <p class='meta-value' style='font-family: monospace;'>{$orderId}</p>
                        </td>
                        <td>
                            <p class='meta-label'>Date / Time</p>
                            <p class='meta-value'>{$date}</p>
                        </td>
                    </tr>
                    <tr>
                        <td style='padding-top: 12px;'>
                            <p class='meta-label'>Customer</p>
                            <p class='meta-value'>{$customer}</p>
                        </td>
                        <td style='padding-top: 12px;'>
                            <p class='meta-label'>Payment Status</p>
                            <span class='status-badge'>{$status}</span>
                        </td>
                    </tr>
                </table>

                <div class='items-title'>Purchased Items</div>
                <table class='items-table'>
                    {$itemsHtml}
                </table>

                <div class='divider'></div>

                <table class='totals'>
                    <tr>
                        <td>Subtotal</td>
                        <td class='right'>&#8358;{$subtotal}</td>
                    </tr>
                    <tr>
                        <td>VAT (7.5%)</td>
                        <td class='right'>&#8358;{$vat}</td>
                    </tr>
                    <tr>
                        <td>Fulfillment / Delivery</td>
                        <td class='right'>&#8358;{$delivery}</td>
                    </tr>
                    <tr class='total-paid'>
                        <td class='total-label'>Total Paid</td>
                        <td class='total-value'>&#8358;{$total}</td>
                    </tr>
                </table>

                <div class='barcode'>
                    <div class='barcode-bars'></div>
                    <div class='barcode-text'>{$orderId}</div>
                </div>
            </div>
        </body>
        </html>
        ";
    }
}
