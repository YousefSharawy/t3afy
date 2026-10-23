import 'package:flutter/material.dart';

/// One icon family (Material Rounded) for the whole app.
/// Replaces the old multicolor PNG clipart.
/// Brand artwork (logo, social marks, bot avatar, onboarding) stays as assets.
class AppIcons {
  // Navigation
  static const home = Icons.home_rounded;
  static const tasks = Icons.assignment_rounded;
  static const map = Icons.map_rounded;
  static const performance = Icons.insights_rounded;
  static const bot = Icons.smart_toy_rounded;
  static const group = Icons.groups_rounded;
  static const group2 = Icons.group_rounded;
  static const campaigns = Icons.campaign_rounded;
  static const reports = Icons.fact_check_rounded;
  static const notification = Icons.notifications_rounded;

  // People
  static const person = Icons.person_rounded;
  static const admin = Icons.admin_panel_settings_rounded;
  static const boy = Icons.face_rounded;
  static const vol = Icons.volunteer_activism_rounded;
  static const vol2 = Icons.diversity_3_rounded;
  static const volHome = Icons.volunteer_activism_rounded;
  static const mentor = Icons.supervisor_account_rounded;

  // Fields / auth
  static const email = Icons.mail_rounded;
  static const email2 = Icons.alternate_email_rounded;
  static const password = Icons.lock_rounded;
  static const visibilityon = Icons.visibility_rounded;
  static const visibilityoff = Icons.visibility_off_rounded;
  static const phone = Icons.phone_rounded;
  static const call = Icons.call_rounded;
  static const message = Icons.chat_bubble_rounded;
  static const send = Icons.send_rounded;
  static const search = Icons.search_rounded;

  // Task / campaign meta
  static const location = Icons.location_on_rounded;
  static const calendar = Icons.calendar_today_rounded;
  static const alarm = Icons.schedule_rounded;
  static const hours = Icons.timelapse_rounded;
  static const camp = Icons.event_rounded;
  static const camp2 = Icons.event_available_rounded;
  static const details = Icons.description_rounded;
  static const requirements = Icons.inventory_2_rounded;
  static const books = Icons.menu_book_rounded;
  static const hospital = Icons.local_hospital_rounded;
  static const laptop = Icons.laptop_rounded;
  static const gift = Icons.redeem_rounded;
  static const flag = Icons.flag_rounded;
  static const target = Icons.track_changes_rounded;

  // Achievement — render these in ColorManager.star only when earned
  static const star = Icons.star_rounded;
  static const unstar = Icons.star_outline_rounded;
  static const trophy = Icons.emoji_events_rounded;
  static const medal = Icons.military_tech_rounded;
  static const commit = Icons.verified_rounded;
  static const fast = Icons.bolt_rounded;
  static const promotion = trendUp;

  // Trend arrows must NOT mirror in RTL (Material's versions do, so "up"
  // rendered as "down" in Arabic). Same glyphs, matchTextDirection off.
  static const trendUp = IconData(0xf0254, fontFamily: 'MaterialIcons');
  static const trendDown = IconData(0xf0252, fontFamily: 'MaterialIcons');
  static const trendFlat = IconData(0xf0253, fontFamily: 'MaterialIcons');

  // Status
  static const done = Icons.check_circle_rounded;
  static const done2 = Icons.task_alt_rounded;
  static const warning = Icons.warning_amber_rounded;
  static const announcement = Icons.campaign_rounded;
  static const pause = Icons.pause_circle_rounded;

  // Actions
  static const add = Icons.add_rounded;
  static const add2 = Icons.add_circle_rounded;
  static const add3 = Icons.person_add_alt_1_rounded;
  static const edit = Icons.edit_rounded;
  static const settings = Icons.settings_rounded;
  static const x = Icons.close_rounded;
  static const back = Icons.arrow_back_rounded; // auto-mirrors in RTL
  static const chevron = Icons.chevron_right_rounded; // auto-mirrors in RTL
  static const logout = Icons.logout_rounded;
  static const pdf = Icons.picture_as_pdf_rounded;
  static const refresh = Icons.refresh_rounded;
  static const offline = Icons.cloud_off_rounded;
  static const empty = Icons.inbox_rounded;
  static const checkIn = Icons.login_rounded;
  static const checkOut = Icons.logout_rounded;
  static const gps = Icons.my_location_rounded;
  static const brokenImage = Icons.broken_image_rounded;

  /// Icon for a campaign / task type (same mapping as before, rounded family).
  static IconData taskType(String type) => switch (type) {
    'توعية مدرسية' => Icons.school_rounded,
    'توعية جامعية' => Icons.account_balance_rounded,
    'زيارة ميدانية' => Icons.map_rounded,
    'حملة توعوية' => Icons.campaign_rounded,
    'ورشة عمل' => Icons.handyman_rounded,
    'فعالية مجتمعية' => Icons.groups_rounded,
    'تدريب' => Icons.model_training_rounded,
    _ => Icons.event_note_rounded,
  };
}
