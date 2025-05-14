<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TuneShift - Professional Car Maintenance</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Poppins', sans-serif;
    }

    :root {
      --primary: #FF6B35;
      --dark: #2A2A2A;
      --light: #F8F9FA;
    }

    body {
      background: var(--light);
      color: var(--dark);
    }

    /* Navigation */
    .navbar {
      position: fixed;
      width: 100%;
      padding: 1.5rem 5%;
      background: rgba(255,255,255,0.98);
      display: flex;
      justify-content: space-between;
      align-items: center;
      z-index: 1000;
      box-shadow: 0 2px 15px rgba(0,0,0,0.1);
      transition: all 0.3s ease;
    }

    .navbar.scrolled {
      padding: 1rem 5%;
    }

    .logo {
      font-size: 2rem;
      font-weight: 700;
      color: var(--primary);
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .logo-icon {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 45px;
      height: 45px;
      background: linear-gradient(135deg, var(--primary), #ff8c5a);
      border-radius: 12px;
      position: relative;
      overflow: hidden;
      font-family: 'Arial', sans-serif;
      font-weight: bold;
      box-shadow: 0 4px 15px rgba(255, 107, 53, 0.25);
    }

    .logo-icon::before {
      content: '';
      position: absolute;
      width: 100%;
      height: 100%;
      background: linear-gradient(45deg, transparent 48%, rgba(255,255,255,0.3) 50%, transparent 52%);
      animation: shine 3s infinite;
    }

    .logo-icon i {
      color: white;
      font-size: 1.4rem;
      position: relative;
      transform: translateY(-1px);
    }

    .logo-icon i::before {
      content: 'TS';
      font-style: normal;
      font-weight: 900;
      letter-spacing: -1px;
      text-shadow: 2px 2px 4px rgba(0,0,0,0.15);
    }

    .logo-icon i::after {
      content: '\f013';
      font-family: 'Font Awesome 6 Free';
      font-weight: 900;
      position: absolute;
      font-size: 0.9rem;
      bottom: -2px;
      right: -2px;
      color: rgba(255,255,255,0.95);
      text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
      animation: spin 10s linear infinite;
    }

    .logo-text {
      position: relative;
      font-weight: 800;
      letter-spacing: 0.5px;
      background: linear-gradient(135deg, var(--primary), #ff8c5a);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
    }

    .logo-text::after {
      content: '';
      position: absolute;
      bottom: -2px;
      left: 0;
      width: 100%;
      height: 2px;
      background: linear-gradient(90deg, var(--primary), #ff8c5a);
      transform: scaleX(0);
      transform-origin: right;
      transition: transform 0.3s ease;
    }

    .logo:hover .logo-text::after {
      transform: scaleX(1);
      transform-origin: left;
    }

    @keyframes shine {
      0% {
        transform: translateX(-100%) rotate(45deg);
      }
      100% {
        transform: translateX(100%) rotate(45deg);
      }
    }

    @keyframes spin {
      from {
        transform: rotate(0deg);
      }
      to {
        transform: rotate(360deg);
      }
    }

    .nav-links a {
      margin-left: 2rem;
      text-decoration: none;
      color: var(--dark);
      font-weight: 500;
      transition: color 0.3s ease;
    }

    .nav-links a:hover {
      color: var(--primary);
    }

    /* Hero Section */
    .hero {
      min-height: 100vh;
      padding: 120px 5% 0;
      background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)),
      url('https://images.unsplash.com/photo-1485291571150-772bcfc10da5?auto=format&fit=crop&w=1920&q=80');
      background-size: cover;
      background-position: center;
      display: flex;
      align-items: center;
      color: white;
    }

    .hero-content {
      max-width: 800px;
      opacity: 0;
      transform: translateY(30px);
      animation: fadeUp 1s 0.5s forwards;
    }

    .hero h1 {
      font-size: 3.5rem;
      margin-bottom: 1.5rem;
      line-height: 1.2;
    }

    .hero p {
      font-size: 1.2rem;
      margin-bottom: 2rem;
      opacity: 0.9;
    }

    /* Services Section */
    .services {
      padding: 6rem 5%;
      background: white;
    }

    .section-title {
      text-align: center;
      margin-bottom: 4rem;
      opacity: 0;
      transform: translateY(30px);
      transition: all 0.8s ease;
    }

    .section-title.animate {
      opacity: 1;
      transform: translateY(0);
    }

    .section-title h2 {
      font-size: 2.5rem;
      margin-bottom: 1rem;
    }

    .services-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
    }

    .service-card {
      padding: 2rem;
      border-radius: 10px;
      background: var(--light);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      text-align: center;
      opacity: 0;
      transform: translateY(30px);
    }

    .service-card.animate {
      opacity: 1;
      transform: translateY(0);
    }

    .service-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }

    .service-icon {
      font-size: 2.5rem;
      color: var(--primary);
      margin-bottom: 1rem;
      transition: transform 0.3s ease;
    }

    .service-card:hover .service-icon {
      transform: scale(1.1);
    }

    /* Why Choose Us */
    .why-choose {
      padding: 6rem 5%;
      background: var(--dark);
      color: white;
    }

    .features-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
      margin-top: 3rem;
    }

    .feature-card {
      padding: 2rem;
      background: rgba(255,255,255,0.1);
      border-radius: 10px;
      text-align: center;
      opacity: 0;
      transform: translateY(30px);
      transition: all 0.8s ease;
    }

    .feature-card.animate {
      opacity: 1;
      transform: translateY(0);
    }

    /* Contact Section */
    .contact {
      padding: 6rem 5%;
      background: white;
    }

    .contact-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 3rem;
      margin-top: 3rem;
    }

    .contact-info {
      padding-right: 2rem;
    }

    .contact-form {
      background: var(--light);
      padding: 2rem;
      border-radius: 10px;
    }

    /* Footer */
    .footer {
      background: var(--dark);
      color: white;
      padding: 4rem 5%;
    }

    .footer-content {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 3rem;
      padding-bottom: 2rem;
    }

    .footer-section h3 {
      color: var(--primary);
      margin-bottom: 1.5rem;
    }

    .social-links a {
      color: white;
      font-size: 1.5rem;
      margin-right: 1rem;
      transition: color 0.3s ease;
    }

    .social-links a:hover {
      color: var(--primary);
    }

    /* Animations */
    @keyframes fadeUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .hero h1 {
        font-size: 2.5rem;
      }

      .contact-grid {
        grid-template-columns: 1fr;
      }

      .nav-links {
        display: none;
      }
    }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="#" class="logo">
    <div class="logo-icon">
      <i></i>
    </div>
    <span class="logo-text">TuneShift</span>
  </a>
  <div class="nav-links">
    <a href="#home">Home</a>
    <a href="#services">Services</a>
    <a href="#about">About</a>
    <a href="#contact">Contact</a>
  </div>
