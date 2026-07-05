/**
 * app.js — Abdul Basith Portfolio
 * Loader · Cursor · Nav · AOS · Counter · Ticker
 * Projects render · Filter · Admin panel
 */

/* ══════════════════════════════════════
   STATE
══════════════════════════════════════ */
let projects = [];
let isAdmin  = false;
let editId   = null;

/* ══════════════════════════════════════
   LOADER
══════════════════════════════════════ */
const loader    = document.getElementById('loader');
const loaderBar = document.getElementById('loaderBar');
const loaderPct = document.getElementById('loaderPct');

let pct = 0;
const loaderInterval = setInterval(() => {
  pct += Math.random() * 18;
  if (pct >= 100) { pct = 100; clearInterval(loaderInterval); hideLoader(); }
  loaderBar.style.width = pct + '%';
  loaderPct.textContent = Math.round(pct) + '%';
}, 120);

function hideLoader() {
  setTimeout(() => {
    loader.classList.add('hide');
    document.body.classList.remove('loading');
    triggerAOS();
  }, 300);
}

/* ══════════════════════════════════════
   CURSOR (desktop only)
══════════════════════════════════════ */
const cDot  = document.getElementById('cDot');
const cRing = document.getElementById('cRing');
let mx = 0, my = 0, rx = 0, ry = 0;

if (window.matchMedia('(hover:hover)').matches) {
  document.addEventListener('mousemove', e => {
    mx = e.clientX; my = e.clientY;
    cDot.style.left = mx + 'px'; cDot.style.top = my + 'px';
    const spotlight = document.getElementById('cursorSpotlight');
    if (spotlight) {
      spotlight.classList.add('active');
      spotlight.style.background = `radial-gradient(circle 300px at ${e.clientX}px ${e.clientY}px, rgba(200,245,66,0.04) 0%, transparent 70%)`;
    }
  });
  (function animRing() {
    rx += (mx - rx) * .11; ry += (my - ry) * .11;
    cRing.style.left = rx + 'px'; cRing.style.top = ry + 'px';
    requestAnimationFrame(animRing);
  })();
  document.querySelectorAll('a, button, .tig-item, .proj-card, .skill-cat-card').forEach(el => {
    el.addEventListener('mouseenter', () => cRing.classList.add('active'));
    el.addEventListener('mouseleave', () => cRing.classList.remove('active'));
  });
}

/* ══════════════════════════════════════
   NAV
══════════════════════════════════════ */
const navWrap    = document.getElementById('navWrap');
const burger     = document.getElementById('burger');
const mobMenu    = document.getElementById('mobMenu');
const mobOverlay = document.getElementById('mobOverlay');
const scrollBar  = document.getElementById('scrollProgress');
const orbO1      = document.querySelector('.o1');
const orbO2      = document.querySelector('.o2');
const orbO3      = document.querySelector('.o3');
const orbO4      = document.querySelector('.o4');

window.addEventListener('scroll', () => {
  const sy = window.scrollY;
  navWrap.classList.toggle('scrolled', sy > 60);
  document.getElementById('backTop').classList.toggle('show', sy > 400);

  // Scroll progress bar
  if (scrollBar) {
    const pct = sy / (document.documentElement.scrollHeight - window.innerHeight) * 100;
    scrollBar.style.width = Math.min(pct, 100) + '%';
  }

  // Hero orb parallax
  if (sy === 0) {
    if (orbO1) orbO1.style.transform = '';
    if (orbO2) orbO2.style.transform = '';
    if (orbO3) orbO3.style.transform = '';
    if (orbO4) orbO4.style.transform = '';
  } else {
    if (orbO1) orbO1.style.transform = `translateY(${sy * 0.2}px)`;
    if (orbO2) orbO2.style.transform = `translateY(${sy * -0.15}px)`;
    if (orbO3) orbO3.style.transform = `translateY(${sy * 0.1}px)`;
    if (orbO4) orbO4.style.transform = `translateY(${sy * -0.08}px)`;
  }
}, { passive: true });

function openMenu() {
  mobMenu.classList.add('open');
  mobOverlay.classList.add('open');
  document.body.style.overflow = 'hidden';
}
function closeMenu() {
  mobMenu.classList.remove('open');
  mobOverlay.classList.remove('open');
  document.body.style.overflow = '';
}

