# Albion Online Build Generator - Docker Deployment

This package contains everything you need to self-host the Albion Online Build Generator using Docker.

This was 99% coded with Claude :D So yeah, might not be accurate and have lots of broken stuff. Feel free to submit a PR to fix anything.

Like what you see? Consider using my referral link - https://albiononline.com/ref/EN5QKEN9TH

Enjoy!

## 📁 File Structure

```
albion-build-generator/
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── index.html
├── README.md
└── scripts/
    ├── deploy.sh
    └── update.sh
```

## 🚀 Quick Start

### Prerequisites
- Docker installed on your system
- Docker Compose installed
- At least 100MB free disk space

### Option 1: Using Docker Compose (Recommended)

1. **Create the project directory:**
   ```bash
   mkdir albion-build-generator
   cd albion-build-generator
   ```

2. **Save all the provided files in this directory:**
   - `Dockerfile`
   - `docker-compose.yml` 
   - `nginx.conf`
   - `index.html` (the HTML file from the previous artifact)

3. **Build and start the container:**
   ```bash
   docker-compose up -d
   ```

4. **Access the application:**
   Open your browser and go to `http://localhost:8080`

### Option 2: Using Docker directly

1. **Build the image:**
   ```bash
   docker build -t albion-build-generator .
   ```

2. **Run the container:**
   ```bash
   docker run -d \
     --name albion-build-generator \
     -p 8080:80 \
     --restart unless-stopped \
     albion-build-generator
   ```

3. **Access the application:**
   Open your browser and go to `http://localhost:8080`

## 🛠️ Configuration Options

### Port Configuration
To use a different port, modify the `docker-compose.yml`:
```yaml
ports:
  - "3000:80"  # Change 3000 to your desired port
```

### Custom Domain
If you want to use a custom domain:

1. **Update nginx.conf:**
   ```nginx
   server_name yourdomain.com www.yourdomain.com;
   ```

2. **Update docker-compose.yml for Traefik (optional):**
   ```yaml
   labels:
     - "traefik.http.routers.albion.rule=Host(`yourdomain.com`)"
   ```

### SSL/HTTPS Setup
For production deployment with SSL, you can use:

1. **Traefik (recommended):**
   ```yaml
   labels:
     - "traefik.enable=true"
     - "traefik.http.routers.albion.rule=Host(`yourdomain.com`)"
     - "traefik.http.routers.albion.tls.certresolver=letsencrypt"
   ```

2. **Nginx Proxy Manager:** Use as a reverse proxy with automatic SSL

3. **Cloudflare:** Put your domain behind Cloudflare for SSL termination

## 🔧 Management Commands

### Start the service
```bash
docker-compose up -d
```

### Stop the service
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f
```

### Restart the service
```bash
docker-compose restart
```

### Update the application
```bash
# Pull latest changes
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 📊 Monitoring

### Health Check
The container includes a health check endpoint:
```bash
curl http://localhost:8080/health
```

### Container Stats
```bash
docker stats albion-build-generator
```

### Logs
```bash
docker logs albion-build-generator
```

## 🔒 Security Considerations

The nginx configuration includes several security headers:
- X-Frame-Options: Prevents clickjacking
- X-XSS-Protection: Enables XSS filtering
- X-Content-Type-Options: Prevents MIME sniffing
- Content-Security-Policy: Restricts resource loading

For production deployment:
1. Use HTTPS (SSL/TLS)
2. Keep Docker updated
3. Consider using a reverse proxy
4. Implement proper firewall rules

## 🐛 Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs

# Check if port is in use
netstat -tulpn | grep :8080
```

### Permission issues
```bash
# Fix file permissions
chmod 644 index.html nginx.conf
chmod 755 Dockerfile docker-compose.yml
```

### Memory issues
```bash
# Check container resources
docker stats
```

## 📈 Scaling

For high-traffic deployments:

1. **Use multiple replicas:**
   ```yaml
   deploy:
     replicas: 3
   ```

2. **Add load balancing with Traefik or nginx**

3. **Use Docker Swarm or Kubernetes**

## 🔄 Backup

Important files to backup:
- `index.html` (your application)
- `nginx.conf` (configuration)
- `docker-compose.yml` (deployment config)

```bash
# Create backup
tar -czf albion-backup-$(date +%Y%m%d).tar.gz index.html nginx.conf docker-compose.yml
```

## 📞 Support

The container runs on:
- **Base Image:** nginx:alpine (lightweight, secure)
- **Exposed Port:** 80 (mapped to host port 8080)
- **Health Check:** Available at `/health`
- **Resource Usage:** ~10MB RAM, minimal CPU

For issues:
1. Check the logs: `docker-compose logs`
2. Verify file permissions
3. Ensure port 8080 is not in use
4. Test with `curl http://localhost:8080/health`