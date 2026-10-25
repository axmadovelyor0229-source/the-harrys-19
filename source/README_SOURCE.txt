Исходники V20 для разработчика.

work/index.html  — V19 с точечными исправлениями; логотип заменён меткой __LOGO__, место вставки слоя — /*__V20_LAYER__*/
src/v20.css      — дизайн-система V20 (вставляется в конец <style>)
src/v20_core.js  — слой V20: стабильность, CEO, финансы, цепочки склада, инвентаризация, мобильные таблицы
src/v20_excel.js — движок Excel-отчётов и выгрузки
src/v20_boot.js  — вход, demo-данные операций, загрузка
orig/logo.b64    — логотип (data URI), хранится в CSS один раз

Сборка (Windows PowerShell):  powershell -ExecutionPolicy Bypass -File build.ps1
Результат: work/app.html — это и есть готовый index.html
