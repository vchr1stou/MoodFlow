import 'package:flutter/material.dart';
import '../presentation/ai_screen/ai_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/beneathlittlelifts_one_screen/beneathlittlelifts_one_screen.dart';
import '../presentation/beneathlittlelifts_three_screen/beneathlittlelifts_three_screen.dart';
import '../presentation/beneathlittlelifts_two_screen/beneathlittlelifts_two_screen.dart';
import '../presentation/book_screen/book_screen.dart';
import '../presentation/breathingdone_screen/breathingdone_screen.dart';
import '../presentation/breathingmain_screen/breathingmain_screen.dart';
import '../presentation/cooking_screen/cooking_screen.dart';
import '../presentation/discover_screen/discover_screen.dart';
import '../presentation/emoji_log_five_screen/emoji_log_five_screen.dart';
import '../presentation/emoji_log_four_screen/emoji_log_four_screen.dart';
import '../presentation/emoji_log_one_screen/emoji_log_one_screen.dart';
import '../presentation/emoji_log_three_screen/emoji_log_three_screen.dart';
import '../presentation/emoji_log_two_screen/emoji_log_two_screen.dart';
import '../presentation/final_set_up_screen/final_set_up_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/history_empty_screen/history_empty_screen.dart';
import '../presentation/history_filled_screen/history_filled_screen.dart';
import '../presentation/history_preview_screen/history_preview_screen.dart';
import '../presentation/homescreen_screen/homescreen_screen.dart';
import '../presentation/inhale_screen/inhale_screen.dart';
import '../presentation/little_lifts_screen/little_lifts_screen.dart';
import '../presentation/log_input_ai_screen/log_input_ai_screen.dart';
import '../presentation/log_input_colors_screen/log_input_colors_screen.dart';
import '../presentation/log_input_screen/log_input_screen.dart';
import '../presentation/log_screen/log_screen.dart';
import '../presentation/log_screen_step_2_positive_screen/log_screen_step_2_positive_screen.dart';
import '../presentation/log_screen_step_3_no_positive_screen/log_screen_step_3_no_positive_screen.dart';
import '../presentation/log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';
import '../presentation/log_screen_step_five_screen/log_screen_step_five_screen.dart';
import '../presentation/log_screen_step_four_screen/log_screen_step_four_screen.dart';
import '../presentation/logged_input_ai_screen/logged_input_ai_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/meditation_screen/meditation_screen.dart';
import '../presentation/movies_screen/movies_screen.dart';
import '../presentation/music_screen/music_screen.dart';
import '../presentation/porfile_acessibility_settings_screen/porfile_acessibility_settings_screen.dart';
import '../presentation/positiveaffirmations_screen/positiveaffirmations_screen.dart';
import '../presentation/profile_change_pin_1st_step_screen/profile_change_pin_1st_step_screen.dart';
import '../presentation/profile_change_pin_2nd_step_screen/profile_change_pin_2nd_step_screen.dart';
import '../presentation/profile_delete_pin_screen/profile_delete_pin_screen.dart';
import '../presentation/profile_gentle_reminders_screen/profile_gentle_reminders_screen.dart';
import '../presentation/profile_my_account_screen/profile_my_account_screen.dart';
import '../presentation/profile_pin_setted_screen/profile_pin_setted_screen.dart';
import '../presentation/profile_safety_net_screen/profile_safety_net_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/profile_set_new_pin_1st_step_screen/profile_set_new_pin_1st_step_screen.dart';
import '../presentation/profile_set_new_pin_2nd_step_screen/profile_set_new_pin_2nd_step_screen.dart';
import '../presentation/profile_set_pin_first_time_screen/profile_set_pin_first_time_screen.dart';
import '../presentation/profile_spotify_screen/profile_spotify_screen.dart';
import '../presentation/reset_password_screen/reset_password_screen.dart';
import '../presentation/safetynetlittlelifts_screen/safetynetlittlelifts_screen.dart';
import '../presentation/saved_preview_screen/saved_preview_screen.dart';
import '../presentation/saved_screen/saved_screen.dart';
import '../presentation/sign_up_step_3_filled_screen/sign_up_step_3_filled_screen.dart';
import '../presentation/sign_up_step_four_screen/sign_up_step_four_screen.dart';
import '../presentation/sign_up_step_one_screen/sign_up_step_one_screen.dart';
import '../presentation/sign_up_step_three_screen/sign_up_step_three_screen.dart';
import '../presentation/sign_up_step_two_screen/sign_up_step_two_screen.dart';
import '../presentation/softthanks_screen/softthanks_screen.dart';
import '../presentation/statistics_mood_charts_screen/statistics_mood_charts_screen.dart';
import '../presentation/streak_screen/streak_screen.dart';
import '../presentation/traveling_screen/traveling_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/workout_screen/workout_screen.dart';

