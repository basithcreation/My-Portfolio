<div align="center">

<!-- Animated typing header -->
<img src="https://readme-typing-svg.demolab.com?font=Plus+Jakarta+Sans&weight=900&size=36&pause=1000&color=6366F1&center=true&vCenter=true&width=600&lines=Abdul+Basith+Portfolio;Flutter+Developer;IT+Administrator;KPOST+Couriers+%7C+Kuwait" alt="Typing SVG" />

<br/>

<!-- Tech stack badges -->

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-6366F1?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-22D3EE?style=for-the-badge&logo=javascript&logoColor=black)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

<br/>

<!-- Status badges -->

![Status](https://img.shields.io/badge/Status-Live-22d3ee?style=flat-square&labelColor=050810)
![Theme](https://img.shields.io/badge/Theme-Dark%20Only-6366f1?style=flat-square&labelColor=050810)
![Responsive](https://img.shields.io/badge/Responsive-320px%20→%202560px-22d3ee?style=flat-square&labelColor=050810)
![No Framework](<https://img.shields.io/badge/Framework-None%20(Vanilla)-6366f1?style=flat-square&labelColor=050810>)
![Cloud DB](https://img.shields.io/badge/DB-JSONBin.io%20Free-22d3ee?style=flat-square&labelColor=050810)

</div>

---

## ✨ Live Features

<table>
<tr>
<td>

**UI / Animation**

- Animated gradient mesh background
- Custom cursor with glow trail
- AOS scroll-reveal on every section
- Loader with live percentage counter
- Marquee skill ticker strip
- Glassmorphism cards & modals

</td>
<td>

**Sections**

- Hero with outlined + gradient title
- About, Skills (16+ Devicons)
- Projects — filterable card grid
- Experience — vertical timeline
- Contact + WhatsApp CTA

</td>
<td>

**Admin / Data**

- Password-protected admin panel
- Add / Edit / Delete projects live
- Data persists to JSONBin.io cloud
- Works fully without backend setup

</td>
</tr>
</table>

---

## 📸 Application Screenshots

> Add your screenshots to a `screenshots/` folder in the repo root, then the images below will appear automatically.

<div align="center">

|         Hero Section          |             Projects Grid             |
| :---------------------------: | :-----------------------------------: |
| ![Hero](screenshots/hero.png) | ![Projects](screenshots/projects.png) |

|          Skills Section           |           Contact Section           |
| :-------------------------------: | :---------------------------------: |
| ![Skills](screenshots/skills.png) | ![Contact](screenshots/contact.png) |

|           Admin Panel           |            Mobile View            |
| :-----------------------------: | :-------------------------------: |
| ![Admin](screenshots/admin.png) | ![Mobile](screenshots/mobile.png) |

</div>

> **How to add your screens:**
>
> 1. Take screenshots of the portfolio in browser
> 2. Create a `screenshots/` folder in the project root
> 3. Save as: `hero.png`, `projects.png`, `skills.png`, `contact.png`, `admin.png`, `mobile.png`
> 4. Push to GitHub — they appear above automatically

---

## 📁 Project Structure

```
basith-portfolio/
│
├── 📄 index.html          ← All sections (single-page)
├── 📁 css/
│   └── main.css           ← Variables · Layout · Animations · Responsive
├── 📁 js/
│   ├── db.js              ← JSONBin.io cloud database layer
│   └── app.js             ← Loader · Cursor · AOS · Counter · Admin panel
├── 📁 screenshots/        ← Add your app screenshots here
└── 📄 README.md
```

---

## 🚀 Deploy to GitHub Pages (Free)

```bash
# 1. Create a new GitHub repo named "portfolio"
# 2. Upload all files keeping the folder structure
# 3. Go to: Settings → Pages → Source: Deploy from branch (main)
# Your site will be live at:
https://yourusername.github.io/portfolio
```

---

## 🗄️ Setup Free Cloud Database

<details>
<summary><b>Click to expand — JSONBin.io setup (5 minutes)</b></summary>

<br/>

1. Go to **https://jsonbin.io** → Sign Up _(free, no credit card)_
2. Click **"NEW BIN"** → paste the JSON below → Save:
   ```json
   { "projects": [] }
   ```
3. Copy the **BIN ID** from the URL _(e.g. `6634abc123def456…`)_
4. Go to **Account → API Keys** → Create a key → Copy it
5. Open [js/db.js](js/db.js) and replace lines 1–3:
   ```js
   const BIN_ID = "YOUR_BIN_ID_HERE"; // ← paste your bin ID
   const API_KEY = "YOUR_API_KEY_HERE"; // ← paste your API key
   const ADMIN_PW = "your-password"; // ← set your admin password
   ```

**Done!** Visit your live site → scroll to Projects → click **"Manage Projects"** → enter your password → add projects → they save permanently to the cloud.

</details>

---

## 🔐 Admin Panel

| Action               | Steps                                                    |
| :------------------- | :------------------------------------------------------- |
| **Open admin**       | Scroll to Projects section → click **"Manage Projects"** |
| **Default password** | `basith@2025` — change in [js/db.js](js/db.js) line 44   |
| **Add project**      | Fill the form → click **Add Project**                    |
| **Edit project**     | Click **Edit** on any project card                       |
| **Delete project**   | Click **Delete** on any project card                     |

---

## ✏️ Customization Cheatsheet

| What to change     | File                                                    | Find / Replace                     |
| :----------------- | :------------------------------------------------------ | :--------------------------------- |
| Name, email, phone | [index.html](index.html)                                | Search & replace text              |
| WhatsApp number    | [index.html](index.html)                                | `96566099743`                      |
| Instagram handle   | [index.html](index.html)                                | `basith_creation`                  |
| Accent colors      | [css/main.css](css/main.css)                            | `:root` → `--a1`, `--a2`           |
| Display font       | [index.html](index.html) + [css/main.css](css/main.css) | Google Fonts link + `--ff-display` |
| Admin password     | [js/db.js](js/db.js)                                    | line 44 — `ADMIN_PW`               |

---

## 🎨 Design Tokens

```css
/* css/main.css — :root */
--bg: #050810; /* page background   */
--a1: #6366f1; /* indigo accent     */
--a2: #22d3ee; /* cyan accent       */
--text: #e2e8f0; /* body text         */
--glass: rgba(255, 255, 255, 0.04); /* card background */
```

---

## 🤖 Regenerate with Claude Code

<details>
<summary><b>Click to copy the full Claude prompt</b></summary>

```
I need a production-grade personal portfolio website for Abdul Basith,
a Flutter Developer & IT Administrator based in Kuwait.

DESIGN REQUIREMENTS:
- 2025 modern style: massive outlined hero text, glassmorphism cards,
  animated gradient mesh background (indigo + cyan orbs), floating tech badges,
  smooth AOS scroll animations, custom cursor, marquee ticker
- Dark theme only: bg #050810, accent indigo #6366f1 + cyan #22d3ee
- Fonts: Plus Jakarta Sans (display, 900 weight) + JetBrains Mono (mono)
- Fully responsive: mobile-first, works on 320px to 2560px screens
- All Devicons tech logos (Flutter, Dart, Firebase, PHP, MySQL, Git, etc)
- Font Awesome 6 icons throughout

SECTIONS (in order):
1. Loader (progress bar with percentage)
2. Navbar (logo AB. + links + Hire Me button + burger menu)
3. Hero (outlined "Flutter" / solid "Developer" / gradient "Admin" title,
         profile card with floating tech pills, animated stats row)
4. Marquee ticker strip
5. About (glass card with avatar/info + text with highlights)
6. Skills (4 category cards + tech icon grid with 16+ devicons)
7. Projects (filterable grid, loaded from JSONBin.io free DB,
             admin panel with password to add/edit/delete projects)
8. Experience (vertical timeline with dot icons)
9. Contact (contact links + WhatsApp CTA card)
10. Footer

TECH STACK:
- Pure HTML + CSS + Vanilla JS (no frameworks)
- Well-structured: index.html + css/main.css + js/db.js + js/app.js
- JSONBin.io as free cloud DB for projects (configurable, works without setup)
- Admin panel protected by password in db.js

PERSONAL DETAILS:
- Name: Abdul Basith
- Role: Flutter Developer & IT Administrator
- Company: KPOST Couriers Co., Kuwait
- Email: abbasith222@gmail.com
- WhatsApp: +965 66099743
- Instagram: @basith_creation
- Education: B.Sc IT, Jamal Mohamed College (2017–2020)
- Languages: English, Arabic, Hindi, Tamil, Malayalam
```

</details>

---

<div align="center">

## 📞 Contact

[![Email](https://img.shields.io/badge/Email-abbasith222%40gmail.com-6366f1?style=for-the-badge&logo=gmail&logoColor=white)](mailto:abbasith222@gmail.com)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-%2B965%2066099743-22d3ee?style=for-the-badge&logo=whatsapp&logoColor=white)](https://wa.me/96566099743)
[![Instagram](https://img.shields.io/badge/Instagram-%40basith__creation-6366f1?style=for-the-badge&logo=instagram&logoColor=white)](https://instagram.com/basith_creation)

<br/>

_Built with pure HTML · CSS · Vanilla JS — no frameworks, no build tools, just clean code._

![Wave](https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=12,14,20,24&height=120&section=footer&fontSize=24)

</div>
