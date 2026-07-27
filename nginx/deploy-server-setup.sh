#!/bin/bash
# ============================================================
# YAROTECH E-Commerce — Ubuntu/Nginx Server Setup
# Run this on your Ubuntu server as root or with sudo
# ============================================================

set -e

echo "=== YAROTECH Server Setup ==="

# ---- 1. Detect installed PHP version ----
echo "[1/7] Detecting PHP version..."
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;' 2>/dev/null || true)

if [ -z "$PHP_VER" ]; then
    echo "PHP not found. Installing PHP..."
    apt-get update -qq
    apt-get install -y php-fpm
    PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
fi

echo "Detected PHP version: $PHP_VER"

# ---- 2. Install required packages ----
echo "[2/7] Installing packages..."
apt-get update -qq
apt-get install -y nginx php${PHP_VER}-fpm php${PHP_VER}-mysql php${PHP_VER}-curl \
    php${PHP_VER}-gd php${PHP_VER}-mbstring php${PHP_VER}-xml php${PHP_VER}-zip \
    php${PHP_VER}-fileinfo php${PHP_VER}-intl unzip || \
apt-get install -y nginx php${PHP_VER}-fpm php${PHP_VER}-common php${PHP_VER}-curl \
    php${PHP_VER}-gd php${PHP_VER}-mbstring php${PHP_VER}-xml php${PHP_VER}-zip unzip

# ---- 3. Fix PHP upload settings ----
echo "[3/7] Configuring PHP upload limits..."
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

# ---- 4. Detect PHP-FPM socket path ----
SOCKET=$(ls /var/run/php/php${PHP_VER}-fpm.sock 2>/dev/null || true)
if [ -z "$SOCKET" ]; then
    echo "  WARNING: PHP-FPM socket not found at default path. Check with: ls /var/run/php/"
fi

# ---- 5. Deploy code ----
echo "[4/7] Setting up directories..."
API_DIR="/var/www/yarotech-api"
FRONTEND_DIR="/var/www/yarotech-frontend"

mkdir -p "$API_DIR" "$FRONTEND_DIR"
mkdir -p "$API_DIR/public/uploads/products"

# ---- 6. Set permissions ----
echo "[5/7] Setting file permissions..."
chown -R www-data:www-data "$API_DIR"
chmod -R 775 "$API_DIR/public/uploads"
find "$API_DIR" -type d -exec chmod 755 {} \;

# ---- 7. Install Nginx configs ----
echo "[6/7] Installing Nginx configuration..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Update socket path in API config before copying
sed "s|php8.1-fpm.sock|php${PHP_VER}-fpm.sock|g" \
    "$SCRIPT_DIR/api-shop.yarotech.com.ng.conf" > /etc/nginx/sites-available/api-shop.yarotech.com.ng.conf
cp "$SCRIPT_DIR/shop.yarotech.com.ng.conf" /etc/nginx/sites-available/

ln -sf /etc/nginx/sites-available/api-shop.yarotech.com.ng.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/shop.yarotech.com.ng.conf /etc/nginx/sites-enabled/

# Remove default site if it conflicts
rm -f /etc/nginx/sites-enabled/default

# ---- 8. Test and reload Nginx ----
echo "[7/7] Testing Nginx configuration..."
nginx -t

echo "Reloading Nginx..."
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
