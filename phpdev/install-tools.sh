# Prepare directories where we will install some extra tools
mkdir -p /app/tools/php-cs-fixer && mkdir /app/tools/bin

# Install php-cs-fixer
composer require --dev --working-dir=/app/tools/php-cs-fixer friendsofphp/php-cs-fixer
ln -s /app/tools/php-cs-fixer/vendor/bin/php-cs-fixer /app/tools/bin/php-cs-fixer

# Install PHP Actor
git clone https://github.com/phpactor/phpactor.git /app/tools/phpactor
cd /app/tools/phpactor
composer install
ln -s /app/tools/phpactor/bin/phpactor /app/tools/bin/phpactor