burger.addEventListener('click', () =>
  mobMenu.classList.contains('open') ? closeMenu() : openMenu()
);
mobOverlay.addEventListener('click', closeMenu);
document.querySelectorAll('.mob-link').forEach(l => l.addEventListener('click', closeMenu));

// Back to top
document.getElementById('backTop').addEventListener('click', () =>
  window.scrollTo({ top: 0, behavior: 'smooth' })
);

/* ══════════════════════════════════════
   AOS (Animate On Scroll)
══════════════════════════════════════ */
function triggerAOS() {
  const items = document.querySelectorAll('[data-aos]');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        const delay = +(e.target.dataset.aosDelay || 0);
        setTimeout(() => e.target.classList.add('aos-in'), delay);
        observer.unobserve(e.target);
      }
    });
  }, { threshold: 0.1 });
  items.forEach(el => observer.observe(el));
}

/* ══════════════════════════════════════
   STAT COUNTERS
══════════════════════════════════════ */
function startCounters() {
  document.querySelectorAll('.stat-num').forEach(el => {
    const target = +el.dataset.target;
    let current = 0;
    const step = target / 40;
    const timer = setInterval(() => {
      current = Math.min(current + step, target);
      el.textContent = Math.round(current);
      if (current >= target) clearInterval(timer);
    }, 35);
  });
}

/* ══════════════════════════════════════
   PROJECTS — RENDER
══════════════════════════════════════ */
const grid       = document.getElementById('projectsGrid');
const loadingEl  = document.getElementById('projLoading');

function statusClass(s) {
  return { Live:'ps-live', 'In Progress':'ps-progress', Completed:'ps-completed', Private:'ps-private' }[s] || 'ps-completed';
}

function renderProjects(data, filter = 'all') {
  grid.innerHTML = '';
  const sorted = [...data].sort((a,b) => (a.order||99)-(b.order||99));
  const filtered = filter === 'all' ? sorted : sorted.filter(p => p.status === filter);

  if (!filtered.length) {
    grid.innerHTML = '<div style="grid-column:1/-1;text-align:center;color:var(--t3);font-family:var(--ff-mono);padding:3rem">No projects found.</div>';
    return;
  }

  filtered.forEach((p, i) => {
    const feats = Array.isArray(p.features) ? p.features : [];
    const tech  = Array.isArray(p.tech)     ? p.tech     : [];

    const featHTML = feats.length
      ? `<div class="pc-feat-label">Key Features</div>
         <div class="pc-feats">${feats.map(f=>`<span class="pc-feat">${f}</span>`).join('')}</div>`
      : '';

    const techHTML = tech.length
      ? `<div class="pc-tech">${tech.map(t=>`<span class="pc-tech-tag">${t}</span>`).join('')}</div>`
      : '';

    const linkHTML = p.url
      ? `<a href="${p.url}" target="_blank" rel="noopener" class="pc-link">View Project <i class="fa-solid fa-arrow-up-right"></i></a>`
      : '';

    const adminHTML = isAdmin
      ? `<div class="pc-admin-btns">
           <button class="pc-edit" data-id="${p.id}">Edit</button>
           <button class="pc-del" data-id="${p.id}">Delete</button>
         </div>`
      : '';

    const card = document.createElement('div');
    card.className = 'proj-card';
    card.style.animationDelay = (i * 70) + 'ms';
    card.innerHTML = `
      ${p.imageUrl ? `<div class="pc-img"><img src="${p.imageUrl}" alt="${p.title}" loading="lazy"/></div>` : ''}
      <div class="pc-top-row">
        <span class="pc-num">${String(i+1).padStart(2,'0')}</span>
        <span class="pc-cat">${p.category || 'Mobile App'}</span>
        <span class="pc-status-badge ${statusClass(p.status)}">${p.status || 'Completed'}</span>
      </div>
      <h3 class="pc-title">${p.title}</h3>
      <p class="pc-desc">${p.description}</p>
      ${featHTML}
      ${techHTML}
      <div class="pc-footer">
        ${linkHTML}
        ${adminHTML}
      </div>
    `;
    grid.appendChild(card);
  });

  if (isAdmin) {
    grid.querySelectorAll('.pc-edit').forEach(b => b.addEventListener('click', () => openEdit(b.dataset.id)));
    grid.querySelectorAll('.pc-del').forEach(b => b.addEventListener('click', () => deleteProject(b.dataset.id)));
  }
}

