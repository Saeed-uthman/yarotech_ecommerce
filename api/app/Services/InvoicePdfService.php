<?php

declare(strict_types=1);

namespace App\Services;

use Dompdf\Dompdf;
use Dompdf\Options;

/**
 * InvoicePdfService — generates a professional A4-format PDF invoice
 * for customers to review before (or after) payment.
 *
 * Two entry points:
 *   generateFromOrder()  — post-payment, from DB order data
 *   stream()             — outputs PDF binary directly to the client
 */
final class InvoicePdfService
{
    /**
     * Generate an A4 invoice PDF from an existing DB order and return the raw output.
     *
     * @param array $order
     * @param array $items
     * @param array $user
     * @return string Binary PDF content.
     */
    public function generateFromOrder(array $order, array $items, array $user): string
    {
        $html = $this->renderHtml($order, $items, $user, 'post-payment');
        return $this->renderPdf($html);
    }

    /**
     * Generate an A4 invoice PDF from checkout preview data (pre-payment).
     *
     * @param array $preview  Checkout preview payload (cart, fulfillment, totals)
     * @param array $customer Customer details {fullName, email, phone, company?}
     * @return string Binary PDF content.
     */
    public function generateFromPreview(array $preview, array $customer): string
    {
        $order = [
            'order_number'       => 'PREVIEW',
            'created_at'         => date('Y-m-d H:i:s'),
            'customer_name'      => $customer['fullName'] ?? '',
            'customer_email'     => $customer['email'] ?? '',
            'customer_phone'     => $customer['phone'] ?? '',
            'subtotal'           => $preview['totals']['subtotal'] ?? 0,
            'tax_amount'         => $preview['totals']['vat'] ?? 0,
            'delivery_fee'       => $preview['totals']['delivery_fee'] ?? 0,
            'total_amount'       => $preview['totals']['total'] ?? 0,
            'currency'           => $preview['totals']['currency'] ?? 'NGN',
            'payment_status'     => 'pending',
            'fulfillment_method' => $preview['fulfillment']['method'] ?? 'delivery',
            'delivery_state'     => $preview['fulfillment']['address']['state'] ?? null,
            'delivery_city'      => $preview['fulfillment']['address']['city_or_lga'] ?? null,
            'delivery_address'   => $preview['fulfillment']['address']['address_line'] ?? null,
            'delivery_landmark'  => $preview['fulfillment']['address']['landmark'] ?? null,
            'delivery_phone'     => $customer['phone'] ?? null,
        ];

        $items = [];
        foreach ($preview['cart']['items'] ?? [] as $item) {
            $items[] = [
                'product_name_snapshot' => $item['name'] ?? '',
                'sku_snapshot'          => $item['sku'] ?? '-',
                'quantity'              => $item['quantity'] ?? 1,
                'unit_price_snapshot'   => $item['price'] ?? 0,
                'line_total'            => $item['line_total'] ?? ($item['price'] * $item['quantity']),
            ];
        }

        $html = $this->renderHtml($order, $items, $customer, 'pre-payment');
        return $this->renderPdf($html);
    }

    /**
     * Stream the PDF directly to the client as a download.
     */
    public function streamDownload(string $pdfContent, string $filename): void
    {
        http_response_code(200);
        header('Content-Type: application/pdf');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Content-Length: ' . strlen($pdfContent));
        header('Cache-Control: no-cache, must-revalidate');
        echo $pdfContent;
        exit;
    }

    /**
     * Stream the PDF inline (for preview in browser).
     */
    public function streamInline(string $pdfContent): void
    {
        http_response_code(200);
        header('Content-Type: application/pdf');
        header('Content-Disposition: inline; filename="invoice.pdf"');
        header('Content-Length: ' . strlen($pdfContent));
        header('Cache-Control: no-cache, must-revalidate');
        echo $pdfContent;
        exit;
    }

    // ---------------------------------------------------------------
    // Private helpers
    // ---------------------------------------------------------------

    private function renderPdf(string $html): string
    {
        $options = new Options();
        $options->set('isRemoteEnabled', true);
        $options->set('isHtml5ParserEnabled', true);
        $options->set('defaultFont', 'DejaVu Sans');

        $dompdf = new Dompdf($options);
        $dompdf->loadHtml($html);
        $dompdf->setPaper('A4', 'portrait');
        $dompdf->render();

        return $dompdf->output();
    }