class AppRoutes {
  static const String discoverScreen = '/discover_screen';
  static const String homescreenScreen = '/homescreen_screen';
  static const String streakScreen = '/streak_screen';
  static const String aiScreen = '/ai_screen';
  static const String logInputScreen = '/log_input_screen';
  static const String logInputColorsScreen = '/log_input_colors_screen';
  static const String logInputAiScreen = '/log_input_ai_screen';
  static const String loggedInputAiScreen = '/logged_input_ai_screen';
  static const String emojiLogOneScreen = '/emoji_log_one_screen';
  static const String emojiLogTwoScreen = '/emoji_log_two_screen';
  static const String emojiLogThreeScreen = '/emoji_log_three_screen';
  static const String emojiLogFourScreen = '/emoji_log_four_screen';
  static const String emojiLogFiveScreen = '/emoji_log_five_screen';
  static const String profileScreen = '/profile_screen';
  static const String porfileAcessibilitySettingsScreen =
      '/porfile_acessibility_settings_screen';
  static const String profileGentleRemindersScreen =
      '/profile_gentle_reminders_screen';
  static const String profileSafetyNetScreen = '/profile_safety_net_screen';
  static const String profileMyAccountScreen = '/profile_my_account_screen';
  static const String profileSpotifyScreen = '/profile_spotify_screen';
  static const String welcomeScreen = '/welcome_screen';
  static const String loginScreen = '/login_screen';
  static const String signUpStepOneScreen = '/sign_up_step_one_screen';
  static const String signUpStepTwoScreen = '/sign_up_step_two_screen';
  static const String signUpStepThreeScreen = '/sign_up_step_three_screen';
  static const String signUpStep3FilledScreen = '/sign_up_step_3_filled_screen';
  static const String signUpStepFourScreen = '/sign_up_step_four_screen';
  static const String finalSetUpScreen = '/final_set_up_screen';
  static const String littleLiftsScreen = '/little_lifts_screen';
  static const String littleLiftsInitialPage = '/little_lifts_initial_page';
  static const String moviesScreen = '/movies_screen';
  static const String bookScreen = '/book_screen';
  static const String cookingScreen = '/cooking_screen';
  static const String safetynetlittleliftsScreen =
      '/safetynetlittlelifts_screen';
  static const String savedScreen = '/saved_screen';
  static const String savedPreviewScreen = '/saved_preview_screen';
  static const String breathingmainScreen = '/breathingmain_screen';
  static const String inhaleScreen = '/inhale_screen';
  static const String breathingdoneScreen = '/breathingdone_screen';
  static const String logScreen = '/log_screen';
  static const String logScreenStep2PositiveScreen =
      '/log_screen_step_2_positive_screen';
  static const String logscreenstepTabPage = '/logscreenstep_tab_page';
  static const String logScreenStep2NegativePage =
      '/log_screen_step_2_negative_page';
  static const String logScreenStep3PositiveScreen =
      '/log_screen_step_3_positive_screen';
  static const String logscreenstepTab1Page = '/logscreenstep_tab1_page';
  static const String logScreenStep3PositiveOnePage =
      '/log_screen_step_3_positive_one_page';
  static const String logScreenStepFourScreen = '/log_screen_step_four_screen';
  static const String logScreenStepFiveScreen = '/log_screen_step_five_screen';
  static const String logScreenStep3NoPositiveScreen =
      '/log_screen_step_3_no_positive_screen';
  static const String logscreenstepTab2Page = '/logscreenstep_tab2_page';
  static const String logScreenStep3NoNegativePage =
      '/log_screen_step_3_no_negative_page';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String profileSetPinFirstTimeScreen =
      '/profile_set_pin_first_time_screen';
  static const String profilePinSettedScreen = '/profile_pin_setted_screen';
  static const String profileChangePin1stStepScreen =
      '/profile_change_pin_1st_step_screen';
  static const String profileChangePin2ndStepScreen =
      '/profile_change_pin_2nd_step_screen';
  static const String profileSetNewPin2ndStepScreen =
      '/profile_set_new_pin_2nd_step_screen';
  static const String profileSetNewPin1stStepScreen =
      '/profile_set_new_pin_1st_step_screen';
  static const String meditationScreen = '/meditation_screen';
  static const String travelingScreen = '/traveling_screen';
  static const String musicScreen = '/music_screen';
  static const String positiveaffirmationsScreen =
      '/positiveaffirmations_screen';
  static const String workoutScreen = '/workout_screen';
  static const String softthanksScreen = '/softthanks_screen';
  static const String beneathlittleliftsOneScreen =
      '/beneathlittlelifts_one_screen';
  static const String beneathlittleliftsTwoScreen =
      '/beneathlittlelifts_two_screen';
  static const String beneathlittleliftsThreeScreen =
      '/beneathlittlelifts_three_screen';
  static const String profileDeletePinScreen = '/profile_delete_pin_screen';
  static const String historyEmptyScreen = '/history_empty_screen';
  static const String historyFilledScreen = '/history_filled_screen';
  static const String historyPreviewScreen = '/history_preview_screen';
  static const String statisticsMoodChartsScreen =
      '/statistics_mood_charts_screen';
  static const String statisticsmoodTabPage = '/statisticsmood_tab_page';
  static const String statisticsMoodDriversPage =
      '/statistics_mood_drivers_page';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        discoverScreen: DiscoverScreen.builder,
        homescreenScreen: HomescreenScreen.builder,
        streakScreen: StreakScreen.builder,
        aiScreen: AiScreen.builder,
        logInputScreen: LogInputScreen.builder,
        logInputColorsScreen: LogInputColorsScreen.builder,
        logInputAiScreen: LogInputAiScreen.builder,
        loggedInputAiScreen: LoggedInputAiScreen.builder,
        emojiLogOneScreen: EmojiLogOneScreen.builder,
        emojiLogTwoScreen: EmojiLogTwoScreen.builder,
        emojiLogThreeScreen: EmojiLogThreeScreen.builder,
        emojiLogFourScreen: EmojiLogFourScreen.builder,
        emojiLogFiveScreen: (context) => const EmojiLogFiveScreen(),
        profileScreen: ProfileScreen.builder,
        porfileAcessibilitySettingsScreen:
            PorfileAcessibilitySettingsScreen.builder,
        profileGentleRemindersScreen: ProfileGentleRemindersScreen.builder,
        profileSafetyNetScreen: ProfileSafetyNetScreen.builder,
        profileMyAccountScreen: ProfileMyAccountScreen.builder,
        profileSpotifyScreen: ProfileSpotifyScreen.builder,
        welcomeScreen: WelcomeScreen.builder,
        loginScreen: LoginScreen.builder,
        signUpStepOneScreen: SignUpStepOneScreen.builder,
        signUpStepTwoScreen: SignUpStepTwoScreen.builder,
        signUpStepThreeScreen: SignUpStepThreeScreen.builder,
        signUpStep3FilledScreen: SignUpStep3FilledScreen.builder,
        signUpStepFourScreen: SignUpStepFourScreen.builder,
        finalSetUpScreen: FinalSetUpScreen.builder,
        littleLiftsScreen: LittleLiftsScreen.builder,
        moviesScreen: MoviesScreen.builder,
        bookScreen: BookScreen.builder,
        cookingScreen: CookingScreen.builder,
        safetynetlittleliftsScreen: SafetynetlittleliftsScreen.builder,
        savedScreen: SavedScreen.builder,
        savedPreviewScreen: SavedPreviewScreen.builder,
        breathingmainScreen: BreathingmainScreen.builder,
        inhaleScreen: InhaleScreen.builder,
        breathingdoneScreen: BreathingdoneScreen.builder,
        logScreen: LogScreen.builder,
        logScreenStep2PositiveScreen: LogScreenStep2PositiveScreen.builder,
        logScreenStep3PositiveScreen: LogScreenStep3PositiveScreen.builder,
        logScreenStepFourScreen: LogScreenStepFourScreen.builder,
        logScreenStepFiveScreen: LogScreenStepFiveScreen.builder,
        logScreenStep3NoPositiveScreen: LogScreenStep3NoPositiveScreen.builder,
        forgotPasswordScreen: ForgotPasswordScreen.builder,
        resetPasswordScreen: ResetPasswordScreen.builder,
        profileSetPinFirstTimeScreen: ProfileSetPinFirstTimeScreen.builder,
        profilePinSettedScreen: ProfilePinSettedScreen.builder,
        profileChangePin1stStepScreen: ProfileChangePin1stStepScreen.builder,
        profileChangePin2ndStepScreen: ProfileChangePin2ndStepScreen.builder,
        profileSetNewPin2ndStepScreen: ProfileSetNewPin2ndStepScreen.builder,
        profileSetNewPin1stStepScreen: ProfileSetNewPin1stStepScreen.builder,
        meditationScreen: MeditationScreen.builder,
        travelingScreen: TravelingScreen.builder,
        musicScreen: MusicScreen.builder,
        positiveaffirmationsScreen: PositiveaffirmationsScreen.builder,
        workoutScreen: WorkoutScreen.builder,
        softthanksScreen: SoftthanksScreen.builder,
        beneathlittleliftsOneScreen: BeneathlittleliftsOneScreen.builder,
        beneathlittleliftsTwoScreen: BeneathlittleliftsTwoScreen.builder,
        beneathlittleliftsThreeScreen: BeneathlittleliftsThreeScreen.builder,
        profileDeletePinScreen: ProfileDeletePinScreen.builder,
        historyEmptyScreen: HistoryEmptyScreen.builder,
        historyFilledScreen: HistoryFilledScreen.builder,
        historyPreviewScreen: HistoryPreviewScreen.builder,
        statisticsMoodChartsScreen: StatisticsMoodChartsScreen.builder,
        appNavigationScreen: AppNavigationScreen.builder,
        initialRoute: WelcomeScreen.builder,
      };
}