async function loadProjects() {
  loadingEl.style.display = 'flex';
  grid.style.display = 'none';
  projects = await DB.get();
  loadingEl.style.display = 'none';
  grid.style.display = 'grid';
  renderProjects(projects);
}

/* ══════════════════════════════════════
   FILTER TABS
══════════════════════════════════════ */
document.querySelectorAll('.pf-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.pf-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    renderProjects(projects, btn.dataset.f);
  });
});

/* ══════════════════════════════════════
   ADMIN PANEL
══════════════════════════════════════ */
const adminToggle = document.getElementById('adminToggle');
const adminPanel  = document.getElementById('adminPanel');
const apCancel    = document.getElementById('apCancel');
const apForm      = document.getElementById('apForm');
const apMsg       = document.getElementById('apMsg');
const apSubmit    = document.getElementById('apSubmit');
const apSubmitTxt = document.getElementById('apSubmitTxt');
const apTitle     = document.getElementById('apTitle');

// Admin tools are a local publishing aid only — hidden on the live site.
if (!DB.isLocal()) adminToggle.style.display = 'none';

adminToggle.addEventListener('click', () => {
  if (!DB.isLocal()) return;
  if (!isAdmin) {
    const pw = prompt('Enter admin password:');
    if (!DB.auth(pw)) { alert('Incorrect password'); return; }
    isAdmin = true;
    adminToggle.innerHTML = '<i class="fa-solid fa-lock-open"></i> Admin Mode On';
    adminPanel.style.display = 'block';
    renderProjects(projects);
  } else {
    exitAdmin();
  }
});

apCancel.addEventListener('click', exitAdmin);

function exitAdmin() {
  isAdmin = false;
  editId = null;
  adminToggle.innerHTML = '<i class="fa-solid fa-lock"></i> Manage Projects';
  adminPanel.style.display = 'none';
  resetForm();
  renderProjects(projects);
}

function resetForm() {
  apForm.reset();
  document.getElementById('apId').value = '';
  editId = null;
  apTitle.innerHTML = '<i class="fa-solid fa-circle-plus"></i> Add New Project';
  apSubmitTxt.textContent = 'Add Project';
  apSubmit.querySelector('i').className = 'fa-solid fa-plus';
}

function openEdit(id) {
  const p = projects.find(x => x.id === id);
  if (!p) return;
  editId = id;
  document.getElementById('apId').value     = id;
  document.getElementById('apTitle2').value = p.title || '';
  document.getElementById('apDesc').value   = p.description || '';
  document.getElementById('apCat').value    = p.category || 'Mobile App';
  document.getElementById('apTech').value   = (p.tech||[]).join(', ');
  document.getElementById('apStatus').value = p.status || 'Completed';
  document.getElementById('apFeatures').value = (p.features||[]).join('\n');
  document.getElementById('apUrl').value    = p.url || '';
  document.getElementById('apImgUrl').value = p.imageUrl || '';
  apTitle.innerHTML = '<i class="fa-solid fa-pen"></i> Edit Project';
  apSubmitTxt.textContent = 'Update Project';
  apSubmit.querySelector('i').className = 'fa-solid fa-check';
  adminPanel.scrollIntoView({ behavior:'smooth', block:'center' });
  setMsg('Editing: ' + p.title, '');
}

async function deleteProject(id) {
  if (!confirm('Delete this project permanently?')) return;
  projects = projects.filter(p => p.id !== id);
  await persist('Project deleted.');
}

