# OAuthGate - Discord OAuth NGINX Reverse Proxy

This project allows securing an NGINX reverse proxied site via Discord OAuth with automatic HTTPS support.

## Prerequisites

- Docker and Docker Compose installed
- A domain name pointing to your server
- Discord Application credentials (Client ID and Secret)
- Basic understanding of NGINX and Docker

## Quick Start

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Configure Discord OAuth:
   - Go to [Discord Developer Portal](https://discord.com/developers/applications)
   - Create a new application or select an existing one
   - Under OAuth2, add your redirect URI: `https://your-domain.com/auth/callback`
   - Copy the Client ID and Client Secret

3. Update configuration files:

   a. Edit `source/OAuthGate/appsettings.json`:
   ```json
   {
     "DiscordOptions": {
       "AuthCookieName": "my-app-auth",
       "Client": {
         "Id": "YOUR_CLIENT_ID",
         "Secret": "YOUR_CLIENT_SECRET"
       }
     }
   }
   ```

   b. Edit `nginx/app.conf`:
   - Replace `YOUR_DOMAIN` with your actual domain
   - Update `proxy_pass http://your-app:3000` with your application's address

   c. Edit `init-letsencrypt.sh`:
   - Replace `YOUR_DOMAIN` with your domain
   - Update `your-email@example.com` with your email
   - Make the script executable: `chmod +x init-letsencrypt.sh`

4. Create required directories:
```bash
mkdir -p certbot/conf certbot/www
```

5. Initialize SSL certificates:
```bash
./init-letsencrypt.sh
```

6. Start the services:
```bash
docker-compose up -d
```

## Configuration Options

### Discord Authentication

The `appsettings.json` supports the following options:

- `AuthCookieName`: Name of the authentication cookie
- `Client.Id`: Discord Application Client ID
- `Client.Secret`: Discord Application Client Secret
- `WhitelistedUsers`: Array of Discord User IDs to allow
- `WhitelistedGuilds`: Array of Discord Guild IDs to allow
- `WhitelistedRoles`: Object mapping Guild IDs to Role IDs
- `EmailHandling`: How to handle Discord email ("None", "Log", or "LogAndRequire")

### Security Features

- Automatic HTTPS redirection
- SSL certificate auto-renewal
- Secure cookie handling
- Discord OAuth2 authentication
- Role-based access control
- Guild membership verification

## Monitoring

View container logs:
```bash
docker-compose logs -f
```

Check container status:
```bash
docker-compose ps
```

## SSL Certificate Renewal

Certificates auto-renew every 12 hours. To manually renew:
```bash
docker-compose run --rm certbot renew
```

## Troubleshooting

1. Check logs for specific services:
```bash
docker-compose logs -f oauthgate
docker-compose logs -f nginx
```

2. Verify SSL certificate:
```bash
docker-compose exec nginx nginx -t
```

3. Common issues:
   - 502 Bad Gateway: Check if your application is running
   - SSL errors: Verify domain configuration and certificate paths
   - Auth errors: Check Discord application credentials and callback URLs