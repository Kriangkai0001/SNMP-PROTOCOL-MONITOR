# SNMP-PROTOCOL-MONITOR
<html>
<body>
<hr>
<h1>SNMP-PROTOCOL  คืออะไรมีหน้าที่ทำอะไรในระบบเครือข่าย</h1>
<p>SNMP (Simple Network Management Protocol) คือ <strong>โปรโตคอลมาตรฐานสำหรับบริหารจัดการและเฝ้าติดตามอุปกรณ์เครือข่าย</strong> เช่น Router, Switch, Firewall, Server, Printer และ IoT ต่าง ๆ ช่วยให้ผู้ดูแลระบบสามารถดูสถานะ/สถิติ ควบคุมบางส่วน และรับการแจ้งเตือนอัตโนมัติเมื่อเกิดเหตุผิดปกติ</p>

---

#  หน้าที่จริง ๆ ของ SNMP

SNMP ถูกออกแบบมาเพื่อ **“แลกเปลี่ยนข้อมูลการจัดการอุปกรณ์เครือข่าย”** ระหว่าง **Manager ↔ Agent** โดยใช้โครงสร้าง **MIB (Management Information Base)**

หน้าที่หลักจริง ๆ มีเพียง 3 อย่าง:

### 1. **Collect Information (ดึงข้อมูลสถานะ)**

### 2. **Set/Change Configuration (เปลี่ยนค่าบางอย่าง)**

### 3. **Send Notification (แจ้งเตือนเหตุการณ์)**
---

<h2>🔐 เวอร์ชันของ SNMP มีอะไรบ้าง</h2>

เวอร์ชัน | ความสามารถ | ความปลอดภัย | ใช้งานจริงแนะนำ
-- | -- | -- | --
v1 | รุ่นแรก พื้นฐาน | ไม่มีการเข้ารหัส ใช้ community | ❌
v2c | เพิ่มประสิทธิภาพ (GetBulk) | ยังไม่เข้ารหัส ใช้ community | ⚠️ ใช้ในแลนที่ไว้ใจกัน
v3 | Auth / Privacy (เข้ารหัส) | มี auth & encrypt (MD5/SHA, DES/AES) | ✅ แนะนำ


</body>
</html>