apForm.addEventListener('submit', async e => {
  e.preventDefault();
  const title = document.getElementById('apTitle2').value.trim();
  const desc  = document.getElementById('apDesc').value.trim();
  if (!title || !desc) { setMsg('Title and description are required.', 'err'); return; }

  const tech     = document.getElementById('apTech').value.split(',').map(s=>s.trim()).filter(Boolean);
  const features = document.getElementById('apFeatures').value.split('\n').map(s=>s.trim()).filter(Boolean);
  const now      = new Date().toISOString();

  if (editId) {
    const idx = projects.findIndex(p => p.id === editId);
    if (idx !== -1) {
      projects[idx] = {
        ...projects[idx],
        title, description: desc,
        category: document.getElementById('apCat').value,
        tech, features,
        url:      document.getElementById('apUrl').value.trim(),
        imageUrl: document.getElementById('apImgUrl').value.trim(),
        status:   document.getElementById('apStatus').value,
        updatedAt: now
      };
    }
    await persist('✅ Project updated!');
    resetForm();
  } else {
    projects.push({
      id: DB.newId(), order: projects.length + 1,
      title, description: desc,
      category: document.getElementById('apCat').value,
      tech, features,
      url:      document.getElementById('apUrl').value.trim(),
      imageUrl: document.getElementById('apImgUrl').value.trim(),
      status:   document.getElementById('apStatus').value,
      createdAt: now
    });
    await persist('✅ Project added!');
    resetForm();
  }
});

async function persist(msg) {
  apSubmit.disabled = true;
  apSubmitTxt.textContent = 'Saving…';
  const result = await DB.save(projects);
  apSubmit.disabled = false;
  apSubmitTxt.textContent = editId ? 'Update Project' : 'Add Project';

  if (!result.ok) {
    setMsg('⚠ Could not generate the file: ' + (result.reason || 'unknown error'), 'err');
  } else {
    setMsg(msg + ' — projects-data.js downloaded. Replace js/projects-data.js with it, then commit & push to publish.', 'ok');
  }
  renderProjects(projects);
}

function setMsg(text, type) {
  apMsg.textContent = text;
  apMsg.className = 'ap-msg' + (type ? ' ' + type : '');
}

/* ══════════════════════════════════════
   INIT
══════════════════════════════════════ */
document.addEventListener('DOMContentLoaded', () => {
  loadProjects();
});

/* ══════════════════════════════════════
   STATS COUNTER — triggered on scroll
══════════════════════════════════════ */
(function initScrollCounters() {
  const statsEl = document.querySelector('.hero-stats');
  if (!statsEl) return;
  let fired = false;
  const obs = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting && !fired) {
        fired = true;
        obs.disconnect();
        document.querySelectorAll('.stat-num').forEach((el, i) => {
          setTimeout(() => {
            const target = +el.dataset.target;
            let current = 0;
            const step = target / 40;
            const timer = setInterval(() => {
              current = Math.min(current + step, target);
              el.textContent = Math.round(current);
              if (current >= target) clearInterval(timer);
            }, 35);
          }, i * 200);
        });
      }
    });
  }, { threshold: 0.4 });
  obs.observe(statsEl);
})();

/* ══════════════════════════════════════
   GALLERY LIGHTBOX — multi-image
══════════════════════════════════════ */
(function initGallery() {
  const lightbox  = document.getElementById('galleryLightbox');
  const glbImg    = document.getElementById('glbImg');
  const glbCap    = document.getElementById('glbCaption');
  const glbCounter= document.getElementById('glbCounter');
  const glbClose  = document.getElementById('glbClose');
  const glbPrev   = document.getElementById('glbPrev');
  const glbNext   = document.getElementById('glbNext');
  if (!lightbox) return;

  let images = [];
  let idx = 0;
  let currentItem = null;

  function updateLightbox() {
    const img = images[idx];
    glbImg.style.animation = 'none';
    glbImg.offsetHeight; // reflow to restart animation
    glbImg.style.animation = '';
    glbImg.src = img.src;
    glbImg.alt = img.alt || '';
    glbCap.textContent = currentItem ? currentItem.querySelector('.gl-name').textContent : '';
    if (glbCounter) glbCounter.textContent = `${idx + 1} / ${images.length}`;
    if (glbPrev) glbPrev.classList.toggle('disabled', idx === 0);
    if (glbNext) glbNext.classList.toggle('disabled', idx === images.length - 1);
  }

  function openLightbox(item) {
    const pageUrl = window.location.href.split('#')[0];
    const imgs = Array.from(item.querySelectorAll('.phone-screen img'))
      .filter(i => {
        const s = i.getAttribute('src');
        return s && s.trim() !== '' && !i.src.startsWith(pageUrl) && !i.src.endsWith('#');
      });
    if (!imgs.length) return;
    currentItem = item;
    images = imgs.map(i => ({ src: i.src, alt: i.alt }));
    idx = 0;
    updateLightbox();
    lightbox.classList.add('open');
    document.body.style.overflow = 'hidden';
  }

  function closeLightbox() {
    lightbox.classList.remove('open');
    document.body.style.overflow = '';
    images = []; idx = 0; currentItem = null;
  }

  document.querySelectorAll('.gallery-item').forEach(item => {
    item.addEventListener('click', e => {
      if (e.target.closest('.carousel-dot')) return; // dot clicks handled separately
      openLightbox(item);
    });
  });

  if (glbPrev) glbPrev.addEventListener('click', () => { if (idx > 0) { idx--; updateLightbox(); } });
  if (glbNext) glbNext.addEventListener('click', () => { if (idx < images.length - 1) { idx++; updateLightbox(); } });
  glbClose.addEventListener('click', closeLightbox);
  lightbox.addEventListener('click', e => { if (e.target === lightbox) closeLightbox(); });
  document.addEventListener('keydown', e => {
    if (!lightbox.classList.contains('open')) return;
    if (e.key === 'Escape') closeLightbox();
    if (e.key === 'ArrowLeft' && idx > 0) { idx--; updateLightbox(); }
    if (e.key === 'ArrowRight' && idx < images.length - 1) { idx++; updateLightbox(); }
  });
})();