</nav>

<section class="hero" id="home">
  <div class="hero-content">
    <h1>Professional Car Maintenance & Care</h1>
    <p>Trust your vehicle to certified experts using state-of-the-art equipment and genuine parts</p>
    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
      <a href="pages/login.jsp" class="btn" style="background: var(--primary); color: white; padding: 1rem 2rem; border-radius: 30px; text-decoration: none; transition: transform 0.3s ease, box-shadow 0.3s ease;">Book Service Now</a>
      <a href="#services" class="btn" style="background: transparent; color: white; padding: 1rem 2rem; border-radius: 30px; text-decoration: none; border: 2px solid white; transition: transform 0.3s ease, box-shadow 0.3s ease;">Our Services</a>
    </div>
    <div style="margin-top: 3rem; display: flex; gap: 2rem; flex-wrap: wrap;">
      <div style="display: flex; align-items: center; gap: 1rem;">
        <i class="fas fa-check-circle" style="color: #4CAF50; font-size: 1.5rem;"></i>
        <span>Free Diagnostics</span>
      </div>
      <div style="display: flex; align-items: center; gap: 1rem;">
        <i class="fas fa-check-circle" style="color: #4CAF50; font-size: 1.5rem;"></i>
        <span>Genuine Parts</span>
      </div>
      <div style="display: flex; align-items: center; gap: 1rem;">
        <i class="fas fa-check-circle" style="color: #4CAF50; font-size: 1.5rem;"></i>
        <span>Warranty Included</span>
      </div>
    </div>
  </div>