    private function renderHtml(array $order, array $items, array $userOrCustomer, string $mode): string
    {
        $customerName  = htmlspecialchars((string) ($userOrCustomer['fullName'] ?? $userOrCustomer['name'] ?? $order['customer_name'] ?? 'Customer'));
        $customerEmail = htmlspecialchars((string) ($userOrCustomer['email'] ?? $order['customer_email'] ?? ''));
        $customerPhone = htmlspecialchars((string) ($userOrCustomer['phone'] ?? $order['customer_phone'] ?? ''));
        $company       = htmlspecialchars((string) ($userOrCustomer['company'] ?? ''));

        $orderNumber = htmlspecialchars((string) ($order['order_number'] ?? ''));
        $date        = date('d/m/Y', strtotime($order['created_at'] ?? 'now'));
        $time        = date('h:i A', strtotime($order['created_at'] ?? 'now'));
        $validUntil  = date('d/m/Y h:i A', strtotime(($order['created_at'] ?? 'now') . ' + 48 hours'));

        $isPreview = ($order['order_number'] ?? '') === 'PREVIEW';
        $paymentStatus = strtolower((string) ($order['payment_status'] ?? 'pending'));

        // Delivery address block
        $fulfillmentMethod = ucfirst(htmlspecialchars((string) ($order['fulfillment_method'] ?? 'delivery')));
        if (($order['fulfillment_method'] ?? 'delivery') === 'pickup') {
            $deliveryBlock = '<p style="margin:0;font-size:11px;color:#4B5563;">Pickup from: Lokoro plaza A Farm Center, Kano State</p>';
        } else {
            $addr = $order['delivery_address'] ?? '';
            $city = $order['delivery_city'] ?? '';
            $state = $order['delivery_state'] ?? '';
            $landmark = $order['delivery_landmark'] ?? '';
            $phone = $order['delivery_phone'] ?? $customerPhone;
            $deliveryBlock = sprintf(
                '<p style="margin:0;font-size:11px;color:#4B5563;">%s, %s, %s%s</p><p style="margin:2px 0 0;font-size:11px;color:#4B5563;">Phone: %s</p>',
                htmlspecialchars($addr),
                htmlspecialchars($city),
                htmlspecialchars($state),
                $landmark !== '' ? ' — ' . htmlspecialchars($landmark) : '',
                $phone
            );
        }

        // Items rows
        $itemsHtml = '';
        $idx = 0;
        foreach ($items as $item) {
            $idx++;
            $name      = htmlspecialchars((string) ($item['product_name_snapshot'] ?? 'Item'));
            $sku       = htmlspecialchars((string) ($item['sku_snapshot'] ?? '-'));
            $qty       = (int) ($item['quantity'] ?? 1);
            $unitPrice = (float) ($item['unit_price_snapshot'] ?? 0);
            $lineTotal = (float) ($item['line_total'] ?? ($unitPrice * $qty));
            $bg        = $idx % 2 === 0 ? '#F9FAFB' : '#FFFFFF';

            $itemsHtml .= "
                <tr style=\"background:{$bg}\">
                    <td style=\"padding:10px 12px;font-size:11px;color:#6B7280;\">{$idx}</td>
                    <td style=\"padding:10px 12px;\">
                        <div style=\"font-size:12px;font-weight:700;color:#0D1C32;\">{$name}</div>
                        <div style=\"font-size:10px;color:#9CA3AF;font-family:monospace;margin-top:2px;\">{$sku}</div>
                    </td>
                    <td style=\"padding:10px 12px;text-align:center;font-size:12px;color:#0D1C32;\">{$qty}</td>
                    <td style=\"padding:10px 12px;text-align:right;font-size:12px;color:#0D1C32;\">&#8358;" . number_format($unitPrice, 2) . "</td>
                    <td style=\"padding:10px 12px;text-align:right;font-size:12px;font-weight:700;color:#0D1C32;\">&#8358;" . number_format($lineTotal, 2) . "</td>
                </tr>";
        }

        // Totals
        $subtotal    = number_format((float) ($order['subtotal'] ?? 0), 2);
        $vat         = number_format((float) ($order['tax_amount'] ?? 0), 2);
        $deliveryFee = number_format((float) ($order['delivery_fee'] ?? 0), 2);
        $total       = number_format((float) ($order['total_amount'] ?? 0), 2);
        $vatRate     = 7.5;

        // Status badge
        if ($isPreview) {
            $statusLabel = 'AWAITING PAYMENT';
            $statusColor = '#D97706';
            $statusBg    = '#FEF3C7';
        } elseif ($paymentStatus === 'success' || $paymentStatus === 'paid') {
            $statusLabel = 'PAID';
            $statusColor = '#16A34A';
            $statusBg    = '#DCFCE7';
        } elseif ($paymentStatus === 'failed') {
            $statusLabel = 'FAILED';
            $statusColor = '#DC2626';
            $statusBg    = '#FEE2E2';
        } else {
            $statusLabel = 'PENDING';
            $statusColor = '#D97706';
            $statusBg    = '#FEF3C7';
        }

        $invoiceTitle = $isPreview ? 'PROFORMA INVOICE' : 'INVOICE';

        return "
        <!DOCTYPE html>
        <html lang=\"en\">
        <head>
            <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body {
                    font-family: 'DejaVu Sans', Helvetica, Arial, sans-serif;
                    color: #0D1C32;
                    background: #fff;
                    font-size: 12px;
                    line-height: 1.5;
                }
            </style>
        </head>
        <body>
            <!-- Top gradient bar -->
            <div style=\"height:8px;background:linear-gradient(90deg, #0D1C32 0%, #0D1C32 70%, #FEA619 100%);\"></div>

            <div style=\"padding:30px 40px;\">
                <!-- Header -->
                <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin-bottom:24px;\">
                    <tr>
                        <td style=\"vertical-align:top;\">
                            <h1 style=\"font-size:22px;font-weight:900;color:#0D1C32;letter-spacing:-0.5px;margin:0;\">YAROTECH NETWORK LIMITED</h1>
                            <p style=\"font-size:9px;font-weight:bold;text-transform:uppercase;letter-spacing:2px;color:#6B7280;margin:4px 0 2px;\">Powering Connection. Building Future</p>
                            <p style=\"font-size:10px;color:#6B7280;margin:0;\">Lokoro plaza A Farm Center, Kano State, Nigeria</p>
                            <p style=\"font-size:10px;color:#6B7280;margin:2px 0 0;\">07075373603 · yarotech@gmail.com</p>
                        </td>
                        <td style=\"vertical-align:top;text-align:right;\">
                            <h2 style=\"font-size:28px;font-weight:900;color:#0D1C32;letter-spacing:3px;margin:0;\">{$invoiceTitle}</h2>
                            <div style=\"margin-top:10px;\">
                                <span style=\"display:inline-block;padding:4px 12px;border-radius:20px;font-size:10px;font-weight:700;text-transform:uppercase;color:{$statusColor};background:{$statusBg};\">{$statusLabel}</span>
                            </div>
                        </td>
                    </tr>
                </table>

                <!-- Invoice meta + Customer info -->
                <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin-bottom:28px;border-top:1px solid #E5E7EB;border-bottom:1px solid #E5E7EB;\">
                    <tr>
                        <td style=\"padding:16px 0;width:50%;vertical-align:top;border-right:1px solid #E5E7EB;\">
                            <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">
                                <tr>
                                    <td style=\"padding:0 16px 0 0;\">
                                        <p style=\"font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#6B7280;margin:0 0 4px;\">Invoice Number</p>
                                        <p style=\"font-size:13px;font-weight:700;color:#0D1C32;margin:0;font-family:monospace;\">INV-{$orderNumber}</p>
                                    </td>
                                    <td>
                                        <p style=\"font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#6B7280;margin:0 0 4px;\">Date</p>
                                        <p style=\"font-size:12px;font-weight:700;color:#0D1C32;margin:0;\">{$date}</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td style=\"padding:12px 16px 0 0;\">
                                        <p style=\"font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#6B7280;margin:0 0 4px;\">Time</p>
                                        <p style=\"font-size:12px;font-weight:700;color:#0D1C32;margin:0;\">{$time}</p>
                                    </td>
                                    <td style=\"padding:12px 0 0;\">
                                        <p style=\"font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#6B7280;margin:0 0 4px;\">Valid Until</p>
                                        <p style=\"font-size:12px;font-weight:700;color:#0D1C32;margin:0;\">{$validUntil}</p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style=\"padding:16px 0 0 16px;width:50%;vertical-align:top;\">
                            <p style=\"font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#6B7280;margin:0 0 6px;\">Bill To</p>
                            <p style=\"font-size:12px;font-weight:700;color:#0D1C32;margin:0;\">{$customerName}</p>" .
                            ($company !== '' ? "<p style=\"font-size:11px;color:#4B5563;margin:2px 0 0;\">{$company}</p>" : '') .
                            "<p style=\"font-size:11px;color:#4B5563;margin:2px 0 0;\">{$customerEmail}</p>
                            <p style=\"font-size:11px;color:#4B5563;margin:2px 0 0;\">{$customerPhone}</p>
                        </td>
                    </tr>
                </table>

                <!-- Delivery / Fulfillment info -->
                <div style=\"margin-bottom:24px;padding:12px 16px;background:#F9FAFB;border-left:3px solid #FEA619;border-radius:4px;\">
                    <p style=\"font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#6B7280;margin:0 0 6px;\">Fulfillment Method: {$fulfillmentMethod}</p>
                    {$deliveryBlock}
                </div>

                <!-- Items Table -->
                <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin-bottom:24px;border-collapse:collapse;\">
                    <thead>
                        <tr style=\"background:#0D1C32;\">
                            <th style=\"padding:10px 12px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#fff;text-align:left;width:40px;\">#</th>
                            <th style=\"padding:10px 12px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#fff;text-align:left;\">Product</th>
                            <th style=\"padding:10px 12px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#fff;text-align:center;width:60px;\">Qty</th>
                            <th style=\"padding:10px 12px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#fff;text-align:right;width:100px;\">Unit Price</th>
                            <th style=\"padding:10px 12px;font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#fff;text-align:right;width:110px;\">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        {$itemsHtml}
                    </tbody>
                </table>

                <!-- Financial Summary -->
                <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin-bottom:28px;\">
                    <tr>
                        <td style=\"width:55%;\"></td>
                        <td style=\"width:45%;\">
                            <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"border:1px solid #E5E7EB;border-radius:6px;overflow:hidden;\">
                                <tr>
                                    <td style=\"padding:10px 16px;font-size:11px;color:#6B7280;\">Subtotal</td>
                                    <td style=\"padding:10px 16px;text-align:right;font-size:12px;font-weight:700;color:#0D1C32;\">&#8358;{$subtotal}</td>
                                </tr>
                                <tr style=\"background:#F9FAFB;\">
                                    <td style=\"padding:10px 16px;font-size:11px;color:#6B7280;\">VAT ({$vatRate}%)</td>
                                    <td style=\"padding:10px 16px;text-align:right;font-size:12px;font-weight:700;color:#0D1C32;\">&#8358;{$vat}</td>
                                </tr>
                                <tr>
                                    <td style=\"padding:10px 16px;font-size:11px;color:#6B7280;\">Delivery / Fulfillment</td>
                                    <td style=\"padding:10px 16px;text-align:right;font-size:12px;font-weight:700;color:#0D1C32;\">&#8358;{$deliveryFee}</td>
                                </tr>
                                <tr style=\"background:#0D1C32;\">
                                    <td style=\"padding:14px 16px;font-size:13px;font-weight:900;text-transform:uppercase;letter-spacing:1px;color:#fff;\">Grand Total</td>
                                    <td style=\"padding:14px 16px;text-align:right;font-size:18px;font-weight:900;color:#FEA619;\">&#8358;{$total}</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

                <!-- Payment Terms -->
                <div style=\"margin-bottom:28px;padding:16px;border:1px dashed #D1D5DB;border-radius:6px;\">
                    <h3 style=\"font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:#0D1C32;margin:0 0 10px;\">Payment Terms & Instructions</h3>
                    <ul style=\"font-size:11px;color:#4B5563;padding-left:18px;margin:0;\">
                        <li style=\"margin-bottom:4px;\">Payment is required before order processing and dispatch.</li>
                        <li style=\"margin-bottom:4px;\">This invoice is valid for <strong>48 hours</strong> from the date of issue.</li>
                        <li style=\"margin-bottom:4px;\">Payment is processed securely via <strong>Paystack</strong> (cards, bank transfer, USSD).</li>
                        <li style=\"margin-bottom:4px;\">For bank transfer, please reference your invoice number: <strong>INV-{$orderNumber}</strong></li>
                    </ul>
                    <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin-top:12px;background:#F9FAFB;border-radius:4px;\">
                        <tr>
                            <td style=\"padding:10px 14px;font-size:10px;color:#6B7280;\">
                                <strong>Bank:</strong> Guaranty Trust Bank (GTBank)<br/>
                                <strong>Account Name:</strong> YAROTECH NETWORK LIMITED<br/>
                                <strong>Account Number:</strong> 0123456789
                            </td>
                        </tr>
                    </table>
                </div>

                <!-- Footer -->
                <div style=\"border-top:2px solid #0D1C32;padding-top:16px;text-align:center;\">
                    <p style=\"font-size:9px;color:#6B7280;margin:0 0 4px;\">YAROTECH NETWORK LIMITED · RC: 1234567 · Kano State, Nigeria</p>
                    <p style=\"font-size:9px;color:#6B7280;margin:0 0 8px;\">Thank you for choosing YAROTECH. Powering Connection. Building Future.</p>
                    <div style=\"display:inline-block;height:2px;width:60px;background:#FEA619;\"></div>
                </div>
            </div>
        </body>
        </html>";
    }
}
