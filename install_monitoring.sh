#!/bin/bash
# Script ติดตั้ง Grafana + Prometheus + SNMP Exporter v0.23.0 บน RHEL/CentOS/RedHat
# ใช้สิทธิ root หรือ sudo

set -e

# -------------------------------
# Update และติดตั้ง dependency
# -------------------------------
echo "[1/6] Update packages..."
yum update -y
yum install -y wget tar curl firewalld

# -------------------------------
# สร้าง user สำหรับ prometheus และ snmp_exporter
# -------------------------------
echo "[2/6] Create users..."
id -u prometheus &>/dev/null || useradd --no-create-home --shell /bin/false prometheus
id -u snmp_exporter &>/dev/null || useradd --no-create-home --shell /bin/false snmp_exporter

# -------------------------------
# ติดตั้ง Prometheus
# -------------------------------
PROM_VERSION="2.54.1"
echo "[3/6] Install Prometheus v$PROM_VERSION..."
cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
mv prometheus-${PROM_VERSION}.linux-amd64 prometheus
rm -f prometheus-${PROM_VERSION}.linux-amd64.tar.gz

mkdir -p /etc/prometheus /var/lib/prometheus
cp /opt/prometheus/prometheus /usr/local/bin/
cp /opt/prometheus/promtool /usr/local/bin/
cp -r /opt/prometheus/consoles /opt/prometheus/console_libraries /etc/prometheus/

chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# ไฟล์ config (ยังว่าง)
cat <<EOF > /etc/prometheus/prometheus.yml
# Prometheus config (กำหนด targets เองทีหลัง)
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
EOF

chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Systemd service
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.listen-address=:9090

[Install]
WantedBy=multi-user.target
EOF

# -------------------------------
# ติดตั้ง SNMP Exporter v0.23.0
# -------------------------------
SNMP_VERSION="0.23.0"
echo "[4/6] Install SNMP Exporter v$SNMP_VERSION..."
cd /opt
wget https://github.com/prometheus/snmp_exporter/releases/download/v${SNMP_VERSION}/snmp_exporter-${SNMP_VERSION}.linux-amd64.tar.gz
tar -xvf snmp_exporter-${SNMP_VERSION}.linux-amd64.tar.gz
mv snmp_exporter-${SNMP_VERSION}.linux-amd64 snmp_exporter
rm -f snmp_exporter-${SNMP_VERSION}.linux-amd64.tar.gz

cp /opt/snmp_exporter/snmp_exporter /usr/local/bin/

# ไฟล์ config SNMP (ยังว่าง)
mkdir -p /etc/snmp_exporter
cat <<EOF > /etc/snmp_exporter/snmp.yml
# SNMP Exporter config (เพิ่ม target เองทีหลัง)
# ตัวอย่าง:
# modules:
#   if_mib:
#     walk: [sysUpTime, ifTable, ifXTable]
#     version: 2
#     auth:
#       community: public
EOF

chown -R snmp_exporter:snmp_exporter /etc/snmp_exporter

# Systemd service
cat <<EOF > /etc/systemd/system/snmp_exporter.service
[Unit]
Description=Prometheus SNMP Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=snmp_exporter
ExecStart=/usr/local/bin/snmp_exporter \\
  --config.file=/etc/snmp_exporter/snmp.yml \\
  --web.listen-address=:9116

[Install]
WantedBy=multi-user.target
EOF

# -------------------------------
# ติดตั้ง Grafana
# -------------------------------
echo "[5/6] Install Grafana..."
cat <<EOF > /etc/yum.repos.d/grafana.repo
[grafana]
name=Grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

yum install -y grafana

systemctl enable grafana-server
systemctl enable prometheus
systemctl enable snmp_exporter

# -------------------------------
# เปิด Firewall
# -------------------------------
echo "[6/6] Configure firewall..."
systemctl start firewalld
firewall-cmd --permanent --add-port=3000/tcp   # Grafana
firewall-cmd --permanent --add-port=9090/tcp   # Prometheus
firewall-cmd --permanent --add-port=9116/tcp   # SNMP Exporter
firewall-cmd --reload

# -------------------------------
# Start services
# -------------------------------
systemctl daemon-reexec
systemctl start prometheus
systemctl start snmp_exporter
systemctl start grafana-server

echo "✅ ติดตั้งเสร็จแล้ว!"
echo "Grafana:     http://<IP>:3000"
echo "Prometheus:  http://<IP>:9090"
echo "SNMP Export: http://<IP>:9116/metrics"