</section>

<section class="stats" style="padding: 4rem 5%; background: white; text-align: center;">
  <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem; max-width: 1200px; margin: 0 auto;">
    <div class="stat-item">
      <div style="font-size: 2.5rem; font-weight: 700; color: var(--primary); margin-bottom: 0.5rem;">10+</div>
      <div style="color: #666;">Years Experience</div>
    </div>
    <div class="stat-item">
      <div style="font-size: 2.5rem; font-weight: 700; color: var(--primary); margin-bottom: 0.5rem;">5000+</div>
      <div style="color: #666;">Happy Customers</div>
    </div>
    <div class="stat-item">
      <div style="font-size: 2.5rem; font-weight: 700; color: var(--primary); margin-bottom: 0.5rem;">50+</div>
      <div style="color: #666;">Expert Technicians</div>
    </div>
    <div class="stat-item">
      <div style="font-size: 2.5rem; font-weight: 700; color: var(--primary); margin-bottom: 0.5rem;">24/7</div>
      <div style="color: #666;">Service Available</div>
    </div>
  </div>
</section>

<section class="services" id="services">
  <div class="section-title">
    <h2>Our Services</h2>
    <p>Comprehensive automotive solutions tailored to your vehicle's needs</p>
  </div>
  <div class="services-grid">
    <div class="service-card">
      <i class="fas fa-oil-can service-icon"></i>
      <h3>Regular Maintenance</h3>
      <p>Keep your vehicle running smoothly with our comprehensive maintenance services:</p>
      <ul style="text-align: left; margin-top: 1rem; list-style: none;">
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Oil & Filter Changes</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Brake System Inspection</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Tire Rotation & Alignment</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Fluid Level Checks</li>
      </ul>
    </div>
    <div class="service-card">
      <i class="fas fa-tools service-icon"></i>
      <h3>Engine Repair</h3>
      <p>Expert engine diagnostics and repair services for optimal performance:</p>
      <ul style="text-align: left; margin-top: 1rem; list-style: none;">
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Engine Diagnostics</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Performance Tuning</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Engine Rebuilds</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Emission Testing</li>
      </ul>
    </div>
    <div class="service-card">
      <i class="fas fa-car-battery service-icon"></i>
      <h3>Electrical Systems</h3>
      <p>Complete electrical system maintenance and repair services:</p>
      <ul style="text-align: left; margin-top: 1rem; list-style: none;">
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Battery Testing & Replacement</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Alternator Repair</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Starter Motor Service</li>
        <li><i class="fas fa-check" style="color: var(--primary);"></i> Wiring Diagnostics</li>
      </ul>
    </div>
  </div>
</section>

<section class="why-choose" id="about">
  <div class="section-title">
    <h2>Why Choose TuneShift</h2>
    <p>Experience excellence in automotive care</p>
  </div>
  <div class="features-grid">
    <div class="feature-card">
      <i class="fas fa-medal" style="font-size: 2.5rem; color: var(--primary); margin-bottom: 1rem;"></i>
      <h3>10+ Years Experience</h3>
      <p>With over a decade of expertise, we've served thousands of satisfied customers. Our team of certified technicians brings years of hands-on experience to every service.</p>
    </div>
    <div class="feature-card">
      <i class="fas fa-certificate" style="font-size: 2.5rem; color: var(--primary); margin-bottom: 1rem;"></i>
      <h3>Certified Technicians</h3>
      <p>Our technicians are factory-trained professionals with OEM certifications. We stay updated with the latest automotive technology and repair techniques.</p>
    </div>
    <div class="feature-card">
      <i class="fas fa-clock" style="font-size: 2.5rem; color: var(--primary); margin-bottom: 1rem;"></i>
      <h3>24/7 Support</h3>
      <p>Round-the-clock roadside assistance and emergency services. We're here when you need us, ensuring your peace of mind on the road.</p>
    </div>
  </div>
