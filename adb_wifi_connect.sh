#!/bin/bash

PORT=5555

echo "=============================="
echo "ADB Wi-Fi auto connect script"
echo "=============================="

echo ""
echo "[1/7] Перезапуск ADB сервера..."
adb kill-server
adb start-server

sleep 1

echo ""
echo "[2/7] Проверка USB-подключения..."
ADB_USB=$(adb devices | grep -w "device" | grep -v ":")

if [ -z "$ADB_USB" ]; then
  echo "❌ Устройство по USB не найдено"
  echo "➡ Подключи телефон кабелем и разреши USB debugging"
  exit 1
fi

echo "✅ USB устройство найдено"

echo ""
echo "[3/7] Переключение ADB в TCP/IP режим..."
adb tcpip $PORT

sleep 2

echo ""
echo "[4/7] Получение IP адреса телефона..."
PHONE_IP=$(adb shell ip route | awk '{print $9}')

if [ -z "$PHONE_IP" ]; then
  echo "❌ Не удалось получить IP телефона"
  exit 1
fi

echo "📱 IP телефона: $PHONE_IP"

echo ""
echo "[5/7] Отключение старых Wi-Fi подключений..."
adb disconnect $PHONE_IP:$PORT >/dev/null 2>&1

echo ""
echo "[6/7] Подключение по Wi-Fi..."
adb connect $PHONE_IP:$PORT

sleep 1

echo ""
echo "[7/7] Проверка статуса устройства..."
adb devices

echo ""
echo "=============================="
echo "Если статус DEVICE — можно вытаскивать кабель"
echo "Если OFFLINE — см. инструкции ниже"
echo "=============================="
