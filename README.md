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

จากไดอาแกรมด้านบน:

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