</section>

<section class="process" style="padding: 6rem 5%; background: var(--light);">
  <div class="section-title">
    <h2>Our Service Process</h2>
    <p>Simple and efficient service delivery</p>
  </div>
  <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; max-width: 1200px; margin: 3rem auto;">
    <div style="text-align: center; padding: 2rem; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
      <div style="width: 60px; height: 60px; background: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
        <i class="fas fa-calendar-check" style="color: white; font-size: 1.5rem;"></i>
      </div>
      <h3 style="margin-bottom: 1rem;">Book Appointment</h3>
      <p>Schedule your service online or call us directly</p>
    </div>
    <div style="text-align: center; padding: 2rem; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
      <div style="width: 60px; height: 60px; background: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
        <i class="fas fa-car" style="color: white; font-size: 1.5rem;"></i>
      </div>
      <h3 style="margin-bottom: 1rem;">Vehicle Drop-off</h3>
      <p>Drop your vehicle at our workshop</p>
    </div>
    <div style="text-align: center; padding: 2rem; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
      <div style="width: 60px; height: 60px; background: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
        <i class="fas fa-tools" style="color: white; font-size: 1.5rem;"></i>
      </div>
      <h3 style="margin-bottom: 1rem;">Service & Repair</h3>
      <p>Expert technicians work on your vehicle</p>
    </div>
    <div style="text-align: center; padding: 2rem; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
      <div style="width: 60px; height: 60px; background: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
        <i class="fas fa-check-circle" style="color: white; font-size: 1.5rem;"></i>
      </div>
      <h3 style="margin-bottom: 1rem;">Quality Check</h3>
      <p>Thorough inspection before delivery</p>
    </div>
  </div>
</section>

<section class="testimonials" style="padding: 6rem 5%; background: var(--light);">
  <div class="section-title">
    <h2>What Our Customers Say</h2>
    <p>Trusted by car owners across Sri Lanka</p>
  </div>
  <div class="testimonials-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem; margin-top: 3rem;">
    <div class="testimonial-card" style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
      <div style="display: flex; align-items: center; margin-bottom: 1rem;">
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
      </div>
      <p style="font-style: italic; margin-bottom: 1rem;">"TuneShift provided exceptional service. Their attention to detail and professional approach made all the difference. Highly recommended!"</p>
      <div style="font-weight: 600;">- Kamal Perera</div>
      <div style="color: #666; font-size: 0.9rem;">Toyota Corolla Owner</div>
    </div>
    <div class="testimonial-card" style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
      <div style="display: flex; align-items: center; margin-bottom: 1rem;">
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
      </div>
      <p style="font-style: italic; margin-bottom: 1rem;">"The team at TuneShift is incredibly knowledgeable and professional. They fixed my car's issues quickly and efficiently."</p>
      <div style="font-weight: 600;">- Nimal Silva</div>
      <div style="color: #666; font-size: 0.9rem;">Honda Civic Owner</div>
    </div>
    <div class="testimonial-card" style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05);">
      <div style="display: flex; align-items: center; margin-bottom: 1rem;">
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
        <i class="fas fa-star" style="color: #FFD700;"></i>
      </div>
      <p style="font-style: italic; margin-bottom: 1rem;">"Best car service in Colombo! Their 24/7 support has been a lifesaver. Very reliable and trustworthy service."</p>
      <div style="font-weight: 600;">- Priya Fernando</div>
      <div style="color: #666; font-size: 0.9rem;">Suzuki Swift Owner</div>
    </div>
  </div>
