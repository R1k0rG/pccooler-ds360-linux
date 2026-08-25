# PCCooler DS360 Display Driver for Linux 🐧
<img width="2560" height="1920" alt="work" src="https://github.com/user-attachments/assets/27ef0440-0e34-4754-9b04-f9bf188f1c07" />
🇺🇸 Native Linux display driver and systemd daemon for PCCooler DS360 AIO liquid cooler.  

🇷🇺 Драйвер и systemd-демон для управления экраном СЖО PCCooler DS360 под Linux.

## 🚀 Quick Installation & Autostart / Быстрая установка

Run this one-liner in your terminal to clone, install, and enable autostart on boot:  
Вставь эту строчку в терминал, чтобы автоматически клонировать, установить и добавить драйвер в автозагрузку:

```bash
git clone https://github.com/R1k0rG/pccooler-ds360-linux.git && cd pccooler-ds360-linux && bash install.sh
```

---

## 📊 Service Management / Управление службой

* **Check status / Проверить статус:**
```bash
sudo systemctl status pccooler-display.service
```


* **Restart driver / Перезапустить:**
```bash
sudo systemctl restart pccooler-display.service
```


* **Stop driver / Остановить:**
```bash
sudo systemctl stop pccooler-display.service
```



---

## 🗑️ Uninstallation / Удаление

To completely stop the daemon, remove the service, and clean up installed files:

*Чтобы полностью остановить и удалить драйвер из системы:*

```bash
cd pccooler-ds360-linux && bash uninstall.sh
```