/* ══════════════════════════════════════
   GALLERY CAROUSEL (in-frame dots)
══════════════════════════════════════ */
(function initCarousel() {
  document.querySelectorAll('.gallery-item').forEach(item => {
    const viewport = item.querySelector('.carousel-viewport');
    const dots     = item.querySelectorAll('.carousel-dot');
    if (!viewport || !dots.length) return;

    const screens   = item.querySelectorAll('.carousel-viewport .phone-screen');
    const total     = screens.length;
    let current     = 0;

    function goTo(i) {
      current = Math.max(0, Math.min(i, total - 1));
      viewport.scrollTo({ left: current * viewport.offsetWidth, behavior: 'smooth' });
      dots.forEach((d, di) => d.classList.toggle('active', di === current));
    }

    dots.forEach((dot, i) => {
      dot.addEventListener('click', e => { e.stopPropagation(); goTo(i); });
    });

    // Sync dots on native scroll-snap scroll
    let scrollTimer;
    viewport.addEventListener('scroll', () => {
      clearTimeout(scrollTimer);
      scrollTimer = setTimeout(() => {
        const w = viewport.offsetWidth;
        if (w) {
          current = Math.round(viewport.scrollLeft / w);
          dots.forEach((d, di) => d.classList.toggle('active', di === current));
        }
      }, 120);
    });

    // Touch swipe
    let tx = 0;
    viewport.addEventListener('touchstart', e => { tx = e.changedTouches[0].clientX; }, { passive: true });
    viewport.addEventListener('touchend', e => {
      const diff = tx - e.changedTouches[0].clientX;
      if (Math.abs(diff) > 30) goTo(diff > 0 ? current + 1 : current - 1);
    }, { passive: true });
  });
})();

/* ══════════════════════════════════════
   MAGNETIC BUTTON EFFECT
══════════════════════════════════════ */
if (window.matchMedia('(hover:hover)').matches) {
  document.querySelectorAll('.btn-primary, .btn-ghost').forEach(btn => {
    btn.addEventListener('mousemove', e => {
      const rect = btn.getBoundingClientRect();
      const dx   = (e.clientX - (rect.left + rect.width  / 2)) / (rect.width  / 2);
      const dy   = (e.clientY - (rect.top  + rect.height / 2)) / (rect.height / 2);
      btn.style.transform = `translate(${dx * 6}px, ${dy * 6}px)`;
    });
    btn.addEventListener('mouseleave', () => { btn.style.transform = ''; });
  });
}

/* ══════════════════════════════════════
   SECTION LABEL TYPING EFFECT
══════════════════════════════════════ */
(function initTypingLabels() {
  const labels = document.querySelectorAll('.sec-label');
  if (!labels.length) return;
  const obs = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      obs.unobserve(entry.target);
      const el   = entry.target;
      const full = el.textContent;
      el.textContent = '';
      let i = 0;
      const interval = setInterval(() => {
        el.textContent += full[i];
        i++;
        if (i >= full.length) clearInterval(interval);
      }, 18);
    });
  }, { threshold: 0.5 });
  labels.forEach(el => obs.observe(el));
})();

