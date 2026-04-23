class PortfolioData {
  // Personal Details
  static const String name = "Basith Creation";
  static const String fullName = "Abdul Basith";
  static const String title = "Flutter Developer";
  static const String email = "abbasith222@gmail.com";
  static const String location = "Hawalli, Kuwait";
  static const String aboutShort = "I build apps that feel fast and beautiful.";
  static const String aboutLong =
      "I am a passionate Flutter developer with a knack for creating beautiful, responsive, and performant mobile and web applications. With a strong foundation in Dart and a keen eye for design, I transform ideas into seamless digital experiences.";

  // Social Links
  static const String githubUrl = "https://github.com/basithcreation";
  static const String linkedinUrl =
      "https://www.linkedin.com/in/abdul-basith200";
  static const String resumeUrl = ""; // Add URL if available

  // Profile Image (Asset path)
  static const String profileImage = "images/profile.jpg"; // Placeholder

  // Statistics
  static const List<StatItem> stats = [
    StatItem(count: "2+", label: "Years Exp"),
    StatItem(count: "10+", label: "Apps Built"),
    StatItem(count: "100%", label: "Satisfaction"),
  ];

  // Skills
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: "Flutter & Dart",
      skills: ["Flutter", "Dart", "Widget Lifecycle", "Performance Profiling"],
    ),
    SkillCategory(
      title: "State Management",
      skills: ["Riverpod", "Provider", "GetX"],
    ),
    SkillCategory(
      title: "Backend & API",
      skills: ["Firebase", "REST APIs", "Cloud Functions", "Supabase"],
    ),
    SkillCategory(
      title: "Tools & UI",
      skills: ["Git", "Figma", "Adobe XD", "CI/CD"],
    ),
  ];

  // Experience
  static const List<TimelineItem> experience = [
    TimelineItem(
      title: "Flutter Developer",
      subtitle: "KPOST Courier Co., Kuwait",
      period: "2023 - Present",
      description:
          "Designed and developed the KPOST HR application, a full-featured enterprise system supporting attendance, ticketing, leave management, and overall HR operations. Integrated APIs, improved UI/UX, and ensured performance and scalability.",
    ),
    TimelineItem(
      title: "Application Support Engineer",
      subtitle: "Syrma SGS, Bengaluru, India",
      period: "2021 - 2023",
      description:
          "Provided end-to-end application support including issue troubleshooting, system monitoring, and incident resolution. Assisted users, resolved bugs, and collaborated with development teams to enhance application performance and reliability.",
    ),
    TimelineItem(
      title: "B.Sc. Computer Science",
      subtitle: "Jamal Mohamed College, Tiruchirappalli",
      period: "2017 - 2021",
      description:
          "Completed Bachelor's degree with a strong foundation in software development, data structures, and algorithms. Gained practical experience in mobile app development and problem-solving.",
    ),
  ];

  // Projects
  // static const List<Project> projects = [
  //   Project(
  //     id: "kpost-hr",
  //     title: "KPOST HR Application",
  //     description:
  //         "Developed a complete HR management system for KPOST Courier including attendance tracking, leave management, ticketing system, employee profile handling, and document uploads. Integrated REST APIs with secure authentication and role-based access.",
  //     tags: ["Flutter", "PHP", "MySQL", "REST API"],
  //     imageUrl: "assets/projects/kpost_hr.png",
  //     screenshots: [
  //       "assets/projects/kpost_hr/login_image.jpeg",
  //       "images/hr2.jpg",
  //       "images/hr2.jpg",
  //       "images/hr2.jpg",
  //     ],
  //   ),
  //   Project(
  //     id: "kpost-it",
  //     title: "KPOST IT Management App",
  //     description:
  //         "Built an internal IT management system to track company assets, device allocation, issue reporting, and maintenance requests. Improved IT operations efficiency with real-time updates and admin controls.",
  //     tags: ["Flutter", "API", "MySQL"],
  //     imageUrl: "assets/projects/kpost_it.png",
  //   ),
  //   Project(
  //     id: "ecommerce-app",
  //     title: "E-Commerce Application",
  //     description:
  //         "Developed a mobile e-commerce application with product listing, cart system, user authentication, and order management. Focused on smooth UI/UX and scalable backend integration.",
  //     tags: ["Flutter", "Firebase / API", "UI/UX"],
  //     imageUrl: "assets/projects/ecommerce.png",
  //   ),
  //   Project(
  //     id: "weather-app",
  //     title: "Weather App",
  //     description:
  //         "Created a weather forecasting app using external APIs to display real-time weather data, temperature, and location-based forecasts with a clean and responsive UI.",
  //     tags: ["Flutter", "REST API", "weatherapi"],
  //     imageUrl: "assets/projects/weather.png",
  //   ),
  // ];
  static const List<Project> projects = [
    Project(
      id: "kpost-hr",
      title: "KPOST HR Application",
      description:
          "Developed a complete HR management system for KPOST Courier including attendance tracking, leave management, ticketing system, employee profile handling, and document uploads. Integrated REST APIs with secure authentication and role-based access.",
      tags: [
        "Flutter",
        "PHP",
        "MySQL",
        "REST API",
        "Firebase - Push Notification",
        "Google Maps API",
      ],
      imageUrl: "assets/projects/kpost_hr/kpost_hr_application.png",
      screenshots: [
        "assets/projects/kpost_hr/login_image.jpeg",
        "assets/projects/kpost_hr/home1.jpeg",
        "assets/projects/kpost_hr/home2.jpeg",
        "assets/projects/kpost_hr/attendance_report.jpeg",
        "assets/projects/kpost_hr/break_request.jpeg",
        "assets/projects/kpost_hr/create_ticketing.jpeg",
        "assets/projects/kpost_hr/hub1.jpeg",
        "assets/projects/kpost_hr/hub2.jpeg",
        "assets/projects/kpost_hr/notification.jpeg",
        "assets/projects/kpost_hr/personal.jpeg",
        "assets/projects/kpost_hr/profile_edit.jpeg",
        "assets/projects/kpost_hr/profile.jpeg",
      ],
    ),
    Project(
      id: "kpost-it",
      title: "KPOST IT Management App",
      description:
          "Built an internal IT management system to track company assets, device allocation, issue reporting, and maintenance requests. Improved IT operations efficiency with real-time updates and admin controls.",
      tags: ["Flutter", "API", "MySQL"],
      imageUrl: "assets/projects/kpost_it/kpost_it_management.png",
    ),
    Project(
      id: "e-commerce",
      title: "ShopEasy",
      description:
          "A multi-vendor e-commerce platform with real-time order tracking and payment gateway integration.",
      tags: ["Flutter", "Clean Arch", "Stripe", "Firebase - Google"],
      imageUrl: "assets/projects/shopeasy/ShopEasy_e_commerce.png",
      githubUrl: "https://github.com/basithcreation/shopeasy",
    ),
    Project(
      id: "weather-app",
      title: "Weather App",
      description:
          "Created a weather forecasting app using external APIs to display real-time weather data, temperature, and location-based forecasts with a clean and responsive UI.",
      tags: ["Flutter", "REST API", "weatherapi"],
      imageUrl: "assets/projects/weather/Aakash_Weather_App.png",
    ),
    Project(
      id: "travel-buddy",
      title: "TravelBuddy",
      description:
          "Travel planning assistance with itinerary generation and map integration.",
      tags: ["Flutter", "Google Maps API", "AI"],
      imageUrl: "assets/projects/travel_app.png",
    ),
  ];
}

// Models
class StatItem {
  final String count;
  final String label;

  const StatItem({required this.count, required this.label});
}

class SkillCategory {
  final String title;
  final List<String> skills;

  const SkillCategory({required this.title, required this.skills});
}

class TimelineItem {
  final String title;
  final String subtitle;
  final String period;
  final String description;

  const TimelineItem({
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
  });
}

class Project {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final String? githubUrl;
  final String? liveUrl;
  final List<String> screenshots;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.imageUrl,
    this.githubUrl,
    this.liveUrl,
    this.screenshots = const [],
  });
}