</section>

<section class="faq" style="padding: 6rem 5%; background: white;">
  <div class="section-title">
    <h2>Frequently Asked Questions</h2>
    <p>Find answers to common questions</p>
  </div>
  <div style="max-width: 800px; margin: 3rem auto;">
    <div style="margin-bottom: 1.5rem; border: 1px solid #eee; border-radius: 8px; overflow: hidden;">
      <div style="padding: 1.5rem; background: var(--light); cursor: pointer;" onclick="toggleFAQ(this)">
        <h3 style="margin: 0; display: flex; justify-content: space-between; align-items: center;">
          How often should I service my car?
          <i class="fas fa-chevron-down"></i>
        </h3>
      </div>
      <div style="padding: 1.5rem; display: none;">
        <p>We recommend servicing your car every 5,000 to 7,500 kilometers or every 6 months, whichever comes first. Regular maintenance helps prevent major issues and keeps your vehicle running efficiently.</p>
      </div>
    </div>
    <div style="margin-bottom: 1.5rem; border: 1px solid #eee; border-radius: 8px; overflow: hidden;">
      <div style="padding: 1.5rem; background: var(--light); cursor: pointer;" onclick="toggleFAQ(this)">
        <h3 style="margin: 0; display: flex; justify-content: space-between; align-items: center;">
          Do you offer warranty on your services?
          <i class="fas fa-chevron-down"></i>
        </h3>
      </div>
      <div style="padding: 1.5rem; display: none;">
        <p>Yes, we offer a 6-month warranty on all our services and parts. This warranty covers any defects in workmanship or parts failure under normal operating conditions.</p>
      </div>
    </div>
    <div style="margin-bottom: 1.5rem; border: 1px solid #eee; border-radius: 8px; overflow: hidden;">
      <div style="padding: 1.5rem; background: var(--light); cursor: pointer;" onclick="toggleFAQ(this)">
        <h3 style="margin: 0; display: flex; justify-content: space-between; align-items: center;">
          How long does a typical service take?
          <i class="fas fa-chevron-down"></i>
        </h3>
      </div>
      <div style="padding: 1.5rem; display: none;">
        <p>A standard service typically takes 2-3 hours. However, the duration may vary depending on the type of service and any additional repairs needed. We'll provide you with an estimated completion time when you book your service.</p>
      </div>
    </div>
  </div>
</section>

