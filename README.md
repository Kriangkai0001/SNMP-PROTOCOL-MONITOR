# SNMP-PROTOCOL-MONITOR

---

## 📌 SNMP คืออะไร? มีหน้าที่อะไรในระบบเครือข่าย  

**SNMP (Simple Network Management Protocol)** คือ  
โปรโตคอลมาตรฐานสำหรับการบริหารจัดการและเฝ้าติดตามอุปกรณ์เครือข่าย เช่น:

- Router  
- Switch  
- Firewall  
- Server  
- Printer  
- IoT Device  

โดยช่วยให้ผู้ดูแลระบบสามารถ:

- ตรวจสอบสถานะและประสิทธิภาพของอุปกรณ์  
- ควบคุมอุปกรณ์บางส่วน  
- รับแจ้งเตือนอัตโนมัติเมื่อเกิดเหตุผิดปกติ  

---

## 🛠️ หน้าที่หลักของ SNMP  

SNMP ทำงานโดยมี 2 ฝ่าย:

- SNMP Manager (ผู้ร้องขอข้อมูล เช่น Prometheus + SNMP Exporter)  
- SNMP Agent (ฝังอยู่ในอุปกรณ์ เช่น Switch, Router)

ข้อมูลจะถูกจัดเก็บในรูปแบบโครงสร้างที่เรียกว่า MIB (Management Information Base)  

หน้าที่หลักของ SNMP มี 3 อย่าง:

1. 📥 Collect Information – ดึงข้อมูลสถานะของอุปกรณ์  
2. ⚙️ Set/Change Configuration – เปลี่ยนค่าคอนฟิกบางอย่าง (เช่น ปิด/เปิดพอร์ต)  
3. 🚨 Send Notification – ส่งแจ้งเตือน (Trap) เมื่อมีเหตุการณ์ผิดปกติ  

---

## 🔐 เวอร์ชันของ SNMP  

| เวอร์ชัน | ความสามารถ                     | ความปลอดภัย                        | เหมาะกับการใช้งาน           |
|----------|----------------------------------|--------------------------------------|-------------------------------|
| v1       | รุ่นเริ่มต้น, ใช้ basic command | ไม่มีการเข้ารหัส, ใช้ community     | ❌ ไม่แนะนำ                   |
| v2c      | เพิ่มความสามารถ (GetBulk)      | ยังไม่เข้ารหัส, ใช้ community        | ⚠️ ใช้ใน LAN ที่เชื่อถือได้  |
| v3       | เพิ่มการยืนยันตัวตน + เข้ารหัส | มี Auth & Encrypt (MD5/SHA, AES/DES) | ✅ เหมาะกับ production จริง  |

---

## 🧪 LAB – ตัวอย่างการใช้งาน SNMP ในระบบเครือข่าย  

