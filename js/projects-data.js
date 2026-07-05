/**
 * ═══════════════════════════════════════════════
 * projects-data.js — Single source of truth for projects
 * ═══════════════════════════════════════════════
 *
 * This static file IS the database. No cloud, no API keys.
 *
 * TO ADD / EDIT PROJECTS:
 *   Option A — open the site locally, click "Manage Projects",
 *              edit in the form → an updated copy of this file
 *              downloads automatically → replace this file.
 *   Option B — edit this array by hand (keep the same fields).
 *
 * Then publish:  git add js/projects-data.js
 *                git commit -m "Update projects"
 *                git push
 * GitHub Pages redeploys automatically.
 * ═══════════════════════════════════════════════
 */

const PROJECTS_DATA = [
  {
    id: 'p001', order: 1, status: 'Live', category: 'Mobile App',
    title: 'KPOST HR Management Application',
    description: 'Multi-module enterprise HR platform for KPOST Couriers, Kuwait. Covers the full employee lifecycle with GPS attendance verification, role-based permission gating, Arabic RTL support, and real-time push notifications. Built across 166 Dart files with clean architecture and migrated from GetX to Riverpod + go_router with zero feature regression.',
    tech: ['Flutter', 'Dart', 'Riverpod', 'go_router', 'Firebase FCM', 'Google Maps', 'GPS', 'REST API', 'MySQL', 'PDF', 'Syncfusion Excel'],
    features: ['GPS Attendance Verification', 'Role-Based Permission System', 'Leave & Vacation Requests', 'Shift Scheduling', 'NOC Certificate Generation', 'PDF Report Export (Dart Isolates)', 'Push Notifications', 'Arabic RTL Support', 'Support Ticket System', 'Digital Signatures'],
    url: '', createdAt: '2024-01-01'
  },
  {
    id: 'p002', order: 2, status: 'Live', category: 'Mobile App',
    title: 'IT Asset & Inventory Tracker (KPOST IT)',
    description: 'Centralized mobile solution to manage company IT assets, track device assignments, monitor inventory status, and provide secure admin controls across departments via QR code scanning.',
    tech: ['Flutter', 'Dart', 'GetX', 'QR Scanner', 'REST API', 'MySQL'],
    features: ['QR Code Asset Scanning', 'Device Assignment Tracking', 'Inventory Dashboard', 'Admin Controls', 'Department Routing', 'Audit Logs'],
    url: '', createdAt: '2024-03-01'
  },
  {
    id: 'p003', order: 3, status: 'Live', category: 'Mobile App',
    title: 'KACT Charity Management System',
    description: 'Full-featured charity management app for Kattimedu Adirangam Charity Trust. Manages donations, members, events, and financial reporting with real-time Firebase sync, analytics charts, and PDF/Excel export.',
    tech: ['Flutter', 'Dart', 'Riverpod', 'GoRouter', 'Firebase Auth', 'Firestore', 'Firebase Storage', 'FCM', 'fl_chart', 'PDF', 'Syncfusion Excel', 'Hive'],
    features: ['Donation Management', 'Member Registry', 'Event Tracking', 'Financial Reports (PDF/Excel)', 'Real-time Firebase Sync', 'Analytics Charts (fl_chart)', 'Infinite Pagination', 'Offline Caching (Hive)'],
    url: '', createdAt: '2024-06-01'
  },
  {
    id: 'p004', order: 4, status: 'Live', category: 'Mobile App',
    title: 'Document Keeper Kuwait',
    description: 'Secure personal document storage app targeting Kuwait residents. All documents are encrypted at rest with AES-256 and unlocked exclusively via biometric authentication (fingerprint/face ID). Includes in-app PDF/photo viewer, file compression, and Google Ads monetization.',
    tech: ['Flutter', 'Dart', 'Riverpod', 'Hive', 'AES Encryption', 'local_auth (Biometric)', 'pdfx', 'Google Ads'],
    features: ['AES-256 Encrypted Storage', 'Fingerprint / Face ID Unlock', 'In-App PDF & Photo Viewer', 'File Compression', 'Archive Support', 'Google Ads Integration', 'Zero-Knowledge Architecture'],
    url: '', createdAt: '2024-09-01'
  },
  {
    id: 'p005', order: 5, status: 'Completed', category: 'Mobile App',
    title: 'Billing App — POS & Invoicing System',
    description: 'Full-featured POS and invoicing system for retail and restaurant use. Integrates Bluetooth ESC/POS thermal printer for instant receipts, barcode/QR product scanning, PDF invoice generation, Excel export, and Firebase Auth. Local product catalog cached via Hive for offline use.',
    tech: ['Flutter', 'Dart', 'BLoC', 'GoRouter', 'Firebase Auth', 'Hive', 'Bluetooth Thermal Printer', 'Barcode Scanner', 'PDF', 'Syncfusion Excel'],
    features: ['Bluetooth ESC/POS Thermal Printing', 'Barcode / QR Product Scanning', 'PDF Invoice Generation', 'Excel Export (Syncfusion)', 'Offline Product Catalog (Hive)', 'Firebase Auth', 'Real-time Cart & Billing'],
    url: '', createdAt: '2024-05-01'
  },
  {
    id: 'p006', order: 6, status: 'Live', category: 'Mobile App',
    title: 'Shipment Pickup Tracker',
    description: 'Real-time courier shipment tracking and pickup management app with foreground GPS service, in-app document scanning, OTA updates (no Play Store required), and Sentry crash reporting for production monitoring.',
    tech: ['Flutter', 'Dart', 'ObjectBox', 'GPS / Geolocator', 'flutter_doc_scanner', 'Sentry', 'OTA Updates', 'Foreground Service'],
    features: ['Real-time GPS Tracking', 'In-App Document Scanning', 'OTA In-App Updates', 'Sentry Crash Analytics', 'ObjectBox Local Database', 'Foreground Service (Background GPS)', 'Shipment Status Updates'],
    url: '', createdAt: '2024-04-01'
  },
  {
    id: 'p007', order: 7, status: 'Live', category: 'Mobile App',
    title: 'My Bachelor Rooms',
    description: 'Real-time roommate and room management app with QR code entry, offline-first architecture using Drift/SQLite, and Supabase real-time sync. Built with Freezed data models and clean repository pattern.',
    tech: ['Flutter', 'Dart', 'Riverpod', 'GoRouter', 'Supabase', 'Drift / SQLite', 'QR Code', 'Freezed'],
    features: ['QR Code Room Entry', 'Real-time Supabase Sync', 'Offline-first (Drift/SQLite)', 'Freezed Data Models', 'Room Assignment Management', 'Roommate Profiles'],
    url: '', createdAt: '2023-11-01'
  }
];
