#!/bin/bash
# ============================================================
# YAROTECH E-Commerce — Ubuntu/Nginx Server Setup
# Run this on your Ubuntu server as root or with sudo
# ============================================================

set -e

echo "=== YAROTECH Server Setup ==="

# ---- 1. Install required packages ----
echo "[1/7] Installing packages..."
apt-get update -qq
apt-get install -y nginx php8.1-fpm php8.1-mysql php8.1-curl php8.1-gd \
    php8.1-mbstring php8.1-xml php8.1-zip php8.1-fileinfo php8.1-intl unzip

# ---- 2. Detect PHP version ----
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
echo "Detected PHP version: $PHP_VER"

# ---- 3. Fix PHP upload settings ----
echo "[2/7] Configuring PHP upload limits..."
PHP_INI="/etc/php/${PHP_VER}/fpm/php.ini"
if [ -f "$PHP_INI" ]; then
    sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 10M/' "$PHP_INI"
    sed -i 's/^post_max_size = .*/post_max_size = 12M/' "$PHP_INI"
    sed -i 's/^max_file_uploads = .*/max_file_uploads = 20/' "$PHP_INI"
    echo "  Updated $PHP_INI"
    systemctl restart php${PHP_VER}-fpm
else
    echo "  WARNING: $PHP_INI not found. Manually set upload_max_filesize=10M and post_max_size=12M"
fi

# ---- 4. Deploy code ----
echo "[3/7] Setting up directories..."
API_DIR="/var/www/yarotech-api"
FRONTEND_DIR="/var/www/yarotech-frontend"

mkdir -p "$API_DIR" "$FRONTEND_DIR"
mkdir -p "$API_DIR/public/uploads/products"

# ---- 5. Set permissions ----
echo "[4/7] Setting file permissions..."
chown -R www-data:www-data "$API_DIR"
chmod -R 775 "$API_DIR/public/uploads"
find "$API_DIR" -type d -exec chmod 755 {} \;

# ---- 6. Install Nginx configs ----
echo "[5/7] Installing Nginx configuration..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy the Nginx configs (or inline them)
cp "$SCRIPT_DIR/api-shop.yarotech.com.ng.conf" /etc/nginx/sites-available/
cp "$SCRIPT_DIR/shop.yarotech.com.ng.conf" /etc/nginx/sites-available/

ln -sf /etc/nginx/sites-available/api-shop.yarotech.com.ng.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/shop.yarotech.com.ng.conf /etc/nginx/sites-enabled/

# Remove default site if it conflicts
rm -f /etc/nginx/sites-enabled/default

# ---- 7. Test and reload Nginx ----
echo "[6/7] Testing Nginx configuration..."
nginx -t

echo "[7/7] Reloading Nginx..."
systemctl reload nginx

echo ""
echo "=== Setup Complete ==="
echo ""
echo "IMPORTANT: Before uploading, ensure:"
echo "  1. Your API code is in $API_DIR"
echo "  2. Your frontend build (dist/client/) is in $FRONTEND_DIR"
echo "  3. Your .env file exists at $API_DIR/.env"
echo "  4. Composer dependencies are installed: cd $API_DIR && composer install --no-dev"
echo "  5. DNS A records point to this server:"
echo "     - api-shop.yarotech.com.ng -> $(curl -s ifconfig.me)"
echo "     - shop.yarotech.com.ng     -> $(curl -s ifconfig.me)"
echo ""
echo "To enable HTTPS (recommended):"
echo "  apt-get install certbot python3-certbot-nginx"
echo "  certbot --nginx -d api-shop.yarotech.com.ng -d shop.yarotech.com.ng"
echo ""
echo "To verify upload works:"
echo "  curl -X POST https://api-shop.yarotech.com.ng/api/admin/products/images \\"
echo "    -H 'Authorization: Bearer YOUR_TOKEN' \\"
echo "    -F 'product_id=1' \\"
echo "    -F 'image=@test-image.jpg'"