/* ══════════════════════════════════════
   PARTICLE CANVAS — Hero Background
══════════════════════════════════════ */
(function initParticles() {
  const canvas = document.getElementById('heroCanvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let W, H, particles = [];
  let stars = [];
  let mouseX = -9999, mouseY = -9999;

  function initStars() {
    stars = Array.from({ length: 60 }, () => ({
      x: Math.random() * W,
      y: Math.random() * H,
      r: Math.random() * 2 + 0.5,
      baseA: Math.random() * 0.8 + 0.2,
      speed: Math.random() * 0.02 + 0.005,
      phase: Math.random() * Math.PI * 2,
      color: Math.random() < 0.6 ? '200,245,66' : '96,239,255',
    }));
  }

  function drawStars(t) {
    stars.forEach(s => {
      const a = s.baseA * (0.5 + 0.5 * Math.sin(t * s.speed + s.phase));
      ctx.beginPath();
      ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(${s.color},${a})`;
      ctx.fill();
      if (s.baseA > 0.7) {
        ctx.shadowBlur = 6;
        ctx.shadowColor = `rgba(${s.color},0.6)`;
        ctx.fill();
        ctx.shadowBlur = 0;
      }
    });
  }

  function resize() {
    W = canvas.width  = canvas.offsetWidth;
    H = canvas.height = canvas.offsetHeight;
    initStars();
  }

  class Particle {
    constructor() { this.reset(true); }
    reset(init = false) {
      this.x  = Math.random() * W;
      this.y  = init ? Math.random() * H : (Math.random() < .5 ? 0 : H);
      this.vx = (Math.random() - .5) * .35;
      this.vy = (Math.random() - .5) * .35;
      this.r  = Math.random() * 1.4 + .4;
      this.a  = Math.random() * .45 + .08;
      this.hue = Math.random() < .6 ? 238 : (Math.random() < .5 ? 186 : 330);
    }
    update() {
      this.x += this.vx;
      this.y += this.vy;
      const dx = this.x - mouseX, dy = this.y - mouseY;
      const d  = Math.sqrt(dx * dx + dy * dy);
      if (d < 90) { this.x += (dx / d) * 1.8; this.y += (dy / d) * 1.8; }
      if (this.x < -5 || this.x > W + 5 || this.y < -5 || this.y > H + 5) this.reset();
    }
    draw() {
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.r, 0, Math.PI * 2);
      ctx.fillStyle = `hsla(${this.hue},80%,70%,${this.a})`;
      ctx.fill();
    }
  }

  function drawConnections() {
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const dx = particles[i].x - particles[j].x;
        const dy = particles[i].y - particles[j].y;
        const d  = Math.sqrt(dx * dx + dy * dy);
        if (d < 110) {
          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.strokeStyle = `rgba(99,102,241,${(1 - d / 110) * .13})`;
          ctx.lineWidth = .6;
          ctx.stroke();
        }
      }
    }
  }

  function loop() {
    ctx.clearRect(0, 0, W, H);
    drawStars(Date.now() * 0.001);
    particles.forEach(p => { p.update(); p.draw(); });
    drawConnections();
    requestAnimationFrame(loop);
  }

  resize();
  particles = Array.from({ length: 90 }, () => new Particle());
  window.addEventListener('resize', () => { resize(); }, { passive: true });
  document.addEventListener('mousemove', e => {
    const rect = canvas.getBoundingClientRect();
    mouseX = e.clientX - rect.left;
    mouseY = e.clientY - rect.top;
  }, { passive: true });
  loop();
})();

/* ══════════════════════════════════════
   3D CARD TILT EFFECT
══════════════════════════════════════ */
if (window.matchMedia('(hover:hover)').matches) {
  const tiltTargets = document.querySelectorAll('.proj-card, .skill-cat-card, .ct-cta-card, .tl-content');
  tiltTargets.forEach(card => {
    card.classList.add('tilt-card');
    const shine = document.createElement('div');
    shine.className = 'card-shine';
    card.appendChild(shine);

    let raf = null, tRx = 0, tRy = 0, cRx = 0, cRy = 0;

    card.addEventListener('mousemove', e => {
      const rect = card.getBoundingClientRect();
      const dx = (e.clientX - (rect.left + rect.width  / 2)) / (rect.width  / 2);
      const dy = (e.clientY - (rect.top  + rect.height / 2)) / (rect.height / 2);
      tRx = -dy * 7;
      tRy =  dx * 7;
      const px = ((e.clientX - rect.left) / rect.width)  * 100;
      const py = ((e.clientY - rect.top)  / rect.height) * 100;
      shine.style.background = `radial-gradient(circle at ${px}% ${py}%,rgba(255,255,255,.1) 0%,transparent 60%)`;
      if (!raf) animateTilt();
    });

    function animateTilt() {
      cRx += (tRx - cRx) * .13;
      cRy += (tRy - cRy) * .13;
      card.style.transform = `perspective(700px) rotateX(${cRx}deg) rotateY(${cRy}deg)`;
      if (Math.abs(tRx - cRx) > .02 || Math.abs(tRy - cRy) > .02) {
        raf = requestAnimationFrame(animateTilt);
      } else { raf = null; }
    }

    card.addEventListener('mouseleave', () => {
      tRx = 0; tRy = 0;
      const settle = () => {
        cRx += (0 - cRx) * .15;
        cRy += (0 - cRy) * .15;
        card.style.transform = `perspective(700px) rotateX(${cRx}deg) rotateY(${cRy}deg)`;
        if (Math.abs(cRx) > .05 || Math.abs(cRy) > .05) requestAnimationFrame(settle);
        else { card.style.transform = ''; }
      };
      cancelAnimationFrame(raf); raf = null;
      shine.style.background = '';
      settle();
    });
  });
}

/* ══════════════════════════════════════
   BUTTON RIPPLE EFFECT
══════════════════════════════════════ */
document.querySelectorAll('.btn-primary, .btn-ghost, .btn-hire').forEach(btn => {
  btn.addEventListener('click', function(e) {
    const rect = this.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = e.clientX - rect.left - size / 2;
    const y = e.clientY - rect.top  - size / 2;
    const wave = document.createElement('span');
    wave.className = 'ripple-wave';
    wave.style.cssText = `width:${size}px;height:${size}px;left:${x}px;top:${y}px`;
    this.appendChild(wave);
    setTimeout(() => wave.remove(), 700);
  });
});

/* ══════════════════════════════════════
   HERO H1 CHAR-BY-CHAR REVEAL
══════════════════════════════════════ */
(function initCharReveal() {
  const h1 = document.querySelector('.hero-h1');
  if (!h1) return;

  h1.querySelectorAll('.word-outline, .word-fill, .word-gradient').forEach(wordEl => {
    const text = wordEl.textContent;
    wordEl.innerHTML = '';
    [...text].forEach((ch, i) => {
      if (ch === ' ') {
        const sp = document.createElement('span');
        sp.className = 'char-space';
        wordEl.appendChild(sp);
      } else {
        const span = document.createElement('span');
        span.className = 'char';
        span.textContent = ch;
        span.style.transitionDelay = (i * 45) + 'ms';
        wordEl.appendChild(span);
      }
    });
  });

  setTimeout(() => {
    document.querySelectorAll('.hero-h1 .char').forEach(c => c.classList.add('revealed'));
  }, 900);
})();

/* ══════════════════════════════════════
   TYPEWRITER EFFECT — Hero roles
══════════════════════════════════════ */
(function initTypewriter() {
  const el = document.getElementById('typewriterText');
  if (!el) return;
  const roles = [
    'Flutter Apps at Scale',
    'Enterprise IT Systems',
    'REST API Integrations',
    'Clean Architecture',
    'Cross-Platform Mobile Apps',
    'Production-Grade Solutions',
  ];
  let ri = 0, ci = 0, deleting = false;

  function tick() {
    const role = roles[ri];
    if (!deleting) {
      el.textContent = role.slice(0, ci + 1);
      ci++;
      if (ci === role.length) { deleting = true; setTimeout(tick, 2000); return; }
      setTimeout(tick, 65);
    } else {
      el.textContent = role.slice(0, ci - 1);
      ci--;
      if (ci === 0) {
        deleting = false;
        ri = (ri + 1) % roles.length;
        setTimeout(tick, 350);
        return;
      }
      setTimeout(tick, 38);
    }
  }
  setTimeout(tick, 1200);
})();

/* ══════════════════════════════════════
   GRADIENT BORDER on glass cards
══════════════════════════════════════ */
document.querySelectorAll('.glass-card, .skill-cat-card, .proj-card').forEach(el => {
  el.classList.add('grad-border');
});

/* ══════════════════════════════════════
   NAV LINK MAGNETIC HOVER
══════════════════════════════════════ */
if (window.matchMedia('(hover:hover)').matches) {
  document.querySelectorAll('.nl').forEach(link => {
    link.addEventListener('mousemove', e => {
      const rect = link.getBoundingClientRect();
      const dx = (e.clientX - (rect.left + rect.width  / 2)) / (rect.width  / 2);
      const dy = (e.clientY - (rect.top  + rect.height / 2)) / (rect.height / 2);
      link.style.transform = `translate(${dx * 4}px, ${dy * 3}px)`;
    });
    link.addEventListener('mouseleave', () => { link.style.transform = ''; });
  });
}

/* ══════════════════════════════════════
   CONTACT FORM (EmailJS)
══════════════════════════════════════ */
(function initContactForm() {
  
  const EMAILJS_SERVICE  = 'service_g4wnrov';
  const EMAILJS_TEMPLATE = 'template_9zh5x4e';
  const EMAILJS_PUBLIC   = 'PIMuMnH-mtEK1G0va';

  if (typeof emailjs !== 'undefined') {
    emailjs.init({ publicKey: EMAILJS_PUBLIC });
  }

  const form      = document.getElementById('contactForm');
  const status    = document.getElementById('cfStatus');
  const submitBtn = document.getElementById('cfSubmit');
  const submitTxt = document.getElementById('cfSubmitTxt');
  if (!form) return;

  const RATE_KEY    = 'cf_submissions';
  const RATE_LIMIT  = 2;
  const RATE_WINDOW = 10 * 60 * 1000; // 10 minutes

  function getRateData() {
    try { return JSON.parse(localStorage.getItem(RATE_KEY) || '[]'); } catch { return []; }
  }
  function isRateLimited() {
    const now    = Date.now();
    const recent = getRateData().filter(t => now - t < RATE_WINDOW);
    localStorage.setItem(RATE_KEY, JSON.stringify(recent));
    return recent.length >= RATE_LIMIT;
  }
  function recordSubmission() {
    const data = getRateData();
    data.push(Date.now());
    localStorage.setItem(RATE_KEY, JSON.stringify(data));
  }

  function sanitize(str) {
    return String(str).replace(/[<>"'`]/g, '').trim().slice(0, 2000);
  }

  function showStatus(msg, type) {
    status.textContent = msg;
    status.className   = 'cf-status cf-status--' + type;
  }

  form.addEventListener('submit', async function (e) {
    e.preventDefault();

    // Honeypot check
    if (document.getElementById('cfHoney').value !== '') return;

    // Rate limit check
    if (isRateLimited()) {
      showStatus('Too many messages. Please wait 10 minutes before trying again.', 'error');
      return;
    }

    const name    = sanitize(document.getElementById('cfName').value);
    const email   = sanitize(document.getElementById('cfEmail').value);
    const subject = sanitize(document.getElementById('cfSubject').value);
    const message = sanitize(document.getElementById('cfMsg').value);

    if (!name || !email || !message) {
      showStatus('Please fill in your name, email, and message.', 'error');
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showStatus('Please enter a valid email address.', 'error');
      return;
    }

    submitBtn.disabled  = true;
    submitTxt.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Sending…';
    showStatus('', '');

    try {
      await emailjs.send(EMAILJS_SERVICE, EMAILJS_TEMPLATE, {
        from_name : name,
        reply_to  : email,
        subject   : subject || 'Portfolio Contact',
        message   : message,
        to_email  : 'abbasith222@gmail.com'
      });
      recordSubmission();
      showStatus("Message sent! I'll reply within a few hours.", 'success');
      form.reset();
    } catch (err) {
      showStatus('Failed to send. Please email me directly at abbasith222@gmail.com', 'error');
      console.error('[ContactForm]', err);
    } finally {
      submitBtn.disabled  = false;
      submitTxt.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Send Message';
    }
  });
})();