![SNMP Lab](https://github.com/user-attachments/assets/7a668aad-a683-4c15-99f0-83169ff72bc8)

จากไดอะแกรมด้านบน:

- Core Switch ทำหน้าที่เป็นศูนย์กลาง เชื่อมต่อไปยังหลายโซน เช่น:
  - 🖥️ Monitor Zone  
  - 👤 User Zone  
  - 💾 Server Zone  
  - 🌐 DMZ  

ระบบมีการแยก Zone เพื่อ:

- แยกประเภทการใช้งาน  
- จำกัดสิทธิ์การเข้าถึง  
- ควบคุมและตรวจสอบทราฟฟิกได้ง่าย  
- เพิ่มความปลอดภัยโดยรวมของเครือข่าย  

Monitor Zone จะได้รับสิทธิ์พิเศษในการเข้าถึงอุปกรณ์ในทุกโซน เพื่อทำหน้าที่:

- ดึงข้อมูล SNMP จากอุปกรณ์ต่าง ๆ  
- ตรวจสอบสถานะและประสิทธิภาพ  
- สร้าง Dashboard และแจ้งเตือนอัตโนมัติ  

โดยใช้โปรโตคอล SNMP ในการสื่อสาร เช่น:

- ตรวจสอบ CPU, RAM, Interface, Uptime  
- รับ Trap แจ้งเตือนเหตุการณ์ผิดปกติ เช่น Link Down, CPU Overload  

Monitor Zone จึงเป็นศูนย์กลางสำคัญสำหรับระบบเฝ้าระวังและจัดการเครือข่าย 

---

 ---

## 🛠️ วิธีติดตั้งระบบ Monitoring บน Red Hat OS

สำหรับการติดตั้งระบบ Monitor (Prometheus + SNMP Exporter + Grafana) บน Red Hat / CentOS สามารถใช้สคริปต์อัตโนมัติได้ทันที

✅ ไฟล์สคริปต์: install_monitoring.sh

### ขั้นตอนการติดตั้ง

1. ดาวน์โหลดไฟล์ติดตั้ง:


```
wget https://raw.githubusercontent.com/Kriangkai0001/SNMP-PROTOCOL-MONITOR/main/install_monitoring.sh

```

ให้สิทธิ์รัน:
```
chmod +x install_monitoring.sh
```

เริ่มการติดตั้ง:
```
sudo ./install_monitoring.sh
```
---

## 🛠️ สคริปต์ติดตั้ง `install_monitoring.sh`

สคริปต์นี้ช่วยติดตั้งและตั้งค่าระบบ Monitoring บน Red Hat OS โดยอัตโนมัติ ประกอบด้วย

- การติดตั้ง Prometheus  
- การติดตั้ง SNMP Exporter v0.23.0  
- การติดตั้ง Grafana   
- การเปิดพอร์ตไฟร์วอลล์ที่จำเป็น  

หลังจากรันสคริปต์เสร็จ ผู้ใช้ต้องกำหนดค่าเองในไฟล์ดังนี้:

- `/etc/prometheus/prometheus.yml` — กำหนด targets และ scrape configs สำหรับ Prometheus  
- `/etc/snmp_exporter/snmp.yml` — กำหนดโมดูลและการเข้าถึง SNMP  
- ตั้งค่าหน้าเว็บ Grafana (Dashboard, Data source) ตามความต้องการ  

สคริปต์นี้ช่วยลดขั้นตอนการติดตั้งและตั้งค่าพื้นฐาน ทำให้พร้อมใช้งานและสามารถปรับแต่งเพิ่มเติมได้ทันที

---

## 🧪 ตัวอย่างการตั้งค่า Core Switch และ Prometheus เพื่อเก็บข้อมูลผ่าน SNMP
📟 1. คอนฟิก Cisco Core Switch (L3 Switch)
```
hostname cisco

! สร้าง VLAN 99
vlan 99
 name VLAN99
exit

! ตั้งค่า interface VLAN 99 พร้อม IP address (Gateway)
interface Vlan99
 ip address 192.168.99.1 255.255.255.0
 no shutdown
exit

! เปิด IP routing (ถ้าเป็น L3 switch)
ip routing

! ตั้งค่า SNMP community (readonly)
snmp-server community public RO

! เปิด SNMP traps ทั้งหมด
snmp-server enable traps

! ตั้งค่า SNMP trap receiver
snmp-server host 192.168.99.99 version 2c public

! บันทึก config
write memory
```

💡 หมายเหตุ:

192.168.99.1 คือ IP ของ Core Switch

192.168.99.99 คือ IP ของเครื่อง Prometheus + SNMP Exporter

community: public ใช้แบบ read-only

---

📦 2. ตั้งค่า Prometheus (prometheus.yml)
```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cisco'  # ชื่อตั้งเองได้
    metrics_path: /snmp
    params:
      module: [cisco]  # ต้องตรงกับชื่อ module ใน snmp.yml
    static_configs:
      - targets:
          - 192.168.99.1  # IP ของ Core Switch
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9116  # ที่อยู่ SNMP Exporter
```
---

⚙️ 3. ตั้งค่า SNMP Exporter (snmp.yml)
```
auths:
  public_v2:
    community: public
    version: 2c

modules:
  cisco:
    walk:
      - 1.3.6.1.2.1.1      # system


```
---

🔑 community: ต้องตรงกับที่ตั้งไว้ใน Switch (public)
🔁 version: 2c ต้องตรงกันทั้ง Prometheus และ Switch

🧪 4. ทดสอบ SNMP ด้วย snmpwalk
```
snmpwalk -v2c -c public 192.168.99.1
```

หากแสดงค่า SNMP เช่น system name, uptime, interfaces แปลว่าใช้งานได้ ✅

🖥️ 5. เข้าหน้า Prometheus UI

เปิดผ่านเบราว์เซอร์:
```
http://<localhost>:9090
```

ทดลองเช็ค status เช่น:
```
up
```

เพื่อดูสถานะการทำงานของพอร์ตบน Core Switch แบบ Real-time