<section class="contact" id="contact">
  <div class="section-title">
    <h2>Contact Us</h2>
    <p>Get in touch with our expert team for all your automotive needs</p>
  </div>
  <div class="contact-grid">
    <div class="contact-info">
      <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Visit Our Workshop</h3>
      <p style="margin-bottom: 1.5rem;">
        <i class="fas fa-map-marker-alt" style="color: var(--primary); margin-right: 10px;"></i>
        123 Auto Care Road<br>
        Colombo 05, Sri Lanka
      </p>
      <p style="margin-bottom: 1.5rem;">
        <i class="fas fa-phone" style="color: var(--primary); margin-right: 10px;"></i> +94 77 123 4567<br>
        <i class="fas fa-envelope" style="color: var(--primary); margin-right: 10px;"></i> contact@tuneshift.lk
      </p>
      <div style="margin-bottom: 1.5rem;">
        <h4 style="margin-bottom: 1rem;">Business Hours</h4>
        <p>Monday - Friday: 8:00 AM - 6:00 PM</p>
        <p>Saturday: 8:00 AM - 1:00 PM</p>
        <p>Sunday: Closed</p>
      </div>
      <div class="social-links">
        <a href="#" style="margin-right: 1rem;"><i class="fab fa-facebook fa-2x"></i></a>
        <a href="#" style="margin-right: 1rem;"><i class="fab fa-whatsapp fa-2x"></i></a>
        <a href="#" style="margin-right: 1rem;"><i class="fab fa-instagram fa-2x"></i></a>
      </div>
    </div>
    <div class="contact-form">
      <h3 style="margin-bottom: 1.5rem;">Send Message</h3>
      <form>
        <input type="text" placeholder="Your Name" style="width: 100%; padding: 1rem; margin-bottom: 1rem; border: 1px solid #ddd; border-radius: 5px;">
        <input type="email" placeholder="Email Address" style="width: 100%; padding: 1rem; margin-bottom: 1rem; border: 1px solid #ddd; border-radius: 5px;">
        <input type="tel" placeholder="Phone Number" style="width: 100%; padding: 1rem; margin-bottom: 1rem; border: 1px solid #ddd; border-radius: 5px;">
        <select style="width: 100%; padding: 1rem; margin-bottom: 1rem; border: 1px solid #ddd; border-radius: 5px;">
          <option value="">Select Service Type</option>
          <option value="maintenance">Regular Maintenance</option>
          <option value="repair">Engine Repair</option>
          <option value="electrical">Electrical Systems</option>
          <option value="other">Other Services</option>
        </select>
        <textarea rows="5" placeholder="Your Message" style="width: 100%; padding: 1rem; margin-bottom: 1.5rem; border: 1px solid #ddd; border-radius: 5px;"></textarea>
        <button style="background: var(--primary); color: white; border: none; padding: 1rem 2rem; border-radius: 5px; cursor: pointer; width: 100%; transition: background 0.3s ease;">Send Message</button>
      </form>
    </div>
  </div>
</section>

<footer class="footer">
  <div class="footer-content">
    <div>
      <h3>TuneShift</h3>
      <p>Your trusted automotive partner</p>
    </div>
    <div>
      <h3>Quick Links</h3>
      <a href="#home">Home</a><br>
      <a href="#services">Services</a><br>
      <a href="#contact">Contact</a>
    </div>
    <div>
      <h3>Business Hours</h3>
      <p>Mon-Fri: 8:00 AM - 6:00 PM<br>
        Sat: 8:00 AM - 1:00 PM<br>
        Sun: Closed</p>
    </div>
  </div>
  <div style="text-align: center; margin-top: 3rem; padding-top: 2rem; border-top: 1px solid #444;">
    <p>© 2023 TuneShift. All rights reserved</p>
  </div>
</footer>

<script>
  // Scroll Animations
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if(entry.isIntersecting) {
        entry.target.classList.add('animate');
      }
    });
  }, { threshold: 0.1 });

  // Observe all animated elements
  document.querySelectorAll('.section-title, .service-card, .feature-card').forEach(el => {
    observer.observe(el);
  });

  // Navbar Scroll Effect
  window.addEventListener('scroll', () => {
    const navbar = document.querySelector('.navbar');
    window.scrollY > 50 ? navbar.classList.add('scrolled') : navbar.classList.remove('scrolled');
  });

  // Smooth Scroll
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      e.preventDefault();
      document.querySelector(this.getAttribute('href')).scrollIntoView({
        behavior: 'smooth'
      });
    });
  });

  // FAQ Toggle Function
  function toggleFAQ(element) {
    const content = element.nextElementSibling;
    const icon = element.querySelector('i');
    
    if (content.style.display === 'block') {
      content.style.display = 'none';
      icon.style.transform = 'rotate(0deg)';
    } else {
      content.style.display = 'block';
      icon.style.transform = 'rotate(180deg)';
    }
  }

  // Add hover effects to buttons
  document.querySelectorAll('.btn').forEach(btn => {
    btn.addEventListener('mouseover', function() {
      this.style.transform = 'translateY(-2px)';
      this.style.boxShadow = '0 5px 15px rgba(0,0,0,0.2)';
    });
    
    btn.addEventListener('mouseout', function() {
      this.style.transform = 'translateY(0)';
      this.style.boxShadow = 'none';
    });
  });
</script>
</body>
</html>